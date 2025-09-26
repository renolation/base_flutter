import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract class defining network information interface
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectionStream;
  Future<ConnectivityResult> get connectionStatus;
  Future<bool> hasInternetConnection();
}

/// Implementation of NetworkInfo using connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  NetworkInfoImpl(this._connectivity) {
    _initializeConnectivityStream();
  }

  void _initializeConnectivityStream() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );

    // Check initial connectivity status
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      _connectionController.add(false);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) async {
    final hasConnection = _hasConnectionFromResults(results);

    // Double-check with internet connectivity test for reliability
    if (hasConnection) {
      final hasInternet = await hasInternetConnection();
      _connectionController.add(hasInternet);
    } else {
      _connectionController.add(false);
    }
  }

  bool _hasConnectionFromResults(List<ConnectivityResult> results) {
    return results.any((result) =>
        result != ConnectivityResult.none);
  }

  @override
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (!_hasConnectionFromResults(results)) {
        return false;
      }
      return await hasInternetConnection();
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Future<ConnectivityResult> get connectionStatus async {
    try {
      final results = await _connectivity.checkConnectivity();
      // Return the first non-none result, or none if all are none
      return results.firstWhere(
        (result) => result != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  @override
  Future<bool> hasInternetConnection() async {
    try {
      // Try to connect to multiple reliable hosts for better reliability
      final hosts = [
        'google.com',
        'cloudflare.com',
        '8.8.8.8', // Google DNS
      ];

      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(host).timeout(
            const Duration(seconds: 5),
          );

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Continue to next host if this one fails
          continue;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get detailed connectivity information
  Future<NetworkConnectionDetails> getConnectionDetails() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasInternet = await hasInternetConnection();

      return NetworkConnectionDetails(
        connectivityResults: results,
        hasInternetConnection: hasInternet,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return NetworkConnectionDetails(
        connectivityResults: [ConnectivityResult.none],
        hasInternetConnection: false,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  /// Check if connected to WiFi
  Future<bool> get isConnectedToWiFi async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  Future<bool> get isConnectedToMobile async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }

  /// Check if connected to ethernet (mainly for desktop/web)
  Future<bool> get isConnectedToEthernet async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.ethernet);
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }
}

/// Detailed network connection information
class NetworkConnectionDetails {
  final List<ConnectivityResult> connectivityResults;
  final bool hasInternetConnection;
  final DateTime timestamp;
  final String? error;

  const NetworkConnectionDetails({
    required this.connectivityResults,
    required this.hasInternetConnection,
    required this.timestamp,
    this.error,
  });

  /// Check if any connection is available
  bool get hasConnection =>
      connectivityResults.any((result) => result != ConnectivityResult.none);

  /// Get primary connection type
  ConnectivityResult get primaryConnection {
    return connectivityResults.firstWhere(
      (result) => result != ConnectivityResult.none,
      orElse: () => ConnectivityResult.none,
    );
  }

  /// Check if connected via WiFi
  bool get isWiFi => connectivityResults.contains(ConnectivityResult.wifi);

  /// Check if connected via mobile
  bool get isMobile => connectivityResults.contains(ConnectivityResult.mobile);

  /// Check if connected via ethernet
  bool get isEthernet => connectivityResults.contains(ConnectivityResult.ethernet);

  /// Get human-readable connection description
  String get connectionDescription {
    if (error != null) {
      return 'Connection error: $error';
    }

    if (!hasConnection) {
      return 'No connection';
    }

    if (!hasInternetConnection) {
      return 'Connected but no internet access';
    }

    final types = <String>[];
    if (isWiFi) types.add('WiFi');
    if (isMobile) types.add('Mobile');
    if (isEthernet) types.add('Ethernet');

    return types.isEmpty ? 'Connected' : 'Connected via ${types.join(', ')}';
  }

  @override
  String toString() {
    return 'NetworkConnectionDetails('
           'results: $connectivityResults, '
           'hasInternet: $hasInternetConnection, '
           'timestamp: $timestamp, '
           'error: $error)';
  }
}