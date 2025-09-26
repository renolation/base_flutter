import 'package:flutter/foundation.dart';
import '../hive_service.dart';
import '../models/user_preferences.dart';

/// Repository for managing user preferences using Hive
class UserPreferencesRepository {
  static const String _defaultKey = 'current_user_preferences';

  /// Get the current user preferences (alias for getUserPreferences)
  UserPreferences? getPreferences([String? userId]) {
    return getUserPreferences(userId);
  }

  /// Get the current user preferences
  UserPreferences? getUserPreferences([String? userId]) {
    try {
      final box = HiveService.userDataBox;
      final key = userId ?? _defaultKey;

      final preferences = box.get(key);
      if (preferences == null) return null;

      // Check if preferences need migration
      if (preferences.needsMigration()) {
        final migratedPreferences = preferences.migrate();
        saveUserPreferences(migratedPreferences, userId);
        return migratedPreferences;
      }

      return preferences;
    } catch (e, stackTrace) {
      debugPrint('Error getting user preferences: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Save user preferences
  Future<void> saveUserPreferences(UserPreferences preferences, [String? userId]) async {
    try {
      final box = HiveService.userDataBox;
      final key = userId ?? _defaultKey;

      final updatedPreferences = preferences.copyWith(lastUpdated: DateTime.now());
      await box.put(key, updatedPreferences);

      debugPrint('✅ User preferences saved for key: $key');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving user preferences: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Create new user preferences
  Future<UserPreferences> createUserPreferences({
    required String userId,
    required String displayName,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    List<String>? favoriteItems,
  }) async {
    final userPreferences = UserPreferences.create(
      userId: userId,
      displayName: displayName,
      email: email,
      avatarUrl: avatarUrl,
      preferences: preferences,
      favoriteItems: favoriteItems,
    );

    await saveUserPreferences(userPreferences, userId);
    return userPreferences;
  }

  /// Update user profile information
  Future<void> updateProfile({
    String? userId,
    String? displayName,
    String? email,
    String? avatarUrl,
  }) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      displayName: displayName ?? currentPreferences.displayName,
      email: email ?? currentPreferences.email,
      avatarUrl: avatarUrl ?? currentPreferences.avatarUrl,
    );

    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Set a user preference
  Future<void> setPreference(String key, dynamic value, [String? userId]) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.setPreference(key, value);
    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Get a user preference with type safety
  T getPreference<T>(String key, T defaultValue, [String? userId]) {
    final preferences = getUserPreferences(userId);
    if (preferences == null) return defaultValue;

    return preferences.getPreference<T>(key, defaultValue);
  }

  /// Remove a user preference
  Future<void> removePreference(String key, [String? userId]) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.removePreference(key);
    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Add item to favorites
  Future<void> addFavorite(String itemId, [String? userId]) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.addFavorite(itemId);
    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Remove item from favorites
  Future<void> removeFavorite(String itemId, [String? userId]) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.removeFavorite(itemId);
    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Check if item is favorite
  bool isFavorite(String itemId, [String? userId]) {
    final preferences = getUserPreferences(userId);
    return preferences?.isFavorite(itemId) ?? false;
  }

  /// Get all favorite items
  List<String> getFavorites([String? userId]) {
    final preferences = getUserPreferences(userId);
    return preferences?.favoriteItems ?? [];
  }

  /// Update last accessed time for an item
  Future<void> updateLastAccessed(String itemId, [String? userId]) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.updateLastAccessed(itemId);
    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Get last accessed time for an item
  DateTime? getLastAccessed(String itemId, [String? userId]) {
    final preferences = getUserPreferences(userId);
    return preferences?.getLastAccessed(itemId);
  }

  /// Get recently accessed items
  List<String> getRecentlyAccessed({int limit = 10, String? userId}) {
    final preferences = getUserPreferences(userId);
    return preferences?.getRecentlyAccessed(limit: limit) ?? [];
  }

  /// Clean old access records
  Future<void> cleanOldAccess({int maxAgeDays = 30, String? userId}) async {
    final currentPreferences = getUserPreferences(userId);
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.cleanOldAccess(maxAgeDays: maxAgeDays);
    await saveUserPreferences(updatedPreferences, userId);
  }

  /// Get user statistics
  Map<String, dynamic> getUserStats([String? userId]) {
    final preferences = getUserPreferences(userId);
    return preferences?.getStats() ?? {};
  }

  /// Export user preferences to Map (for backup)
  Map<String, dynamic> exportUserPreferences([String? userId]) {
    try {
      final preferences = getUserPreferences(userId);
      return preferences?.toMap() ?? {};
    } catch (e) {
      debugPrint('❌ Error exporting user preferences: $e');
      return {};
    }
  }

  /// Import user preferences from Map (for restore)
  Future<bool> importUserPreferences(Map<String, dynamic> preferencesMap, [String? userId]) async {
    try {
      final preferences = UserPreferences.fromMap(preferencesMap);
      await saveUserPreferences(preferences, userId);
      debugPrint('✅ User preferences imported successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error importing user preferences: $e');
      return false;
    }
  }

  /// Check if user preferences exist
  bool hasUserPreferences([String? userId]) {
    try {
      final box = HiveService.userDataBox;
      final key = userId ?? _defaultKey;
      return box.containsKey(key);
    } catch (e) {
      debugPrint('❌ Error checking user preferences existence: $e');
      return false;
    }
  }

  /// Clear user preferences (use with caution)
  Future<void> clearUserPreferences([String? userId]) async {
    try {
      final box = HiveService.userDataBox;
      final key = userId ?? _defaultKey;
      await box.delete(key);
      debugPrint('✅ User preferences cleared for key: $key');
    } catch (e) {
      debugPrint('❌ Error clearing user preferences: $e');
      rethrow;
    }
  }

  /// Get all user IDs that have preferences stored
  List<String> getAllUserIds() {
    try {
      final box = HiveService.userDataBox;
      return box.keys.cast<String>().where((key) => key != _defaultKey).toList();
    } catch (e) {
      debugPrint('❌ Error getting all user IDs: $e');
      return [];
    }
  }

  /// Delete preferences for a specific user
  Future<void> deleteUserPreferences(String userId) async {
    try {
      final box = HiveService.userDataBox;
      await box.delete(userId);
      debugPrint('✅ User preferences deleted for user: $userId');
    } catch (e) {
      debugPrint('❌ Error deleting user preferences: $e');
      rethrow;
    }
  }

  /// Get multiple users' preferences
  Map<String, UserPreferences> getMultipleUserPreferences(List<String> userIds) {
    final result = <String, UserPreferences>{};

    for (final userId in userIds) {
      final preferences = getUserPreferences(userId);
      if (preferences != null) {
        result[userId] = preferences;
      }
    }

    return result;
  }

  /// Validate user preferences
  bool validateUserPreferences(UserPreferences preferences) {
    try {
      // Basic validation
      if (preferences.userId.isEmpty) return false;
      if (preferences.displayName.isEmpty) return false;
      if (preferences.version < 1) return false;

      return true;
    } catch (e) {
      debugPrint('❌ Error validating user preferences: $e');
      return false;
    }
  }

  /// Watch user preferences changes
  Stream<UserPreferences?> watchUserPreferences([String? userId]) {
    try {
      final box = HiveService.userDataBox;
      final key = userId ?? _defaultKey;
      return box.watch(key: key).map((event) => event.value as UserPreferences?);
    } catch (e) {
      debugPrint('❌ Error watching user preferences: $e');
      return Stream.value(null);
    }
  }

  /// Compact user preferences storage
  Future<void> compact() async {
    try {
      final box = HiveService.userDataBox;
      await box.compact();
      debugPrint('✅ User preferences storage compacted');
    } catch (e) {
      debugPrint('❌ Error compacting user preferences: $e');
    }
  }

  /// Get storage statistics
  Map<String, dynamic> getStorageStats() {
    try {
      final box = HiveService.userDataBox;
      final allUserIds = getAllUserIds();

      return {
        'totalUsers': allUserIds.length,
        'hasDefaultUser': hasUserPreferences(),
        'totalEntries': box.length,
        'userIds': allUserIds,
      };
    } catch (e) {
      debugPrint('❌ Error getting storage stats: $e');
      return {};
    }
  }
}