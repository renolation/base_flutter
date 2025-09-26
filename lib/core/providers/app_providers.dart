import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../database/hive_service.dart';
import '../database/models/app_settings.dart';
import '../database/providers/database_providers.dart';
import '../database/repositories/settings_repository.dart';
import '../database/repositories/cache_repository.dart';
import '../database/repositories/user_preferences_repository.dart';

part 'app_providers.g.dart';

/// App initialization state
enum AppInitializationState {
  uninitialized,
  initializing,
  initialized,
  error,
}

/// App initialization data
class AppInitializationData {
  final AppInitializationState state;
  final String? error;
  final DateTime? initializedAt;

  const AppInitializationData({
    required this.state,
    this.error,
    this.initializedAt,
  });

  AppInitializationData copyWith({
    AppInitializationState? state,
    String? error,
    DateTime? initializedAt,
  }) {
    return AppInitializationData(
      state: state ?? this.state,
      error: error ?? this.error,
      initializedAt: initializedAt ?? this.initializedAt,
    );
  }
}

/// Repository providers
@riverpod
CacheRepository cacheRepository(CacheRepositoryRef ref) {
  return CacheRepository();
}

@riverpod
UserPreferencesRepository userPreferencesRepository(UserPreferencesRepositoryRef ref) {
  return UserPreferencesRepository();
}

/// App initialization provider
@riverpod
class AppInitialization extends _$AppInitialization {
  @override
  Future<AppInitializationData> build() async {
    return _initializeApp();
  }

  Future<AppInitializationData> _initializeApp() async {
    try {
      debugPrint('🚀 Starting app initialization...');

      // Initialize Hive
      debugPrint('📦 Initializing Hive database...');
      // await HiveService.initialize();

      // Initialize repositories
      debugPrint('🗂️ Initializing repositories...');
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final cacheRepo = ref.read(cacheRepositoryProvider);
      final userPrefsRepo = ref.read(userPreferencesRepositoryProvider);

      // Load initial settings
      debugPrint('⚙️ Loading app settings...');
      final settings = settingsRepo.getSettings();

      // Initialize user preferences if needed
      debugPrint('👤 Initializing user preferences...');
      userPrefsRepo.getPreferences();

      // Perform any necessary migrations
      debugPrint('🔄 Checking for migrations...');
      await _performMigrations(settingsRepo, settings);

      // Clean up expired cache entries
      debugPrint('🧹 Cleaning up expired cache...');
      await cacheRepo.cleanExpiredItems();

      debugPrint('✅ App initialization completed successfully');

      return AppInitializationData(
        state: AppInitializationState.initialized,
        initializedAt: DateTime.now(),
      );
    } catch (error, stackTrace) {
      debugPrint('❌ App initialization failed: $error');
      debugPrint('Stack trace: $stackTrace');

      return AppInitializationData(
        state: AppInitializationState.error,
        error: error.toString(),
      );
    }
  }

  Future<void> _performMigrations(SettingsRepository repo, AppSettings settings) async {
    // Add any migration logic here
    if (settings.version < 1) {
      debugPrint('🔄 Migrating settings to version 1...');
      // Migration logic would go here
    }
  }

  /// Retry initialization
  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _initializeApp());
  }

  /// Force re-initialization
  Future<void> reinitialize() async {
    state = const AsyncValue.loading();

    try {
      // Close all Hive boxes
      await HiveService.closeAll();

      // Re-initialize everything
      state = AsyncValue.data(await _initializeApp());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// App version provider
@riverpod
String appVersion(AppVersionRef ref) {
  // This would typically come from package_info_plus
  return '1.0.0+1';
}

/// App build mode provider
@riverpod
String appBuildMode(AppBuildModeRef ref) {
  if (kDebugMode) return 'debug';
  if (kProfileMode) return 'profile';
  return 'release';
}

/// App ready state provider
@riverpod
bool isAppReady(IsAppReadyRef ref) {
  final initData = ref.watch(appInitializationProvider);

  return initData.when(
    data: (data) => data.state == AppInitializationState.initialized,
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Global app state notifier
@riverpod
class GlobalAppState extends _$GlobalAppState {
  @override
  Map<String, dynamic> build() {
    final initAsync = ref.watch(appInitializationProvider);
    final appVersion = ref.watch(appVersionProvider);
    final buildMode = ref.watch(appBuildModeProvider);

    return initAsync.when(
      data: (initData) => {
        'isInitialized': initData.state == AppInitializationState.initialized,
        'initializationState': initData.state,
        'initializationError': initData.error,
        'initializedAt': initData.initializedAt?.toIso8601String(),
        'appVersion': appVersion,
        'buildMode': buildMode,
        'isReady': initData.state == AppInitializationState.initialized,
      },
      loading: () => {
        'isInitialized': false,
        'initializationState': AppInitializationState.initializing,
        'initializationError': null,
        'initializedAt': null,
        'appVersion': appVersion,
        'buildMode': buildMode,
        'isReady': false,
      },
      error: (error, _) => {
        'isInitialized': false,
        'initializationState': AppInitializationState.error,
        'initializationError': error.toString(),
        'initializedAt': null,
        'appVersion': appVersion,
        'buildMode': buildMode,
        'isReady': false,
      },
    );
  }

  /// Update global state
  void updateState(String key, dynamic value) {
    final currentState = Map<String, dynamic>.from(state);
    currentState[key] = value;
    state = currentState;
  }

  /// Reset global state
  void reset() {
    ref.invalidate(appInitializationProvider);
  }
}

/// Feature flags provider
@riverpod
class FeatureFlags extends _$FeatureFlags {
  @override
  Map<String, bool> build() {
    final buildMode = ref.watch(appBuildModeProvider);

    return {
      'enableDebugMode': buildMode == 'debug',
      'enableAnalytics': buildMode == 'release',
      'enableCrashReporting': buildMode != 'debug',
      'enablePerformanceMonitoring': true,
      'enableOfflineMode': true,
      'enableDarkMode': true,
      'enableNotifications': true,
    };
  }

  /// Check if feature is enabled
  bool isEnabled(String feature) {
    return state[feature] ?? false;
  }

  /// Enable feature
  void enableFeature(String feature) {
    state = {...state, feature: true};
  }

  /// Disable feature
  void disableFeature(String feature) {
    state = {...state, feature: false};
  }

  /// Toggle feature
  void toggleFeature(String feature) {
    final currentValue = state[feature] ?? false;
    state = {...state, feature: !currentValue};
  }
}

/// App configuration provider
@riverpod
class AppConfiguration extends _$AppConfiguration {
  @override
  Map<String, dynamic> build() {
    final buildMode = ref.watch(appBuildModeProvider);

    return {
      'apiTimeout': 30000, // 30 seconds
      'cacheTimeout': 3600000, // 1 hour in milliseconds
      'maxRetries': 3,
      'retryDelay': 1000, // 1 second
      'enableLogging': buildMode == 'debug',
      'logLevel': buildMode == 'debug' ? 'verbose' : 'error',
      'maxCacheSize': 100 * 1024 * 1024, // 100MB
      'imageQuality': 85,
      'compressionEnabled': true,
    };
  }

  /// Get configuration value
  T? getValue<T>(String key) {
    return state[key] as T?;
  }

  /// Update configuration
  void updateConfiguration(String key, dynamic value) {
    state = {...state, key: value};
  }

  /// Update multiple configurations
  void updateConfigurations(Map<String, dynamic> updates) {
    state = {...state, ...updates};
  }
}

/// App lifecycle state provider
@riverpod
class AppLifecycleNotifier extends _$AppLifecycleNotifier {
  @override
  String build() {
    return 'resumed'; // Default state
  }

  void updateState(String newState) {
    state = newState;
    debugPrint('📱 App lifecycle state changed to: $newState');
  }
}

/// Error tracking provider
@riverpod
class ErrorTracker extends _$ErrorTracker {
  @override
  List<Map<String, dynamic>> build() {
    return [];
  }

  /// Log error
  void logError(dynamic error, StackTrace? stackTrace, {Map<String, dynamic>? context}) {
    final errorEntry = {
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'context': context,
    };

    state = [...state, errorEntry];

    // Keep only last 100 errors to prevent memory issues
    if (state.length > 100) {
      state = state.sublist(state.length - 100);
    }

    debugPrint('🐛 Error logged: $error');
  }

  /// Clear errors
  void clearErrors() {
    state = [];
  }

  /// Get recent errors
  List<Map<String, dynamic>> getRecentErrors({int count = 10}) {
    return state.reversed.take(count).toList();
  }
}