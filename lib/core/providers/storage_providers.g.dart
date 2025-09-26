// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'9cd02a4033a37568df4c1778f34709abb5853782';

/// Secure storage provider
///
/// Copied from [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$appSettingsBoxHash() => r'9e348c0084f7f23850f09adb2e6496fdbf8f2bdf';

/// Hive storage providers
///
/// Copied from [appSettingsBox].
@ProviderFor(appSettingsBox)
final appSettingsBoxProvider = AutoDisposeProvider<Box<AppSettings>>.internal(
  appSettingsBox,
  name: r'appSettingsBoxProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appSettingsBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppSettingsBoxRef = AutoDisposeProviderRef<Box<AppSettings>>;
String _$cacheBoxHash() => r'949b55a2b7423b7fa7182b8e45adf02367ab8c7c';

/// See also [cacheBox].
@ProviderFor(cacheBox)
final cacheBoxProvider = AutoDisposeProvider<Box<CacheItem>>.internal(
  cacheBox,
  name: r'cacheBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cacheBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheBoxRef = AutoDisposeProviderRef<Box<CacheItem>>;
String _$userPreferencesBoxHash() =>
    r'38e2eab12afb00cca5ad2f48bf1f9ec76cc962c8';

/// See also [userPreferencesBox].
@ProviderFor(userPreferencesBox)
final userPreferencesBoxProvider =
    AutoDisposeProvider<Box<UserPreferences>>.internal(
  userPreferencesBox,
  name: r'userPreferencesBoxProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPreferencesBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserPreferencesBoxRef = AutoDisposeProviderRef<Box<UserPreferences>>;
String _$secureStorageNotifierHash() =>
    r'08d6cb392865d7483027fde37192c07cb944c45f';

/// Secure storage notifier for managing secure data
///
/// Copied from [SecureStorageNotifier].
@ProviderFor(SecureStorageNotifier)
final secureStorageNotifierProvider = AutoDisposeAsyncNotifierProvider<
    SecureStorageNotifier, Map<String, String>>.internal(
  SecureStorageNotifier.new,
  name: r'secureStorageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SecureStorageNotifier = AutoDisposeAsyncNotifier<Map<String, String>>;
String _$hiveStorageNotifierHash() =>
    r'5d91bf162282fcfbef13aa7296255bb87640af51';

/// Hive storage notifier for managing Hive data
///
/// Copied from [HiveStorageNotifier].
@ProviderFor(HiveStorageNotifier)
final hiveStorageNotifierProvider = AutoDisposeNotifierProvider<
    HiveStorageNotifier, Map<String, dynamic>>.internal(
  HiveStorageNotifier.new,
  name: r'hiveStorageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hiveStorageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HiveStorageNotifier = AutoDisposeNotifier<Map<String, dynamic>>;
String _$storageHealthMonitorHash() =>
    r'1d52e331a84bd59a36055f5e8963eaa996f9c235';

/// Storage health monitor
///
/// Copied from [StorageHealthMonitor].
@ProviderFor(StorageHealthMonitor)
final storageHealthMonitorProvider = AutoDisposeNotifierProvider<
    StorageHealthMonitor, Map<String, dynamic>>.internal(
  StorageHealthMonitor.new,
  name: r'storageHealthMonitorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageHealthMonitorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StorageHealthMonitor = AutoDisposeNotifier<Map<String, dynamic>>;
String _$storageManagerHash() => r'8e017d34c8c574dd2777d6478af3cd921448b080';

/// Unified storage manager
///
/// Copied from [StorageManager].
@ProviderFor(StorageManager)
final storageManagerProvider =
    AutoDisposeNotifierProvider<StorageManager, Map<String, dynamic>>.internal(
  StorageManager.new,
  name: r'storageManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StorageManager = AutoDisposeNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
