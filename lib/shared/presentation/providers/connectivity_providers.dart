import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'connectivity_providers.g.dart';

/// Network connection type
enum NetworkConnectionType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  none,
}

/// Network status data class
class NetworkStatus {
  final bool isConnected;
  final NetworkConnectionType connectionType;
  final DateTime lastUpdated;
  final String? errorMessage;

  const NetworkStatus({
    required this.isConnected,
    required this.connectionType,
    required this.lastUpdated,
    this.errorMessage,
  });

  NetworkStatus copyWith({
    bool? isConnected,
    NetworkConnectionType? connectionType,
    DateTime? lastUpdated,
    String? errorMessage,
  }) {
    return NetworkStatus(
      isConnected: isConnected ?? this.isConnected,
      connectionType: connectionType ?? this.connectionType,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'NetworkStatus{isConnected: $isConnected, connectionType: $connectionType, lastUpdated: $lastUpdated}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NetworkStatus &&
        other.isConnected == isConnected &&
        other.connectionType == connectionType;
  }

  @override
  int get hashCode {
    return isConnected.hashCode ^ connectionType.hashCode;
  }
}

/// Convert ConnectivityResult to NetworkConnectionType
NetworkConnectionType _getConnectionType(List<ConnectivityResult> results) {
  if (results.isEmpty || results.contains(ConnectivityResult.none)) {
    return NetworkConnectionType.none;
  }

  if (results.contains(ConnectivityResult.wifi)) {
    return NetworkConnectionType.wifi;
  }

  if (results.contains(ConnectivityResult.mobile)) {
    return NetworkConnectionType.mobile;
  }

  if (results.contains(ConnectivityResult.ethernet)) {
    return NetworkConnectionType.ethernet;
  }

  if (results.contains(ConnectivityResult.bluetooth)) {
    return NetworkConnectionType.bluetooth;
  }

  if (results.contains(ConnectivityResult.vpn)) {
    return NetworkConnectionType.vpn;
  }

  if (results.contains(ConnectivityResult.other)) {
    return NetworkConnectionType.other;
  }

  return NetworkConnectionType.none;
}

/// Connectivity instance provider
@riverpod
Connectivity connectivity(ConnectivityRef ref) {
  return Connectivity();
}

/// Network connectivity stream provider
@riverpod
Stream<NetworkStatus> networkConnectivityStream(NetworkConnectivityStreamRef ref) {
  final connectivity = ref.watch(connectivityProvider);

  return connectivity.onConnectivityChanged.map((results) {
    final connectionType = _getConnectionType(results);
    final isConnected = connectionType != NetworkConnectionType.none;

    return NetworkStatus(
      isConnected: isConnected,
      connectionType: connectionType,
      lastUpdated: DateTime.now(),
    );
  }).handleError((error) {
    debugPrint('❌ Connectivity stream error: $error');
    return NetworkStatus(
      isConnected: false,
      connectionType: NetworkConnectionType.none,
      lastUpdated: DateTime.now(),
      errorMessage: error.toString(),
    );
  });
}

/// Current network status provider
@riverpod
class NetworkStatusNotifier extends _$NetworkStatusNotifier {
  @override
  NetworkStatus build() {
    // Start listening to connectivity changes
    final streamValue = ref.watch(networkConnectivityStreamProvider);
    streamValue.whenData((status) {
      state = status;
      _logConnectionChange(status);
    });

    // Get initial connectivity state
    _checkInitialConnectivity();

    // Return initial state
    return NetworkStatus(
      isConnected: false,
      connectionType: NetworkConnectionType.none,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final connectivity = ref.read(connectivityProvider);
      final result = await connectivity.checkConnectivity();
      final connectionType = _getConnectionType(result);
      final isConnected = connectionType != NetworkConnectionType.none;

      state = NetworkStatus(
        isConnected: isConnected,
        connectionType: connectionType,
        lastUpdated: DateTime.now(),
      );

      debugPrint('📡 Initial connectivity: ${isConnected ? '✅ Connected' : '❌ Disconnected'} ($connectionType)');
    } catch (error) {
      debugPrint('❌ Error checking initial connectivity: $error');
      state = NetworkStatus(
        isConnected: false,
        connectionType: NetworkConnectionType.none,
        lastUpdated: DateTime.now(),
        errorMessage: error.toString(),
      );
    }
  }

  void _logConnectionChange(NetworkStatus status) {
    final icon = status.isConnected ? '📶' : '📵';
    final statusText = status.isConnected ? 'Connected' : 'Disconnected';
    debugPrint('$icon Network status changed: $statusText (${status.connectionType})');
  }

  /// Force refresh network status
  Future<void> refresh() async {
    await _checkInitialConnectivity();
  }

  /// Get connection strength (mock implementation)
  double getConnectionStrength() {
    switch (state.connectionType) {
      case NetworkConnectionType.wifi:
        return 1.0; // Assume strong Wi-Fi
      case NetworkConnectionType.ethernet:
        return 1.0; // Assume strong ethernet
      case NetworkConnectionType.mobile:
        return 0.7; // Assume moderate mobile
      case NetworkConnectionType.bluetooth:
        return 0.5; // Assume weak bluetooth
      case NetworkConnectionType.vpn:
        return 0.8; // Assume good VPN
      case NetworkConnectionType.other:
        return 0.6; // Assume moderate other
      case NetworkConnectionType.none:
        return 0.0; // No connection
    }
  }
}

/// Simple connectivity status provider
@riverpod
bool isConnected(IsConnectedRef ref) {
  final networkStatus = ref.watch(networkStatusNotifierProvider);
  return networkStatus.isConnected;
}

/// Connection type provider
@riverpod
NetworkConnectionType connectionType(ConnectionTypeRef ref) {
  final networkStatus = ref.watch(networkStatusNotifierProvider);
  return networkStatus.connectionType;
}

/// Is Wi-Fi connected provider
@riverpod
bool isWifiConnected(IsWifiConnectedRef ref) {
  final networkStatus = ref.watch(networkStatusNotifierProvider);
  return networkStatus.isConnected && networkStatus.connectionType == NetworkConnectionType.wifi;
}

/// Is mobile data connected provider
@riverpod
bool isMobileConnected(IsMobileConnectedRef ref) {
  final networkStatus = ref.watch(networkStatusNotifierProvider);
  return networkStatus.isConnected && networkStatus.connectionType == NetworkConnectionType.mobile;
}

/// Network quality indicator provider
@riverpod
String networkQuality(NetworkQualityRef ref) {
  final networkStatus = ref.watch(networkStatusNotifierProvider);

  if (!networkStatus.isConnected) {
    return 'No Connection';
  }

  switch (networkStatus.connectionType) {
    case NetworkConnectionType.wifi:
      return 'Excellent';
    case NetworkConnectionType.ethernet:
      return 'Excellent';
    case NetworkConnectionType.mobile:
      return 'Good';
    case NetworkConnectionType.vpn:
      return 'Good';
    case NetworkConnectionType.other:
      return 'Fair';
    case NetworkConnectionType.bluetooth:
      return 'Poor';
    case NetworkConnectionType.none:
      return 'No Connection';
  }
}

/// Network history provider for tracking connection changes
@riverpod
class NetworkHistoryNotifier extends _$NetworkHistoryNotifier {
  static const int _maxHistorySize = 50;

  @override
  List<NetworkStatus> build() {
    // Listen to network status changes and add to history
    ref.listen(networkStatusNotifierProvider, (previous, next) {
      if (previous != next) {
        _addToHistory(next);
      }
    });

    return [];
  }

  void _addToHistory(NetworkStatus status) {
    final newHistory = [...state, status];

    // Keep only the last _maxHistorySize entries
    if (newHistory.length > _maxHistorySize) {
      newHistory.removeRange(0, newHistory.length - _maxHistorySize);
    }

    state = newHistory;
  }

  /// Get recent connection changes
  List<NetworkStatus> getRecentChanges({int count = 10}) {
    return state.reversed.take(count).toList();
  }

  /// Get connection uptime percentage
  double getUptimePercentage({Duration? period}) {
    if (state.isEmpty) return 0.0;

    final now = DateTime.now();
    final startTime = period != null ? now.subtract(period) : state.first.lastUpdated;

    final relevantEntries = state.where((status) => status.lastUpdated.isAfter(startTime)).toList();

    if (relevantEntries.isEmpty) return 0.0;

    final connectedCount = relevantEntries.where((status) => status.isConnected).length;
    return connectedCount / relevantEntries.length;
  }

  /// Clear history
  void clearHistory() {
    state = [];
  }

  /// Get connection statistics
  Map<String, dynamic> getConnectionStats() {
    if (state.isEmpty) {
      return {
        'totalChanges': 0,
        'uptimePercentage': 0.0,
        'mostCommonConnection': 'Unknown',
        'connectionTypes': <String, int>{},
      };
    }

    final connectionTypeCounts = <NetworkConnectionType, int>{};
    for (final status in state) {
      connectionTypeCounts[status.connectionType] = (connectionTypeCounts[status.connectionType] ?? 0) + 1;
    }

    final mostCommonType = connectionTypeCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'totalChanges': state.length,
      'uptimePercentage': getUptimePercentage(),
      'mostCommonConnection': mostCommonType.toString().split('.').last,
      'connectionTypes': connectionTypeCounts.map((key, value) => MapEntry(key.toString().split('.').last, value)),
    };
  }
}