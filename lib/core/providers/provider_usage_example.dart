/// Example usage of the Riverpod state management system
///
/// This file demonstrates how to properly use the various providers
/// created in this comprehensive Riverpod setup following 2.x best practices.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart'; // Import the barrel file

/// Example widget showing theme provider usage
class ThemeExampleWidget extends ConsumerWidget {
  const ThemeExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme-related providers
    final settingsAsync = ref.watch(appSettingsNotifierProvider);
    final currentTheme = ref.watch(currentThemeModeProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return settingsAsync.when(
      data: (settings) => Card(
        child: Column(
          children: [
            ListTile(
              title: const Text('Current Theme'),
              subtitle: Text(currentTheme.value),
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  // Update theme mode
                  final notifier = ref.read(appSettingsNotifierProvider.notifier);
                  notifier.updateThemeMode(
                    value ? AppThemeMode.dark : AppThemeMode.light,
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Notifications'),
              trailing: Switch(
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  final notifier = ref.read(appSettingsNotifierProvider.notifier);
                  notifier.updateNotificationsEnabled(value);
                },
              ),
            ),
          ],
        ),
      ),
      loading: () => const Card(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Card(
        child: ListTile(
          title: const Text('Error loading settings'),
          subtitle: Text(error.toString()),
          leading: const Icon(Icons.error),
        ),
      ),
    );
  }
}

/// Example widget showing connectivity provider usage
class ConnectivityExampleWidget extends ConsumerWidget {
  const ConnectivityExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch connectivity providers
    final isConnected = ref.watch(isConnectedProvider);
    final connectionType = ref.watch(connectionTypeProvider);
    final networkQuality = ref.watch(networkQualityProvider);
    final isWifi = ref.watch(isWifiConnectedProvider);

    return Card(
      color: isConnected == true ? Colors.green.shade50 : Colors.red.shade50,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              isConnected == true ? Icons.wifi : Icons.wifi_off,
              color: isConnected == true ? Colors.green : Colors.red,
            ),
            title: Text(isConnected == true ? 'Connected' : 'Disconnected'),
            subtitle: Text('Connection: ${connectionType.toString().split('.').last}'),
          ),
          if (isConnected == true) ...[
            ListTile(
              title: const Text('Network Quality'),
              subtitle: Text(networkQuality),
            ),
            if (isWifi == true)
              const ListTile(
                leading: Icon(Icons.wifi, color: Colors.blue),
                title: Text('Using Wi-Fi'),
              ),
          ],
          ListTile(
            title: const Text('Refresh Network Status'),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(networkStatusNotifierProvider.notifier).refresh();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Example widget showing app initialization and global state
class AppStateExampleWidget extends ConsumerWidget {
  const AppStateExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch app state providers
    final initAsync = ref.watch(appInitializationProvider);
    final globalState = ref.watch(globalAppStateProvider);
    final isReady = ref.watch(isAppReadyProvider);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('App Status'),
            subtitle: Text(isReady == true ? 'Ready' : 'Initializing...'),
            leading: Icon(
              isReady == true ? Icons.check_circle : Icons.hourglass_empty,
              color: isReady == true ? Colors.green : Colors.orange,
            ),
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: Text(globalState['appVersion'] ?? 'Unknown'),
          ),
          ListTile(
            title: const Text('Build Mode'),
            subtitle: Text(globalState['buildMode'] ?? 'Unknown'),
          ),
          initAsync.when(
            data: (data) => ListTile(
              title: const Text('Initialization Status'),
              subtitle: Text(data.state.toString().split('.').last),
              trailing: data.state == AppInitializationState.error
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        ref.read(appInitializationProvider.notifier).retry();
                      },
                    )
                  : null,
            ),
            loading: () => const ListTile(
              title: Text('Initialization Status'),
              subtitle: Text('Loading...'),
              trailing: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, stack) => ListTile(
              title: const Text('Initialization Error'),
              subtitle: Text(error.toString()),
              leading: const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Example widget showing storage provider usage
class StorageExampleWidget extends ConsumerWidget {
  const StorageExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch storage providers
    final storageManager = ref.watch(storageManagerProvider);

    final hiveStats = storageManager['hive'] as Map<String, dynamic>? ?? {};
    final secureStorageInfo = storageManager['secureStorage'] as Map<String, dynamic>? ?? {};
    final healthInfo = storageManager['health'] as Map<String, dynamic>? ?? {};

    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Storage Health'),
            subtitle: Text(healthInfo['isHealthy'] == true ? 'Healthy' : 'Issues detected'),
            leading: Icon(
              healthInfo['isHealthy'] == true ? Icons.check_circle : Icons.warning,
              color: healthInfo['isHealthy'] == true ? Colors.green : Colors.orange,
            ),
          ),
          ListTile(
            title: const Text('Hive Storage'),
            subtitle: Text('${hiveStats['appSettingsCount'] ?? 0} settings, ${hiveStats['cacheItemsCount'] ?? 0} cache items'),
          ),
          ListTile(
            title: const Text('Secure Storage'),
            subtitle: Text('${secureStorageInfo['keyCount'] ?? 0} secure keys stored'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  ref.read(storageManagerProvider.notifier).performMaintenance();
                },
                child: const Text('Maintenance'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(storageHealthMonitorProvider.notifier).performHealthCheck();
                },
                child: const Text('Health Check'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Example widget showing feature flags usage
class FeatureFlagsExampleWidget extends ConsumerWidget {
  const FeatureFlagsExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureFlags = ref.watch(featureFlagsProvider);
    final flagsNotifier = ref.watch(featureFlagsProvider.notifier);

    return Card(
      child: Column(
        children: [
          const ListTile(
            title: Text('Feature Flags'),
            leading: Icon(Icons.flag),
          ),
          ...featureFlags.entries.map((entry) => ListTile(
            title: Text(entry.key),
            trailing: Switch(
              value: entry.value,
              onChanged: (value) {
                if (value) {
                  flagsNotifier.enableFeature(entry.key);
                } else {
                  flagsNotifier.disableFeature(entry.key);
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}

/// Example screen demonstrating all provider usage
class ProviderDemoScreen extends ConsumerWidget {
  const ProviderDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh all providers
              ref.invalidate(appSettingsNotifierProvider);
              ref.invalidate(networkStatusNotifierProvider);
              ref.read(globalAppStateProvider.notifier).reset();
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AppStateExampleWidget(),
            SizedBox(height: 16),
            ThemeExampleWidget(),
            SizedBox(height: 16),
            ConnectivityExampleWidget(),
            SizedBox(height: 16),
            StorageExampleWidget(),
            SizedBox(height: 16),
            FeatureFlagsExampleWidget(),
          ],
        ),
      ),
    );
  }
}

/// Example of using providers in a lifecycle-aware way
class ProviderLifecycleExample extends ConsumerStatefulWidget {
  const ProviderLifecycleExample({super.key});

  @override
  ConsumerState<ProviderLifecycleExample> createState() => _ProviderLifecycleExampleState();
}

class _ProviderLifecycleExampleState extends ConsumerState<ProviderLifecycleExample>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen to app initialization
    ref.listenManual(appInitializationProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data.state == AppInitializationState.initialized) {
            debugPrint('✅ App initialized successfully');
          }
        },
        loading: () => debugPrint('🔄 App initializing...'),
        error: (error, stack) => debugPrint('❌ App initialization failed: $error'),
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Update app lifecycle state provider
    ref.read(appLifecycleNotifierProvider.notifier).updateState(state.name);

    // Handle different lifecycle states
    switch (state) {
      case AppLifecycleState.paused:
        // App is paused, save important state
        ref.read(storageManagerProvider.notifier).performMaintenance();
        break;
      case AppLifecycleState.resumed:
        // App is resumed, refresh network status
        ref.read(networkStatusNotifierProvider.notifier).refresh();
        break;
      case AppLifecycleState.detached:
        // App is detached, cleanup if needed
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Handle inactive/hidden states
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This would be your main app content
    return const ProviderDemoScreen();
  }
}