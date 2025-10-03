// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cacheRepositoryHash() => r'0137087454bd51e0465886de0eab7acdc124ecb9';

/// Repository providers
///
/// Copied from [cacheRepository].
@ProviderFor(cacheRepository)
final cacheRepositoryProvider = AutoDisposeProvider<CacheRepository>.internal(
  cacheRepository,
  name: r'cacheRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cacheRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheRepositoryRef = AutoDisposeProviderRef<CacheRepository>;
String _$userPreferencesRepositoryHash() =>
    r'0244be191fd7576cbfc90468fe491306ed06d537';

/// See also [userPreferencesRepository].
@ProviderFor(userPreferencesRepository)
final userPreferencesRepositoryProvider =
    AutoDisposeProvider<UserPreferencesRepository>.internal(
  userPreferencesRepository,
  name: r'userPreferencesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPreferencesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserPreferencesRepositoryRef
    = AutoDisposeProviderRef<UserPreferencesRepository>;
String _$appVersionHash() => r'2605d9c0fd6d6a24e56caceadbe25b8370fedc4f';

/// App version provider
///
/// Copied from [appVersion].
@ProviderFor(appVersion)
final appVersionProvider = AutoDisposeProvider<String>.internal(
  appVersion,
  name: r'appVersionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appVersionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppVersionRef = AutoDisposeProviderRef<String>;
String _$appBuildModeHash() => r'fa100842dc5c894edb352036f8d887d97618f696';

/// App build mode provider
///
/// Copied from [appBuildMode].
@ProviderFor(appBuildMode)
final appBuildModeProvider = AutoDisposeProvider<String>.internal(
  appBuildMode,
  name: r'appBuildModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appBuildModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppBuildModeRef = AutoDisposeProviderRef<String>;
String _$isAppReadyHash() => r'b23a0450aa7bb2c9e3ea07630429118f239e610a';

/// App ready state provider
///
/// Copied from [isAppReady].
@ProviderFor(isAppReady)
final isAppReadyProvider = AutoDisposeProvider<bool>.internal(
  isAppReady,
  name: r'isAppReadyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAppReadyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAppReadyRef = AutoDisposeProviderRef<bool>;
String _$environmentDebugInfoHash() =>
    r'8a936abed2173bd1539eec64231e8d970ed7382a';

/// Environment debug information provider
///
/// Copied from [environmentDebugInfo].
@ProviderFor(environmentDebugInfo)
final environmentDebugInfoProvider =
    AutoDisposeProvider<Map<String, dynamic>>.internal(
  environmentDebugInfo,
  name: r'environmentDebugInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$environmentDebugInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EnvironmentDebugInfoRef = AutoDisposeProviderRef<Map<String, dynamic>>;
String _$appInitializationHash() => r'cdf86e2d6985c6dcee80f618bc032edf81011fc9';

/// App initialization provider
///
/// Copied from [AppInitialization].
@ProviderFor(AppInitialization)
final appInitializationProvider = AutoDisposeAsyncNotifierProvider<
    AppInitialization, AppInitializationData>.internal(
  AppInitialization.new,
  name: r'appInitializationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appInitializationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppInitialization = AutoDisposeAsyncNotifier<AppInitializationData>;
String _$globalAppStateHash() => r'fd0daa69a2a1dc4aaa3af95a1b148ba1e6de0e3f';

/// Global app state notifier
///
/// Copied from [GlobalAppState].
@ProviderFor(GlobalAppState)
final globalAppStateProvider =
    AutoDisposeNotifierProvider<GlobalAppState, Map<String, dynamic>>.internal(
  GlobalAppState.new,
  name: r'globalAppStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalAppStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalAppState = AutoDisposeNotifier<Map<String, dynamic>>;
String _$featureFlagsHash() => r'747e9d64c73eed5b374f37a8f28eb4b7fc94e53d';

/// Feature flags provider
///
/// Copied from [FeatureFlags].
@ProviderFor(FeatureFlags)
final featureFlagsProvider =
    AutoDisposeNotifierProvider<FeatureFlags, Map<String, bool>>.internal(
  FeatureFlags.new,
  name: r'featureFlagsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$featureFlagsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FeatureFlags = AutoDisposeNotifier<Map<String, bool>>;
String _$appConfigurationHash() => r'7699bbd57d15b91cd520a876454368e5b97342bd';

/// App configuration provider
///
/// Copied from [AppConfiguration].
@ProviderFor(AppConfiguration)
final appConfigurationProvider = AutoDisposeNotifierProvider<AppConfiguration,
    Map<String, dynamic>>.internal(
  AppConfiguration.new,
  name: r'appConfigurationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appConfigurationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppConfiguration = AutoDisposeNotifier<Map<String, dynamic>>;
String _$appLifecycleNotifierHash() =>
    r'344a33715910c38bccc596ac0b543e59cb5752a0';

/// App lifecycle state provider
///
/// Copied from [AppLifecycleNotifier].
@ProviderFor(AppLifecycleNotifier)
final appLifecycleNotifierProvider =
    AutoDisposeNotifierProvider<AppLifecycleNotifier, String>.internal(
  AppLifecycleNotifier.new,
  name: r'appLifecycleNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appLifecycleNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppLifecycleNotifier = AutoDisposeNotifier<String>;
String _$errorTrackerHash() => r'c286897f0ac33b2b619be30d3fd8d18331635b88';

/// Error tracking provider
///
/// Copied from [ErrorTracker].
@ProviderFor(ErrorTracker)
final errorTrackerProvider = AutoDisposeNotifierProvider<ErrorTracker,
    List<Map<String, dynamic>>>.internal(
  ErrorTracker.new,
  name: r'errorTrackerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$errorTrackerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ErrorTracker = AutoDisposeNotifier<List<Map<String, dynamic>>>;
String _$apiConnectivityTestHash() =>
    r'af903de0fec684ef6c701190dfca2a25f97a9392';

/// API connectivity test provider
///
/// Copied from [ApiConnectivityTest].
@ProviderFor(ApiConnectivityTest)
final apiConnectivityTestProvider = AutoDisposeAsyncNotifierProvider<
    ApiConnectivityTest, Map<String, dynamic>>.internal(
  ApiConnectivityTest.new,
  name: r'apiConnectivityTestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiConnectivityTestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApiConnectivityTest = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
