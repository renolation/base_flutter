import 'package:hive/hive.dart';

part 'cache_item.g.dart';

/// Generic cache wrapper for storing any data with expiration logic
@HiveType(typeId: 1)
class CacheItem extends HiveObject {
  @HiveField(0)
  @override
  final String key;

  @HiveField(1)
  final dynamic data;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime expiresAt;

  @HiveField(4)
  final String dataType; // Type identifier for runtime type safety

  @HiveField(5)
  final Map<String, dynamic>? metadata; // Additional cache metadata

  @HiveField(6)
  final int version; // Cache version for migration support

  CacheItem({
    required this.key,
    required this.data,
    required this.createdAt,
    required this.expiresAt,
    required this.dataType,
    this.metadata,
    this.version = 1,
  });

  /// Create a new cache item with expiration time
  factory CacheItem.create({
    required String key,
    required dynamic data,
    required Duration expirationDuration,
    Map<String, dynamic>? metadata,
    int version = 1,
  }) {
    final now = DateTime.now();
    return CacheItem(
      key: key,
      data: data,
      createdAt: now,
      expiresAt: now.add(expirationDuration),
      dataType: data.runtimeType.toString(),
      metadata: metadata,
      version: version,
    );
  }

  /// Create a cache item that never expires
  factory CacheItem.permanent({
    required String key,
    required dynamic data,
    Map<String, dynamic>? metadata,
    int version = 1,
  }) {
    final now = DateTime.now();
    return CacheItem(
      key: key,
      data: data,
      createdAt: now,
      expiresAt: DateTime(9999), // Far future date
      dataType: data.runtimeType.toString(),
      metadata: metadata,
      version: version,
    );
  }

  /// Check if the cache item is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if the cache item is still valid
  bool get isValid {
    return !isExpired;
  }

  /// Get the age of the cache item
  Duration get age {
    return DateTime.now().difference(createdAt);
  }

  /// Get time remaining until expiration
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  /// Check if cache item will expire within the given duration
  bool willExpireWithin(Duration duration) {
    final checkTime = DateTime.now().add(duration);
    return expiresAt.isBefore(checkTime);
  }

  /// Create a refreshed copy with new expiration time
  CacheItem refresh(Duration newExpirationDuration) {
    final now = DateTime.now();
    return CacheItem(
      key: key,
      data: data,
      createdAt: createdAt, // Keep original creation time
      expiresAt: now.add(newExpirationDuration),
      dataType: dataType,
      metadata: metadata,
      version: version,
    );
  }

  /// Create a copy with updated data
  CacheItem updateData(dynamic newData, {Duration? newExpirationDuration}) {
    final now = DateTime.now();
    return CacheItem(
      key: key,
      data: newData,
      createdAt: now, // Update creation time for new data
      expiresAt: newExpirationDuration != null
          ? now.add(newExpirationDuration)
          : expiresAt,
      dataType: dataType,
      metadata: metadata,
      version: version,
    );
  }

  /// Create a copy with updated metadata
  CacheItem updateMetadata(Map<String, dynamic> newMetadata) {
    return CacheItem(
      key: key,
      data: data,
      createdAt: createdAt,
      expiresAt: expiresAt,
      dataType: dataType,
      metadata: {...(metadata ?? {}), ...newMetadata},
      version: version,
    );
  }

  /// Get metadata value
  V? getMetadata<V>(String key) {
    return metadata?[key] as V?;
  }

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'dataType': dataType,
      'metadata': metadata,
      'version': version,
    };
  }

  /// Create from Map (useful for migration or external data)
  static CacheItem fromMap(Map<String, dynamic> map) {
    return CacheItem(
      key: map['key'] as String,
      data: map['data'],
      createdAt: DateTime.parse(map['createdAt'] as String),
      expiresAt: DateTime.parse(map['expiresAt'] as String),
      dataType: map['dataType'] as String,
      metadata: map['metadata']?.cast<String, dynamic>(),
      version: map['version'] as int? ?? 1,
    );
  }

  @override
  String toString() {
    return 'CacheItem{key: $key, dataType: $dataType, createdAt: $createdAt, '
           'expiresAt: $expiresAt, isExpired: $isExpired, version: $version}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CacheItem &&
        other.key == key &&
        other.data == data &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.dataType == dataType &&
        _mapEquals(other.metadata, metadata) &&
        other.version == version;
  }

  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      key,
      data,
      createdAt,
      expiresAt,
      dataType,
      metadata?.hashCode ?? 0,
      version,
    );
  }
}

/// Cache statistics for monitoring cache performance
class CacheStats {
  final int totalItems;
  final int validItems;
  final int expiredItems;
  final DateTime oldestItem;
  final DateTime newestItem;
  final Map<String, int> typeCount;

  const CacheStats({
    required this.totalItems,
    required this.validItems,
    required this.expiredItems,
    required this.oldestItem,
    required this.newestItem,
    required this.typeCount,
  });

  double get hitRate {
    if (totalItems == 0) return 0.0;
    return validItems / totalItems;
  }

  double get expirationRate {
    if (totalItems == 0) return 0.0;
    return expiredItems / totalItems;
  }

  Map<String, dynamic> toMap() {
    return {
      'totalItems': totalItems,
      'validItems': validItems,
      'expiredItems': expiredItems,
      'oldestItem': oldestItem.toIso8601String(),
      'newestItem': newestItem.toIso8601String(),
      'typeCount': typeCount,
      'hitRate': hitRate,
      'expirationRate': expirationRate,
    };
  }

  @override
  String toString() {
    return 'CacheStats{total: $totalItems, valid: $validItems, expired: $expiredItems, '
           'hitRate: ${(hitRate * 100).toStringAsFixed(1)}%, '
           'types: ${typeCount.keys.join(', ')}}';
  }
}