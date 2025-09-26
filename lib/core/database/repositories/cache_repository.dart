import 'package:flutter/foundation.dart';
import '../hive_service.dart';
import '../models/cache_item.dart';

/// Repository for managing cached data using Hive
class CacheRepository {
  /// Store data in cache with expiration
  Future<void> put<T>({
    required String key,
    required T data,
    required Duration expirationDuration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = CacheItem.create(
        key: key,
        data: data,
        expirationDuration: expirationDuration,
        metadata: metadata,
      );
      await box.put(key, cacheItem);
      debugPrint('✅ Cache item stored: $key');
    } catch (e, stackTrace) {
      debugPrint('❌ Error storing cache item $key: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Store permanent data in cache (never expires)
  Future<void> putPermanent<T>({
    required String key,
    required T data,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = CacheItem.permanent(
        key: key,
        data: data,
        metadata: metadata,
      );
      await box.put(key, cacheItem);
      debugPrint('✅ Permanent cache item stored: $key');
    } catch (e, stackTrace) {
      debugPrint('❌ Error storing permanent cache item $key: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get data from cache
  T? get<T>(String key) {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = box.get(key);

      if (cacheItem == null) {
        debugPrint('📭 Cache miss: $key');
        return null;
      }

      if (cacheItem.isExpired) {
        debugPrint('⏰ Cache expired: $key');
        // Optionally remove expired item
        delete(key);
        return null;
      }

      debugPrint('✅ Cache hit: $key');
      return cacheItem.data as T?;
    } catch (e) {
      debugPrint('❌ Error getting cache item $key: $e');
      return null;
    }
  }

  /// Get cache item with full metadata
  CacheItem? getCacheItem(String key) {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = box.get(key);

      if (cacheItem == null) {
        return null;
      }

      if (cacheItem.isExpired) {
        // Optionally remove expired item
        delete(key);
        return null;
      }

      return cacheItem;
    } catch (e) {
      debugPrint('❌ Error getting cache item $key: $e');
      return null;
    }
  }

  /// Check if key exists and is valid (not expired)
  bool contains(String key) {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = box.get(key);

      if (cacheItem == null) return false;
      if (cacheItem.isExpired) {
        delete(key);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ Error checking cache item $key: $e');
      return false;
    }
  }

  /// Check if key exists regardless of expiration
  bool containsKey(String key) {
    try {
      final box = HiveService.cacheBox;
      return box.containsKey(key);
    } catch (e) {
      debugPrint('❌ Error checking key $key: $e');
      return false;
    }
  }

  /// Delete specific cache item
  Future<void> delete(String key) async {
    try {
      final box = HiveService.cacheBox;
      await box.delete(key);
      debugPrint('🗑️ Cache item deleted: $key');
    } catch (e) {
      debugPrint('❌ Error deleting cache item $key: $e');
    }
  }

  /// Delete multiple cache items
  Future<void> deleteMultiple(List<String> keys) async {
    try {
      final box = HiveService.cacheBox;
      for (final key in keys) {
        await box.delete(key);
      }
      debugPrint('🗑️ Multiple cache items deleted: ${keys.length} items');
    } catch (e) {
      debugPrint('❌ Error deleting multiple cache items: $e');
    }
  }

  /// Clear all expired items
  Future<int> cleanExpiredItems() async {
    return await clearExpired();
  }

  /// Clear all expired items
  Future<int> clearExpired() async {
    try {
      final box = HiveService.cacheBox;
      final expiredKeys = <String>[];
      final now = DateTime.now();

      for (final key in box.keys) {
        final cacheItem = box.get(key);
        if (cacheItem != null && now.isAfter(cacheItem.expiresAt)) {
          expiredKeys.add(key as String);
        }
      }

      for (final key in expiredKeys) {
        await box.delete(key);
      }

      debugPrint('🧹 Cleared ${expiredKeys.length} expired cache items');
      return expiredKeys.length;
    } catch (e) {
      debugPrint('❌ Error clearing expired items: $e');
      return 0;
    }
  }

  /// Clear all cache items
  Future<void> clearAll() async {
    try {
      final box = HiveService.cacheBox;
      final count = box.length;
      await box.clear();
      debugPrint('🧹 Cleared all cache items: $count items');
    } catch (e) {
      debugPrint('❌ Error clearing all cache items: $e');
      rethrow;
    }
  }

  /// Clear cache items by pattern
  Future<int> clearByPattern(Pattern pattern) async {
    try {
      final box = HiveService.cacheBox;
      final keysToDelete = <String>[];

      for (final key in box.keys) {
        if (key is String && key.contains(pattern)) {
          keysToDelete.add(key);
        }
      }

      for (final key in keysToDelete) {
        await box.delete(key);
      }

      debugPrint('🧹 Cleared ${keysToDelete.length} cache items matching pattern: $pattern');
      return keysToDelete.length;
    } catch (e) {
      debugPrint('❌ Error clearing cache items by pattern: $e');
      return 0;
    }
  }

  /// Clear cache items by type
  Future<int> clearByType(String dataType) async {
    try {
      final box = HiveService.cacheBox;
      final keysToDelete = <String>[];

      for (final key in box.keys) {
        final cacheItem = box.get(key);
        if (cacheItem != null && cacheItem.dataType == dataType) {
          keysToDelete.add(key as String);
        }
      }

      for (final key in keysToDelete) {
        await box.delete(key);
      }

      debugPrint('🧹 Cleared ${keysToDelete.length} cache items of type: $dataType');
      return keysToDelete.length;
    } catch (e) {
      debugPrint('❌ Error clearing cache items by type: $e');
      return 0;
    }
  }

  /// Refresh cache item with new expiration
  Future<bool> refresh(String key, Duration newExpirationDuration) async {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = box.get(key);

      if (cacheItem == null) return false;

      final refreshedItem = cacheItem.refresh(newExpirationDuration);
      await box.put(key, refreshedItem);

      debugPrint('🔄 Cache item refreshed: $key');
      return true;
    } catch (e) {
      debugPrint('❌ Error refreshing cache item $key: $e');
      return false;
    }
  }

  /// Update cache item data
  Future<bool> update<T>(String key, T newData, {Duration? newExpirationDuration}) async {
    try {
      final box = HiveService.cacheBox;
      final cacheItem = box.get(key);

      if (cacheItem == null) return false;

      final updatedItem = cacheItem.updateData(newData, newExpirationDuration: newExpirationDuration);
      await box.put(key, updatedItem);

      debugPrint('📝 Cache item updated: $key');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating cache item $key: $e');
      return false;
    }
  }

  /// Get all keys in cache
  List<String> getAllKeys() {
    try {
      final box = HiveService.cacheBox;
      return box.keys.cast<String>().toList();
    } catch (e) {
      debugPrint('❌ Error getting all keys: $e');
      return [];
    }
  }

  /// Get keys by pattern
  List<String> getKeysByPattern(Pattern pattern) {
    try {
      final box = HiveService.cacheBox;
      return box.keys
          .cast<String>()
          .where((key) => key.contains(pattern))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting keys by pattern: $e');
      return [];
    }
  }

  /// Get keys by data type
  List<String> getKeysByType(String dataType) {
    try {
      final box = HiveService.cacheBox;
      final keys = <String>[];

      for (final key in box.keys) {
        final cacheItem = box.get(key);
        if (cacheItem != null && cacheItem.dataType == dataType) {
          keys.add(key as String);
        }
      }

      return keys;
    } catch (e) {
      debugPrint('❌ Error getting keys by type: $e');
      return [];
    }
  }

  /// Get cache statistics
  CacheStats getStats() {
    try {
      final box = HiveService.cacheBox;
      final now = DateTime.now();
      var validItems = 0;
      var expiredItems = 0;
      DateTime? oldestItem;
      DateTime? newestItem;
      final typeCount = <String, int>{};

      for (final key in box.keys) {
        final cacheItem = box.get(key);
        if (cacheItem == null) continue;

        // Count by expiration status
        if (now.isAfter(cacheItem.expiresAt)) {
          expiredItems++;
        } else {
          validItems++;
        }

        // Track oldest and newest items
        if (oldestItem == null || cacheItem.createdAt.isBefore(oldestItem)) {
          oldestItem = cacheItem.createdAt;
        }
        if (newestItem == null || cacheItem.createdAt.isAfter(newestItem)) {
          newestItem = cacheItem.createdAt;
        }

        // Count by type
        typeCount[cacheItem.dataType] = (typeCount[cacheItem.dataType] ?? 0) + 1;
      }

      return CacheStats(
        totalItems: box.length,
        validItems: validItems,
        expiredItems: expiredItems,
        oldestItem: oldestItem ?? DateTime.now(),
        newestItem: newestItem ?? DateTime.now(),
        typeCount: typeCount,
      );
    } catch (e) {
      debugPrint('❌ Error getting cache stats: $e');
      return CacheStats(
        totalItems: 0,
        validItems: 0,
        expiredItems: 0,
        oldestItem: DateTime.now(),
        newestItem: DateTime.now(),
        typeCount: const {},
      );
    }
  }

  /// Get cache size in bytes (approximate)
  int getApproximateSize() {
    try {
      final box = HiveService.cacheBox;
      // This is an approximation as Hive doesn't provide exact size
      return box.length * 1024; // Assume average 1KB per item
    } catch (e) {
      debugPrint('❌ Error getting cache size: $e');
      return 0;
    }
  }

  /// Compact cache storage
  Future<void> compact() async {
    try {
      final box = HiveService.cacheBox;
      await box.compact();
      debugPrint('✅ Cache storage compacted');
    } catch (e) {
      debugPrint('❌ Error compacting cache: $e');
    }
  }

  /// Export cache data (for debugging or backup)
  Map<String, dynamic> exportCache({bool includeExpired = false}) {
    try {
      final box = HiveService.cacheBox;
      final now = DateTime.now();
      final exportData = <String, dynamic>{};

      for (final key in box.keys) {
        final cacheItem = box.get(key);
        if (cacheItem == null) continue;

        if (!includeExpired && now.isAfter(cacheItem.expiresAt)) {
          continue;
        }

        exportData[key as String] = cacheItem.toMap();
      }

      return exportData;
    } catch (e) {
      debugPrint('❌ Error exporting cache: $e');
      return {};
    }
  }

  /// Watch cache changes for a specific key
  Stream<CacheItem?> watch(String key) {
    try {
      final box = HiveService.cacheBox;
      return box.watch(key: key).map((event) => event.value as CacheItem?);
    } catch (e) {
      debugPrint('❌ Error watching cache key $key: $e');
      return Stream.value(null);
    }
  }

  /// Perform cache maintenance (cleanup expired items, compact storage)
  Future<Map<String, dynamic>> performMaintenance() async {
    try {
      final startTime = DateTime.now();

      // Get stats before maintenance
      final statsBefore = getStats();

      // Clear expired items
      final expiredCount = await clearExpired();

      // Compact storage
      await compact();

      // Get stats after maintenance
      final statsAfter = getStats();

      final maintenanceTime = DateTime.now().difference(startTime);

      final result = {
        'expiredItemsRemoved': expiredCount,
        'itemsBefore': statsBefore.totalItems,
        'itemsAfter': statsAfter.totalItems,
        'maintenanceTimeMs': maintenanceTime.inMilliseconds,
        'completedAt': DateTime.now().toIso8601String(),
      };

      debugPrint('🔧 Cache maintenance completed: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Error during cache maintenance: $e');
      return {'error': e.toString()};
    }
  }
}