import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/models/app_settings.dart';
import '../database/repositories/settings_repository.dart';

part 'theme_providers.g.dart';

/// Theme mode enumeration
enum AppThemeMode {
  light('light'),
  dark('dark'),
  system('system');

  const AppThemeMode(this.value);
  final String value;

  static AppThemeMode fromString(String value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

/// Settings repository provider
@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepository();
}

/// Current app settings provider
@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  late SettingsRepository _repository;

  @override
  Future<AppSettings> build() async {
    _repository = ref.read(settingsRepositoryProvider);
    return _repository.getSettings();
  }

  /// Update theme mode
  Future<void> updateThemeMode(AppThemeMode mode) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateThemeMode(mode.value);
      final updatedSettings = _repository.getSettings();
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update locale
  Future<void> updateLocale(String locale) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateLocale(locale);
      final updatedSettings = _repository.getSettings();
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateNotificationsEnabled(enabled);
      final updatedSettings = _repository.getSettings();
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update analytics enabled
  Future<void> updateAnalyticsEnabled(bool enabled) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateAnalyticsEnabled(enabled);
      final updatedSettings = _repository.getSettings();
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Set custom setting
  Future<void> setCustomSetting(String key, dynamic value) async {
    state = const AsyncValue.loading();

    try {
      await _repository.setCustomSetting(key, value);
      final updatedSettings = _repository.getSettings();
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Reset to default settings
  Future<void> resetToDefault() async {
    state = const AsyncValue.loading();

    try {
      await _repository.resetToDefault();
      final updatedSettings = _repository.getSettings();
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh settings from storage
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    try {
      final settings = _repository.getSettings();
      state = AsyncValue.data(settings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Current theme mode provider
@riverpod
AppThemeMode currentThemeMode(CurrentThemeModeRef ref) {
  final settingsAsync = ref.watch(appSettingsNotifierProvider);

  return settingsAsync.when(
    data: (settings) => AppThemeMode.fromString(settings.themeMode),
    loading: () => AppThemeMode.system,
    error: (_, __) => AppThemeMode.system,
  );
}

/// Effective theme mode provider (resolves system theme)
@riverpod
ThemeMode effectiveThemeMode(EffectiveThemeModeRef ref) {
  final themeMode = ref.watch(currentThemeModeProvider);

  switch (themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
}

/// Is dark mode active provider
@riverpod
bool isDarkMode(IsDarkModeRef ref) {
  final themeMode = ref.watch(currentThemeModeProvider);

  switch (themeMode) {
    case AppThemeMode.light:
      return false;
    case AppThemeMode.dark:
      return true;
    case AppThemeMode.system:
      // Get platform brightness from MediaQuery
      // This will be handled at the widget level
      return false; // Default fallback
  }
}

/// Current locale provider
@riverpod
Locale currentLocale(CurrentLocaleRef ref) {
  final settingsAsync = ref.watch(appSettingsNotifierProvider);

  return settingsAsync.when(
    data: (settings) => Locale(settings.locale),
    loading: () => const Locale('en'),
    error: (_, __) => const Locale('en'),
  );
}

/// Settings stream provider for reactive updates
@riverpod
class SettingsStreamNotifier extends _$SettingsStreamNotifier {
  @override
  Stream<AppSettings> build() {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.watchSettings();
  }
}

/// Theme preferences provider for quick access
@riverpod
class ThemePreferences extends _$ThemePreferences {
  @override
  Map<String, dynamic> build() {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);

    return settingsAsync.when(
      data: (settings) => {
        'themeMode': settings.themeMode,
        'isDarkMode': AppThemeMode.fromString(settings.themeMode) == AppThemeMode.dark,
        'locale': settings.locale,
        'analyticsEnabled': settings.analyticsEnabled,
        'notificationsEnabled': settings.notificationsEnabled,
      },
      loading: () => {
        'themeMode': 'system',
        'isDarkMode': false,
        'locale': 'en',
        'analyticsEnabled': false,
        'notificationsEnabled': true,
      },
      error: (_, __) => {
        'themeMode': 'system',
        'isDarkMode': false,
        'locale': 'en',
        'analyticsEnabled': false,
        'notificationsEnabled': true,
      },
    );
  }
}