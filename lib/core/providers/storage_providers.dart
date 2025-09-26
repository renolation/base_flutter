import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../database/hive_service.dart';
import '../database/models/app_settings.dart';
import '../database/models/cache_item.dart';
import '../database/models/user_preferences.dart';

part 'storage_providers.g.dart';

/// Secure storage configuration
const _secureStorageOptions = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

/// Secure storage provider
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return _secureStorageOptions;
}

/// Secure storage notifier for managing secure data
@riverpod
class SecureStorageNotifier extends _$SecureStorageNotifier {
  late FlutterSecureStorage _storage;

  @override
  Future<Map<String, String>> build() async {
    _storage = ref.read(secureStorageProvider);
    return await _loadAllSecureData();
  }

  Future<Map<String, String>> _loadAllSecureData() async {
    try {
      final allData = await _storage.readAll();
      return allData;
    } catch (e) {
      debugPrint('❌ Error loading secure storage data: $e');
      return {};
    }
  }

  /// Store secure value
  Future<void> store(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      state = AsyncValue.data({...state.value ?? {}, key: value});
      debugPrint('🔐 Securely stored: $key');
    } catch (error, stackTrace) {
      debugPrint('❌ Error storing secure value: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Retrieve secure value
  Future<String?> retrieve(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint('❌ Error retrieving secure value: $e');
      return null;
    }
  }

  /// Delete secure value
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      final currentData = Map<String, String>.from(state.value ?? {});
      currentData.remove(key);
      state = AsyncValue.data(currentData);
      debugPrint('🗑️ Deleted secure key: $key');
    } catch (error, stackTrace) {
      debugPrint('❌ Error deleting secure value: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      state = const AsyncValue.data({});
      debugPrint('🧹 Cleared all secure storage');
    } catch (error, stackTrace) {
      debugPrint('❌ Error clearing secure storage: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint('❌ Error checking key existence: $e');
      return false;
    }
  }

  /// Refresh storage data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _loadAllSecureData());
  }
}

/// Hive storage providers
@riverpod
Box<AppSettings> appSettingsBox(AppSettingsBoxRef ref) {
  return HiveService.appSettingsBox;
}

@riverpod
Box<CacheItem> cacheBox(CacheBoxRef ref) {
  return HiveService.cacheBox;
}

@riverpod
Box<UserPreferences> userPreferencesBox(UserPreferencesBoxRef ref) {
  return HiveService.userDataBox;
}

/// Hive storage notifier for managing Hive data
@riverpod
class HiveStorageNotifier extends _$HiveStorageNotifier {
  @override
  Map<String, dynamic> build() {
    final appSettingsBox = ref.watch(appSettingsBoxProvider);
    final cacheBox = ref.watch(cacheBoxProvider);
    final userPreferencesBox = ref.watch(userPreferencesBoxProvider);

    return {
      'appSettingsCount': appSettingsBox.length,
      'cacheItemsCount': cacheBox.length,
      'userPreferencesCount': userPreferencesBox.length,
      'totalSize': _calculateTotalSize(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  int _calculateTotalSize() {
    try {
      final appSettingsBox = ref.read(appSettingsBoxProvider);
      final cacheBox = ref.read(cacheBoxProvider);
      final userPreferencesBox = ref.read(userPreferencesBoxProvider);

      // Rough estimation of storage size
      return appSettingsBox.length + cacheBox.length + userPreferencesBox.length;
    } catch (e) {
      debugPrint('❌ Error calculating storage size: $e');
      return 0;
    }
  }

  /// Compact all Hive boxes
  Future<void> compactAll() async {
    try {
      final appSettingsBox = ref.read(appSettingsBoxProvider);
      final cacheBox = ref.read(cacheBoxProvider);
      final userPreferencesBox = ref.read(userPreferencesBoxProvider);

      await Future.wait([
        appSettingsBox.compact(),
        cacheBox.compact(),
        userPreferencesBox.compact(),
      ]);

      _updateStats();
      debugPrint('🗜️ Compacted all Hive storage');
    } catch (e) {
      debugPrint('❌ Error compacting storage: $e');
    }
  }

  /// Clear all cache data
  Future<void> clearCache() async {
    try {
      final cacheBox = ref.read(cacheBoxProvider);
      await cacheBox.clear();

      _updateStats();
      debugPrint('🧹 Cleared all cache data');
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }

  /// Get storage statistics
  Map<String, dynamic> getStorageStats() {
    try {
      final appSettingsBox = ref.read(appSettingsBoxProvider);
      final cacheBox = ref.read(cacheBoxProvider);
      final userPreferencesBox = ref.read(userPreferencesBoxProvider);

      return {
        'appSettings': {
          'count': appSettingsBox.length,
          'keys': appSettingsBox.keys.toList(),
          'isEmpty': appSettingsBox.isEmpty,
        },
        'cache': {
          'count': cacheBox.length,
          'keys': cacheBox.keys.take(10).toList(), // Show only first 10 keys
          'isEmpty': cacheBox.isEmpty,
        },
        'userPreferences': {
          'count': userPreferencesBox.length,
          'keys': userPreferencesBox.keys.toList(),
          'isEmpty': userPreferencesBox.isEmpty,
        },
        'total': {
          'items': appSettingsBox.length + cacheBox.length + userPreferencesBox.length,
          'estimatedSize': _calculateTotalSize(),
        },
      };
    } catch (e) {
      debugPrint('❌ Error getting storage stats: $e');
      return {};
    }
  }

  void _updateStats() {
    state = {
      ...state,
      'appSettingsCount': ref.read(appSettingsBoxProvider).length,
      'cacheItemsCount': ref.read(cacheBoxProvider).length,
      'userPreferencesCount': ref.read(userPreferencesBoxProvider).length,
      'totalSize': _calculateTotalSize(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }
}

/// Storage health monitor
@riverpod
class StorageHealthMonitor extends _$StorageHealthMonitor {
  @override
  Map<String, dynamic> build() {
    return {
      'isHealthy': true,
      'lastCheck': DateTime.now().toIso8601String(),
      'errors': <String>[],
      'warnings': <String>[],
    };
  }

  /// Perform storage health check
  Future<void> performHealthCheck() async {
    final errors = <String>[];
    final warnings = <String>[];

    try {
      // Check secure storage
      final secureStorage = ref.read(secureStorageProvider);
      try {
        await secureStorage.containsKey(key: 'health_check');
      } catch (e) {
        errors.add('Secure storage error: $e');
      }

      // Check Hive boxes
      try {
        final appSettingsBox = ref.read(appSettingsBoxProvider);
        final cacheBox = ref.read(cacheBoxProvider);
        final userPreferencesBox = ref.read(userPreferencesBoxProvider);

        if (!appSettingsBox.isOpen) errors.add('App settings box is not open');
        if (!cacheBox.isOpen) errors.add('Cache box is not open');
        if (!userPreferencesBox.isOpen) errors.add('User preferences box is not open');

        // Check for large cache
        if (cacheBox.length > 1000) {
          warnings.add('Cache has more than 1000 items, consider cleanup');
        }
      } catch (e) {
        errors.add('Hive storage error: $e');
      }

      state = {
        'isHealthy': errors.isEmpty,
        'lastCheck': DateTime.now().toIso8601String(),
        'errors': errors,
        'warnings': warnings,
      };

      debugPrint('🏥 Storage health check completed: ${errors.isEmpty ? '✅ Healthy' : '❌ Issues found'}');
    } catch (e) {
      state = {
        'isHealthy': false,
        'lastCheck': DateTime.now().toIso8601String(),
        'errors': ['Health check failed: $e'],
        'warnings': warnings,
      };
    }
  }

  /// Get health status
  bool get isHealthy => state['isHealthy'] ?? false;

  /// Get errors
  List<String> get errors => List<String>.from(state['errors'] ?? []);

  /// Get warnings
  List<String> get warnings => List<String>.from(state['warnings'] ?? []);
}

/// Unified storage manager
@riverpod
class StorageManager extends _$StorageManager {
  @override
  Map<String, dynamic> build() {
    final hiveStats = ref.watch(hiveStorageNotifierProvider);
    final secureStorageAsync = ref.watch(secureStorageNotifierProvider);
    final healthStatus = ref.watch(storageHealthMonitorProvider);

    return {
      'hive': hiveStats,
      'secureStorage': secureStorageAsync.when(
        data: (data) => {
          'keyCount': data.length,
          'isAvailable': true,
        },
        loading: () => {'isAvailable': false, 'isLoading': true},
        error: (_, __) => {'isAvailable': false, 'hasError': true},
      ),
      'health': healthStatus,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  /// Clear all storage
  Future<void> clearAllStorage() async {
    try {
      // Clear secure storage
      await ref.read(secureStorageNotifierProvider.notifier).clearAll();

      // Clear Hive storage
      await ref.read(hiveStorageNotifierProvider.notifier).clearCache();

      debugPrint('🧹 Cleared all storage');
    } catch (e) {
      debugPrint('❌ Error clearing all storage: $e');
    }
  }

  /// Perform maintenance
  Future<void> performMaintenance() async {
    try {
      // Compact storage
      await ref.read(hiveStorageNotifierProvider.notifier).compactAll();

      // Perform health check
      await ref.read(storageHealthMonitorProvider.notifier).performHealthCheck();

      debugPrint('🔧 Storage maintenance completed');
    } catch (e) {
      debugPrint('❌ Error during maintenance: $e');
    }
  }

  /// Get storage overview
  Map<String, dynamic> getStorageOverview() {
    return state;
  }
}