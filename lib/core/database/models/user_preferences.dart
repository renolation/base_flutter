import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

/// User preferences model for storing user-specific settings and data
@HiveType(typeId: 2)
class UserPreferences extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String displayName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? avatarUrl;

  @HiveField(4)
  final Map<String, dynamic> preferences;

  @HiveField(5)
  final List<String> favoriteItems;

  @HiveField(6)
  final Map<String, DateTime> lastAccessed;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime lastUpdated;

  @HiveField(9)
  final int version;

  UserPreferences({
    required this.userId,
    required this.displayName,
    this.email,
    this.avatarUrl,
    this.preferences = const {},
    this.favoriteItems = const [],
    this.lastAccessed = const {},
    required this.createdAt,
    required this.lastUpdated,
    this.version = 1,
  });

  /// Create a new user preferences instance
  factory UserPreferences.create({
    required String userId,
    required String displayName,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    List<String>? favoriteItems,
  }) {
    final now = DateTime.now();
    return UserPreferences(
      userId: userId,
      displayName: displayName,
      email: email,
      avatarUrl: avatarUrl,
      preferences: preferences ?? {},
      favoriteItems: favoriteItems ?? [],
      lastAccessed: {},
      createdAt: now,
      lastUpdated: now,
      version: 1,
    );
  }

  /// Create default user preferences for anonymous user
  factory UserPreferences.anonymous() {
    final now = DateTime.now();
    return UserPreferences(
      userId: 'anonymous',
      displayName: 'Anonymous User',
      preferences: _getDefaultPreferences(),
      favoriteItems: [],
      lastAccessed: {},
      createdAt: now,
      lastUpdated: now,
      version: 1,
    );
  }

  /// Get default preferences
  static Map<String, dynamic> _getDefaultPreferences() {
    return {
      // UI Preferences
      'compactMode': false,
      'showThumbnails': true,
      'gridColumns': 2,
      'sortBy': 'name',
      'sortOrder': 'asc', // 'asc' or 'desc'

      // Notification Preferences
      'pushNotifications': true,
      'emailNotifications': false,
      'notificationTypes': ['updates', 'recommendations'],

      // Privacy Preferences
      'analyticsOptIn': false,
      'shareUsageData': false,
      'personalizedRecommendations': true,

      // Content Preferences
      'autoPlay': false,
      'highQualityImages': true,
      'downloadQuality': 'medium', // 'low', 'medium', 'high'
      'cacheSize': 500, // MB

      // Accessibility
      'textSize': 'normal', // 'small', 'normal', 'large'
      'highContrast': false,
      'reduceAnimations': false,
    };
  }

  /// Create a copy with modified fields
  UserPreferences copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    List<String>? favoriteItems,
    Map<String, DateTime>? lastAccessed,
    DateTime? createdAt,
    DateTime? lastUpdated,
    int? version,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferences: preferences ?? this.preferences,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      version: version ?? this.version,
    );
  }

  /// Get a preference value with type safety
  T getPreference<T>(String key, T defaultValue) {
    final value = preferences[key];
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  /// Set a preference value
  UserPreferences setPreference(String key, dynamic value) {
    final updatedPreferences = Map<String, dynamic>.from(preferences);
    updatedPreferences[key] = value;

    return copyWith(
      preferences: updatedPreferences,
      lastUpdated: DateTime.now(),
    );
  }

  /// Remove a preference
  UserPreferences removePreference(String key) {
    final updatedPreferences = Map<String, dynamic>.from(preferences);
    updatedPreferences.remove(key);

    return copyWith(
      preferences: updatedPreferences,
      lastUpdated: DateTime.now(),
    );
  }

  /// Add item to favorites
  UserPreferences addFavorite(String itemId) {
    if (favoriteItems.contains(itemId)) return this;

    final updatedFavorites = List<String>.from(favoriteItems);
    updatedFavorites.add(itemId);

    return copyWith(
      favoriteItems: updatedFavorites,
      lastUpdated: DateTime.now(),
    );
  }

  /// Remove item from favorites
  UserPreferences removeFavorite(String itemId) {
    if (!favoriteItems.contains(itemId)) return this;

    final updatedFavorites = List<String>.from(favoriteItems);
    updatedFavorites.remove(itemId);

    return copyWith(
      favoriteItems: updatedFavorites,
      lastUpdated: DateTime.now(),
    );
  }

  /// Check if item is favorite
  bool isFavorite(String itemId) {
    return favoriteItems.contains(itemId);
  }

  /// Update last accessed time for an item
  UserPreferences updateLastAccessed(String itemId) {
    final updatedLastAccessed = Map<String, DateTime>.from(lastAccessed);
    updatedLastAccessed[itemId] = DateTime.now();

    return copyWith(
      lastAccessed: updatedLastAccessed,
      lastUpdated: DateTime.now(),
    );
  }

  /// Get last accessed time for an item
  DateTime? getLastAccessed(String itemId) {
    return lastAccessed[itemId];
  }

  /// Get recently accessed items (sorted by most recent)
  List<String> getRecentlyAccessed({int limit = 10}) {
    final entries = lastAccessed.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).map((e) => e.key).toList();
  }

  /// Clean old last accessed entries (older than specified days)
  UserPreferences cleanOldAccess({int maxAgeDays = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: maxAgeDays));
    final updatedLastAccessed = Map<String, DateTime>.from(lastAccessed);

    updatedLastAccessed.removeWhere((key, value) => value.isBefore(cutoffDate));

    return copyWith(
      lastAccessed: updatedLastAccessed,
      lastUpdated: DateTime.now(),
    );
  }

  /// Get user statistics
  Map<String, dynamic> getStats() {
    return {
      'userId': userId,
      'displayName': displayName,
      'totalFavorites': favoriteItems.length,
      'totalAccessedItems': lastAccessed.length,
      'recentlyAccessed': getRecentlyAccessed(limit: 5),
      'accountAge': DateTime.now().difference(createdAt).inDays,
      'lastActive': lastUpdated,
      'preferences': preferences.keys.length,
    };
  }

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'preferences': preferences,
      'favoriteItems': favoriteItems,
      'lastAccessed': lastAccessed.map((k, v) => MapEntry(k, v.toIso8601String())),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'version': version,
    };
  }

  /// Create from Map for JSON deserialization
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      userId: map['userId'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      favoriteItems: List<String>.from(map['favoriteItems'] ?? []),
      lastAccessed: (map['lastAccessed'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, DateTime.parse(v as String))) ?? {},
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
      version: map['version'] as int? ?? 1,
    );
  }

  /// Check if preferences need migration
  bool needsMigration() {
    const currentVersion = 1;
    return version < currentVersion;
  }

  /// Migrate preferences to current version
  UserPreferences migrate() {
    if (!needsMigration()) return this;

    var migrated = this;

    // Add migration logic here as needed
    // Example:
    // if (version < 2) {
    //   migrated = _migrateToVersion2(migrated);
    // }

    return migrated.copyWith(version: 1);
  }

  @override
  String toString() {
    return 'UserPreferences{userId: $userId, displayName: $displayName, '
           'favorites: ${favoriteItems.length}, preferences: ${preferences.keys.length}, '
           'lastUpdated: $lastUpdated}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserPreferences &&
        other.userId == userId &&
        other.displayName == displayName &&
        other.email == email &&
        other.avatarUrl == avatarUrl &&
        _mapEquals(other.preferences, preferences) &&
        _listEquals(other.favoriteItems, favoriteItems) &&
        _dateMapEquals(other.lastAccessed, lastAccessed) &&
        other.createdAt == createdAt &&
        other.lastUpdated == lastUpdated &&
        other.version == version;
  }

  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _dateMapEquals(Map<String, DateTime> a, Map<String, DateTime> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      displayName,
      email,
      avatarUrl,
      preferences.hashCode,
      favoriteItems.hashCode,
      lastAccessed.hashCode,
      createdAt,
      lastUpdated,
      version,
    );
  }
}