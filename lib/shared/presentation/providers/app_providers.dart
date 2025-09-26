import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/storage_constants.dart';
import '../../../core/database/models/app_settings.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers/network_providers.dart';
import '../../../core/providers/storage_providers.dart' as storage;

/// Secure storage provider
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(),
  ),
);

/// HTTP client provider
final httpClientProvider = Provider<DioClient>(
  (ref) {
    final networkInfo = ref.watch(networkInfoProvider);
    final secureStorage = ref.watch(secureStorageProvider);

    return DioClient(
      networkInfo: networkInfo,
      secureStorage: secureStorage,
    );
  },
);

/// App settings Hive box provider - uses safe provider from storage_providers.dart
final appSettingsBoxProvider = Provider<Box?>(
  (ref) => ref.watch(storage.appSettingsBoxProvider),
);

/// Cache Hive box provider - uses safe provider from storage_providers.dart
final cacheBoxProvider = Provider<Box?>(
  (ref) => ref.watch(storage.cacheBoxProvider),
);

/// User data Hive box provider - uses safe provider from storage_providers.dart
final userDataBoxProvider = Provider<Box?>(
  (ref) => ref.watch(storage.userPreferencesBoxProvider),
);

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(appSettingsBoxProvider)),
);

/// Theme mode notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Box? _box;
  static const String _settingsKey = 'app_settings';

  ThemeModeNotifier(this._box) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    if (_box == null || !_box.isOpen) {
      // Default to system theme if box is not ready
      state = ThemeMode.system;
      return;
    }

    try {
      // Get AppSettings from box
      final settings = _box.get(_settingsKey) as AppSettings?;
      if (settings != null) {
        state = _themeModeFromString(settings.themeMode);
      } else {
        state = ThemeMode.system;
      }
    } catch (e) {
      // Fallback to system theme on any error
      debugPrint('Error loading theme mode: $e');
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    // Only persist if box is available
    if (_box == null || !_box.isOpen) {
      return;
    }

    try {
      // Get current settings or create default
      var settings = _box.get(_settingsKey) as AppSettings?;
      settings ??= AppSettings.defaultSettings();

      // Update theme mode
      final updatedSettings = settings.copyWith(
        themeMode: _themeModeToString(mode),
        lastUpdated: DateTime.now(),
      );

      // Save to box
      await _box.put(_settingsKey, updatedSettings);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.system:
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.light);
        break;
    }
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}