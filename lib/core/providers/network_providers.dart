import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';

/// Provider for Connectivity instance
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider for FlutterSecureStorage instance
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider for NetworkInfo implementation
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

/// Provider for DioClient - the main HTTP client
final dioClientProvider = Provider<DioClient>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return DioClient(
    networkInfo: networkInfo,
    secureStorage: secureStorage,
  );
});

/// Provider for network connectivity stream
final networkConnectivityProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.connectionStream;
});

/// Provider for current network status
final isConnectedProvider = FutureProvider<bool>((ref) async {
  final networkInfo = ref.watch(networkInfoProvider);
  return await networkInfo.isConnected;
});

/// Utility provider to get detailed network connection information
final networkConnectionDetailsProvider = FutureProvider((ref) async {
  final networkInfo = ref.watch(networkInfoProvider) as NetworkInfoImpl;
  return await networkInfo.getConnectionDetails();
});