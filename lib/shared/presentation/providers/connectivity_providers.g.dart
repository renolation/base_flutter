// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityHash() => r'da8080dfc40288eff97ff9cb96e9d9577714a9a0';

/// Connectivity instance provider
///
/// Copied from [connectivity].
@ProviderFor(connectivity)
final connectivityProvider = AutoDisposeProvider<Connectivity>.internal(
  connectivity,
  name: r'connectivityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$connectivityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectivityRef = AutoDisposeProviderRef<Connectivity>;
String _$networkConnectivityStreamHash() =>
    r'0850402a3f1ed68481cfa9b8a3a371c804c358f3';

/// Network connectivity stream provider
///
/// Copied from [networkConnectivityStream].
@ProviderFor(networkConnectivityStream)
final networkConnectivityStreamProvider =
    AutoDisposeStreamProvider<NetworkStatus>.internal(
  networkConnectivityStream,
  name: r'networkConnectivityStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkConnectivityStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NetworkConnectivityStreamRef
    = AutoDisposeStreamProviderRef<NetworkStatus>;
String _$isConnectedHash() => r'89efbfc9ecb21e2ff1a7f6eea736457e35bed181';

/// Simple connectivity status provider
///
/// Copied from [isConnected].
@ProviderFor(isConnected)
final isConnectedProvider = AutoDisposeProvider<bool>.internal(
  isConnected,
  name: r'isConnectedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsConnectedRef = AutoDisposeProviderRef<bool>;
String _$connectionTypeHash() => r'fd1d65f0ae9afe2b04b358755ed4347e27a0515f';

/// Connection type provider
///
/// Copied from [connectionType].
@ProviderFor(connectionType)
final connectionTypeProvider =
    AutoDisposeProvider<NetworkConnectionType>.internal(
  connectionType,
  name: r'connectionTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectionTypeRef = AutoDisposeProviderRef<NetworkConnectionType>;
String _$isWifiConnectedHash() => r'6ab4a8f83d5073544d77620bea093f4b34d61e05';

/// Is Wi-Fi connected provider
///
/// Copied from [isWifiConnected].
@ProviderFor(isWifiConnected)
final isWifiConnectedProvider = AutoDisposeProvider<bool>.internal(
  isWifiConnected,
  name: r'isWifiConnectedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isWifiConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsWifiConnectedRef = AutoDisposeProviderRef<bool>;
String _$isMobileConnectedHash() => r'1e03a490b5a59ac598fe75b45c42b353cec26129';

/// Is mobile data connected provider
///
/// Copied from [isMobileConnected].
@ProviderFor(isMobileConnected)
final isMobileConnectedProvider = AutoDisposeProvider<bool>.internal(
  isMobileConnected,
  name: r'isMobileConnectedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isMobileConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsMobileConnectedRef = AutoDisposeProviderRef<bool>;
String _$networkQualityHash() => r'b72cb19e0b8537514827d11fbe2f46bba4e94ac2';

/// Network quality indicator provider
///
/// Copied from [networkQuality].
@ProviderFor(networkQuality)
final networkQualityProvider = AutoDisposeProvider<String>.internal(
  networkQuality,
  name: r'networkQualityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkQualityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NetworkQualityRef = AutoDisposeProviderRef<String>;
String _$networkStatusNotifierHash() =>
    r'adebb286dce36d8cb54504f04a67dd4c00dceade';

/// Current network status provider
///
/// Copied from [NetworkStatusNotifier].
@ProviderFor(NetworkStatusNotifier)
final networkStatusNotifierProvider =
    AutoDisposeNotifierProvider<NetworkStatusNotifier, NetworkStatus>.internal(
  NetworkStatusNotifier.new,
  name: r'networkStatusNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkStatusNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NetworkStatusNotifier = AutoDisposeNotifier<NetworkStatus>;
String _$networkHistoryNotifierHash() =>
    r'6498139c6e6e8472c81cb3f1789bcabfc4779943';

/// Network history provider for tracking connection changes
///
/// Copied from [NetworkHistoryNotifier].
@ProviderFor(NetworkHistoryNotifier)
final networkHistoryNotifierProvider = AutoDisposeNotifierProvider<
    NetworkHistoryNotifier, List<NetworkStatus>>.internal(
  NetworkHistoryNotifier.new,
  name: r'networkHistoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkHistoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NetworkHistoryNotifier = AutoDisposeNotifier<List<NetworkStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
