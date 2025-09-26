import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/settings_repository.dart';
import '../repositories/cache_repository.dart';
import '../repositories/user_preferences_repository.dart';
import '../models/app_settings.dart';
import '../models/cache_item.dart';
import '../models/user_preferences.dart';

/// Providers for database repositories and services

/// Settings repository provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// Cache repository provider
final cacheRepositoryProvider = Provider<CacheRepository>((ref) {
  return CacheRepository();
});

/// User preferences repository provider
final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  return UserPreferencesRepository();
});

/// Current app settings provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return AppSettingsNotifier(repository);
});

/// App settings notifier
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  AppSettingsNotifier(this._repository) : super(AppSettings.defaultSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    try {
      state = _repository.getSettings();
    } catch (e) {
      // Keep default settings if loading fails
      state = AppSettings.defaultSettings();
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(String themeMode) async {
    try {
      await _repository.updateThemeMode(themeMode);
      state = state.copyWith(themeMode: themeMode);
    } catch (e) {
      // Handle error - maybe show a snackbar
      rethrow;
    }
  }

  /// Update locale
  Future<void> updateLocale(String locale) async {
    try {
      await _repository.updateLocale(locale);
      state = state.copyWith(locale: locale);
    } catch (e) {
      rethrow;
    }
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) async {
    try {
      await _repository.updateNotificationsEnabled(enabled);
      state = state.copyWith(notificationsEnabled: enabled);
    } catch (e) {
      rethrow;
    }
  }

  /// Update analytics enabled
  Future<void> updateAnalyticsEnabled(bool enabled) async {
    try {
      await _repository.updateAnalyticsEnabled(enabled);
      state = state.copyWith(analyticsEnabled: enabled);
    } catch (e) {
      rethrow;
    }
  }

  /// Update cache strategy
  Future<void> updateCacheStrategy(String strategy) async {
    try {
      await _repository.updateCacheStrategy(strategy);
      state = state.copyWith(cacheStrategy: strategy);
    } catch (e) {
      rethrow;
    }
  }

  /// Update cache expiration hours
  Future<void> updateCacheExpirationHours(int hours) async {
    try {
      await _repository.updateCacheExpirationHours(hours);
      state = state.copyWith(cacheExpirationHours: hours);
    } catch (e) {
      rethrow;
    }
  }

  /// Update auto update enabled
  Future<void> updateAutoUpdateEnabled(bool enabled) async {
    try {
      await _repository.updateAutoUpdateEnabled(enabled);
      state = state.copyWith(autoUpdateEnabled: enabled);
    } catch (e) {
      rethrow;
    }
  }

  /// Set custom setting
  Future<void> setCustomSetting(String key, dynamic value) async {
    try {
      await _repository.setCustomSetting(key, value);
      state = state.setCustomSetting(key, value);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove custom setting
  Future<void> removeCustomSetting(String key) async {
    try {
      await _repository.removeCustomSetting(key);
      state = state.removeCustomSetting(key);
    } catch (e) {
      rethrow;
    }
  }

  /// Reset to default settings
  Future<void> resetToDefault() async {
    try {
      await _repository.resetToDefault();
      state = AppSettings.defaultSettings();
    } catch (e) {
      rethrow;
    }
  }
}

/// Theme mode provider (derived from app settings)
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(appSettingsProvider);
  switch (settings.themeMode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
});

/// Current locale provider (derived from app settings)
final localeProvider = Provider<String>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.locale;
});

/// Notifications enabled provider
final notificationsEnabledProvider = Provider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.notificationsEnabled;
});

/// Analytics enabled provider
final analyticsEnabledProvider = Provider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.analyticsEnabled;
});

/// Cache strategy provider
final cacheStrategyProvider = Provider<String>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.cacheStrategy;
});

/// Cache expiration hours provider
final cacheExpirationHoursProvider = Provider<int>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.cacheExpirationHours;
});

/// Auto update enabled provider
final autoUpdateEnabledProvider = Provider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.autoUpdateEnabled;
});

/// Cache statistics provider
final cacheStatsProvider = FutureProvider<CacheStats>((ref) async {
  final repository = ref.watch(cacheRepositoryProvider);
  return repository.getStats();
});

/// Cache maintenance provider
final cacheMaintenanceProvider = FutureProvider.family<Map<String, dynamic>, bool>(
  (ref, performMaintenance) async {
    if (!performMaintenance) return {};

    final repository = ref.watch(cacheRepositoryProvider);
    return repository.performMaintenance();
  },
);

/// Cache item provider for a specific key
final cacheItemProvider = Provider.family<CacheItem?, String>((ref, key) {
  final repository = ref.watch(cacheRepositoryProvider);
  return repository.getCacheItem(key);
});

/// Cache data provider for a specific key with type safety
final cacheDataProvider = Provider.family<dynamic, String>((ref, key) {
  final repository = ref.watch(cacheRepositoryProvider);
  return repository.get(key);
});

/// Database statistics provider
final databaseStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final cacheRepo = ref.watch(cacheRepositoryProvider);

  final settingsStats = settingsRepo.getSettingsStats();
  final cacheStats = cacheRepo.getStats();

  return {
    'settings': settingsStats,
    'cache': cacheStats.toMap(),
    'totalItems': settingsStats['totalSettingsInBox'] + cacheStats.totalItems,
  };
});

/// Provider to clear expired cache items
final clearExpiredCacheProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(cacheRepositoryProvider);
  return repository.clearExpired();
});

/// Provider to get cache keys by pattern
final cacheKeysByPatternProvider = Provider.family<List<String>, String>((ref, pattern) {
  final repository = ref.watch(cacheRepositoryProvider);
  return repository.getKeysByPattern(pattern);
});

/// Provider to get cache keys by type
final cacheKeysByTypeProvider = Provider.family<List<String>, String>((ref, type) {
  final repository = ref.watch(cacheRepositoryProvider);
  return repository.getKeysByType(type);
});

/// Current user preferences provider
final userPreferencesProvider = StateNotifierProvider.family<UserPreferencesNotifier, UserPreferences?, String?>((ref, userId) {
  final repository = ref.watch(userPreferencesRepositoryProvider);
  return UserPreferencesNotifier(repository, userId);
});

/// User preferences notifier
class UserPreferencesNotifier extends StateNotifier<UserPreferences?> {
  final UserPreferencesRepository _repository;
  final String? _userId;

  UserPreferencesNotifier(this._repository, this._userId) : super(null) {
    _loadUserPreferences();
  }

  void _loadUserPreferences() {
    try {
      state = _repository.getUserPreferences(_userId);
    } catch (e) {
      state = null;
    }
  }

  /// Create new user preferences
  Future<void> createUserPreferences({
    required String userId,
    required String displayName,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    List<String>? favoriteItems,
  }) async {
    try {
      final newPreferences = await _repository.createUserPreferences(
        userId: userId,
        displayName: displayName,
        email: email,
        avatarUrl: avatarUrl,
        preferences: preferences,
        favoriteItems: favoriteItems,
      );
      state = newPreferences;
    } catch (e) {
      rethrow;
    }
  }

  /// Update profile information
  Future<void> updateProfile({
    String? displayName,
    String? email,
    String? avatarUrl,
  }) async {
    if (state == null) return;

    try {
      await _repository.updateProfile(
        userId: _userId,
        displayName: displayName,
        email: email,
        avatarUrl: avatarUrl,
      );

      state = state!.copyWith(
        displayName: displayName ?? state!.displayName,
        email: email ?? state!.email,
        avatarUrl: avatarUrl ?? state!.avatarUrl,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Set preference
  Future<void> setPreference(String key, dynamic value) async {
    if (state == null) return;

    try {
      await _repository.setPreference(key, value, _userId);
      state = state!.setPreference(key, value);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove preference
  Future<void> removePreference(String key) async {
    if (state == null) return;

    try {
      await _repository.removePreference(key, _userId);
      state = state!.removePreference(key);
    } catch (e) {
      rethrow;
    }
  }

  /// Add favorite
  Future<void> addFavorite(String itemId) async {
    if (state == null) return;

    try {
      await _repository.addFavorite(itemId, _userId);
      state = state!.addFavorite(itemId);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove favorite
  Future<void> removeFavorite(String itemId) async {
    if (state == null) return;

    try {
      await _repository.removeFavorite(itemId, _userId);
      state = state!.removeFavorite(itemId);
    } catch (e) {
      rethrow;
    }
  }

  /// Update last accessed
  Future<void> updateLastAccessed(String itemId) async {
    if (state == null) return;

    try {
      await _repository.updateLastAccessed(itemId, _userId);
      state = state!.updateLastAccessed(itemId);
    } catch (e) {
      rethrow;
    }
  }

  /// Clear user preferences
  Future<void> clearPreferences() async {
    try {
      await _repository.clearUserPreferences(_userId);
      state = null;
    } catch (e) {
      rethrow;
    }
  }
}

/// User preference provider for specific key
final userPreferenceProvider = Provider.family.autoDispose<dynamic, (String, dynamic, String?)>((ref, params) {
  final (key, defaultValue, userId) = params;
  final repository = ref.watch(userPreferencesRepositoryProvider);
  return repository.getPreference(key, defaultValue, userId);
});

/// User favorites provider
final userFavoritesProvider = Provider.family<List<String>, String?>((ref, userId) {
  final repository = ref.watch(userPreferencesRepositoryProvider);
  return repository.getFavorites(userId);
});

/// Recently accessed provider
final recentlyAccessedProvider = Provider.family<List<String>, (int, String?)>((ref, params) {
  final (limit, userId) = params;
  final repository = ref.watch(userPreferencesRepositoryProvider);
  return repository.getRecentlyAccessed(limit: limit, userId: userId);
});

/// Is favorite provider
final isFavoriteProvider = Provider.family<bool, (String, String?)>((ref, params) {
  final (itemId, userId) = params;
  final repository = ref.watch(userPreferencesRepositoryProvider);
  return repository.isFavorite(itemId, userId);
});

/// User stats provider
final userStatsProvider = Provider.family<Map<String, dynamic>, String?>((ref, userId) {
  final repository = ref.watch(userPreferencesRepositoryProvider);
  return repository.getUserStats(userId);
});