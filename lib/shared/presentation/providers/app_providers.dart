import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/storage_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers/network_providers.dart';

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

/// App settings Hive box provider
final appSettingsBoxProvider = Provider<Box>(
  (ref) => Hive.box(StorageConstants.appSettingsBox),
);

/// Cache Hive box provider
final cacheBoxProvider = Provider<Box>(
  (ref) => Hive.box(StorageConstants.cacheBox),
);

/// User data Hive box provider
final userDataBoxProvider = Provider<Box>(
  (ref) => Hive.box(StorageConstants.userDataBox),
);

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(appSettingsBoxProvider)),
);

/// Theme mode notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Box _box;

  ThemeModeNotifier(this._box) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final isDarkMode = _box.get(StorageConstants.isDarkModeKey, defaultValue: null);
    if (isDarkMode == null) {
      state = ThemeMode.system;
    } else {
      state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    switch (mode) {
      case ThemeMode.system:
        await _box.delete(StorageConstants.isDarkModeKey);
        break;
      case ThemeMode.light:
        await _box.put(StorageConstants.isDarkModeKey, false);
        break;
      case ThemeMode.dark:
        await _box.put(StorageConstants.isDarkModeKey, true);
        break;
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
}