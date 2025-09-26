import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/app_settings.dart';
import 'models/cache_item.dart';
import 'models/user_preferences.dart';

/// Hive database service for initialization and box management
class HiveService {
  static const String _appSettingsBoxName = 'appSettingsBox';
  static const String _cacheBoxName = 'cacheBox';
  static const String _userDataBoxName = 'userDataBox';

  // Private boxes - access through getters
  static Box<AppSettings>? _appSettingsBox;
  static Box<CacheItem>? _cacheBox;
  static Box<UserPreferences>? _userDataBox;

  /// Initialize Hive database
  static Future<void> initialize() async {
    try {
      // Initialize Hive for Flutter
      await Hive.initFlutter();

      // Register type adapters
      await _registerAdapters();

      // Open boxes
      await _openBoxes();

      debugPrint('✅ Hive initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize Hive: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Register all Hive type adapters
  static Future<void> _registerAdapters() async {
    // Register adapters only if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CacheItemAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserPreferencesAdapter());
    }
  }

  /// Open all required Hive boxes
  static Future<void> _openBoxes() async {
    try {
      _appSettingsBox = await Hive.openBox<AppSettings>(_appSettingsBoxName);
      _cacheBox = await Hive.openBox<CacheItem>(_cacheBoxName);
      _userDataBox = await Hive.openBox<UserPreferences>(_userDataBoxName);
    } catch (e) {
      debugPrint('Error opening Hive boxes: $e');
      rethrow;
    }
  }

  /// Get app settings box
  static Box<AppSettings> get appSettingsBox {
    if (_appSettingsBox == null || !_appSettingsBox!.isOpen) {
      throw StateError('AppSettings box is not initialized. Call HiveService.initialize() first.');
    }
    return _appSettingsBox!;
  }

  /// Get cache box
  static Box<CacheItem> get cacheBox {
    if (_cacheBox == null || !_cacheBox!.isOpen) {
      throw StateError('Cache box is not initialized. Call HiveService.initialize() first.');
    }
    return _cacheBox!;
  }

  /// Get user data box
  static Box<UserPreferences> get userDataBox {
    if (_userDataBox == null || !_userDataBox!.isOpen) {
      throw StateError('UserData box is not initialized. Call HiveService.initialize() first.');
    }
    return _userDataBox!;
  }

  /// Check if Hive is initialized
  static bool get isInitialized {
    return _appSettingsBox != null &&
           _cacheBox != null &&
           _userDataBox != null &&
           _appSettingsBox!.isOpen &&
           _cacheBox!.isOpen &&
           _userDataBox!.isOpen;
  }

  /// Close all boxes (call this when app is terminated)
  static Future<void> closeAll() async {
    try {
      await _appSettingsBox?.close();
      await _cacheBox?.close();
      await _userDataBox?.close();
      debugPrint('✅ All Hive boxes closed successfully');
    } catch (e) {
      debugPrint('❌ Error closing Hive boxes: $e');
    }
  }

  /// Clear all data (use with caution - for testing or reset functionality)
  static Future<void> clearAll() async {
    try {
      await _appSettingsBox?.clear();
      await _cacheBox?.clear();
      await _userDataBox?.clear();
      debugPrint('✅ All Hive boxes cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing Hive boxes: $e');
      rethrow;
    }
  }

  /// Compact all boxes to optimize storage
  static Future<void> compactAll() async {
    try {
      await _appSettingsBox?.compact();
      await _cacheBox?.compact();
      await _userDataBox?.compact();
      debugPrint('✅ All Hive boxes compacted successfully');
    } catch (e) {
      debugPrint('❌ Error compacting Hive boxes: $e');
    }
  }

  /// Get database statistics
  static Map<String, dynamic> getStats() {
    return {
      'isInitialized': isInitialized,
      'appSettingsCount': _appSettingsBox?.length ?? 0,
      'cacheItemsCount': _cacheBox?.length ?? 0,
      'userDataCount': _userDataBox?.length ?? 0,
    };
  }

  /// Perform database migration if needed
  static Future<void> migrate() async {
    try {
      // Check current version and migrate if needed
      final currentVersion = _appSettingsBox?.get('db_version')?.version ?? 1;
      const latestVersion = 1;

      if (currentVersion < latestVersion) {
        await _performMigration(currentVersion, latestVersion);
      }
    } catch (e) {
      debugPrint('❌ Error during database migration: $e');
    }
  }

  /// Perform database migration from one version to another
  static Future<void> _performMigration(int fromVersion, int toVersion) async {
    debugPrint('🔄 Migrating database from version $fromVersion to $toVersion');

    // Add migration logic here as needed
    // Example:
    // if (fromVersion < 2) {
    //   await _migrateToVersion2();
    // }

    // Update database version
    await _appSettingsBox?.put('db_version', AppSettings(
      version: toVersion,
      themeMode: 'system',
      locale: 'en',
      lastUpdated: DateTime.now(),
    ));

    debugPrint('✅ Database migration completed');
  }
}