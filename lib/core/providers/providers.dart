/// Barrel file for all providers - central export point for dependency injection
///
/// This file exports all provider files to provide a single import point
/// for accessing all application providers following clean architecture principles.
///
/// Usage:
/// ```dart
/// import '../core/providers/providers.dart';
///
/// // Access any provider from the exported modules
/// final theme = ref.watch(currentThemeModeProvider);
/// final isConnected = ref.watch(isConnectedProvider);
/// ```

// Core application providers
export 'app_providers.dart';

// Network and API providers
export 'network_providers.dart';
export 'api_providers.dart';

// Theme and UI state providers
export 'theme_providers.dart';

// Storage and persistence providers
export 'storage_providers.dart' hide secureStorageProvider;

// Shared connectivity providers
export '../../../shared/presentation/providers/connectivity_providers.dart' hide connectivityProvider, isConnectedProvider;

/// Provider initialization helper
///
/// This class provides utilities for initializing and managing providers
/// across the application lifecycle.
class ProviderInitializer {
  const ProviderInitializer._();

  /// List of providers that need to be initialized early in the app lifecycle
  /// These providers will be warmed up during app initialization to ensure
  /// they're ready when needed.
  static const List<String> criticalProviders = [
    'appInitializationProvider',
    'appSettingsNotifierProvider',
    'networkStatusNotifierProvider',
    'secureStorageNotifierProvider',
  ];

  /// List of providers that can be initialized lazily when first accessed
  static const List<String> lazyProviders = [
    'featureFlagsProvider',
    'appConfigurationProvider',
    'networkHistoryNotifierProvider',
    'errorTrackerProvider',
  ];

  /// Provider categories for better organization and management
  static const Map<String, List<String>> providerCategories = {
    'core': [
      'appInitializationProvider',
      'globalAppStateProvider',
      'appVersionProvider',
      'appBuildModeProvider',
    ],
    'theme': [
      'appSettingsNotifierProvider',
      'currentThemeModeProvider',
      'effectiveThemeModeProvider',
      'isDarkModeProvider',
      'currentLocaleProvider',
    ],
    'storage': [
      'secureStorageNotifierProvider',
      'hiveStorageNotifierProvider',
      'storageHealthMonitorProvider',
      'storageManagerProvider',
    ],
    'network': [
      'networkStatusNotifierProvider',
      'networkConnectivityStreamProvider',
      'isConnectedProvider',
      'connectionTypeProvider',
      'networkQualityProvider',
    ],
    'utilities': [
      'featureFlagsProvider',
      'appConfigurationProvider',
      'errorTrackerProvider',
      'appLifecycleNotifierProvider',
    ],
  };

  /// Get providers by category
  static List<String> getProvidersByCategory(String category) {
    return providerCategories[category] ?? [];
  }

  /// Get all provider names
  static List<String> getAllProviders() {
    return providerCategories.values.expand((providers) => providers).toList();
  }

  /// Check if provider is critical (needs early initialization)
  static bool isCriticalProvider(String providerName) {
    return criticalProviders.contains(providerName);
  }

  /// Check if provider can be loaded lazily
  static bool isLazyProvider(String providerName) {
    return lazyProviders.contains(providerName);
  }
}

/// Provider documentation and usage guidelines
///
/// This class contains documentation for proper provider usage patterns
/// following Riverpod 2.x best practices.
class ProviderDocumentation {
  const ProviderDocumentation._();

  /// Usage examples for different provider types
  static const Map<String, String> usageExamples = {
    'AsyncNotifierProvider': '''
// For async mutable state management
final notifier = ref.watch(appSettingsNotifierProvider.notifier);
await notifier.updateThemeMode(AppThemeMode.dark);

// Watch for state changes
ref.listen(appSettingsNotifierProvider, (previous, next) {
  next.when(
    data: (settings) => print('Settings updated'),
    loading: () => print('Loading...'),
    error: (error, stack) => print('Error: \$error'),
  );
});
''',

    'NotifierProvider': '''
// For synchronous mutable state
final flags = ref.watch(featureFlagsProvider);
final notifier = ref.watch(featureFlagsProvider.notifier);

// Update state
notifier.enableFeature('darkMode');
notifier.toggleFeature('analytics');
''',

    'StreamProvider': '''
// For reactive data streams
final connectivityStream = ref.watch(networkConnectivityStreamProvider);

connectivityStream.when(
  data: (status) => Text('Connected: \${status.isConnected}'),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Text('Error: \$error'),
);
''',

    'Provider': '''
// For dependency injection and immutable values
final storage = ref.watch(secureStorageProvider);
final connectivity = ref.watch(connectivityProvider);

// Use in other providers
@riverpod
MyService myService(MyServiceRef ref) {
  final storage = ref.watch(secureStorageProvider);
  return MyService(storage);
}
''',

    'FutureProvider': '''
// For async operations (read-only)
final initData = ref.watch(appInitializationProvider);

initData.when(
  data: (data) => data.state == AppInitializationState.initialized
    ? const HomeScreen()
    : const LoadingScreen(),
  loading: () => const SplashScreen(),
  error: (error, stack) => ErrorScreen(error: error),
);
''',
  };

  /// Best practices for provider usage
  static const List<String> bestPractices = [
    '1. Use @riverpod annotation for new providers (Riverpod 2.x)',
    '2. Prefer AsyncNotifierProvider for mutable async state',
    '3. Use NotifierProvider for mutable synchronous state',
    '4. Use StreamProvider for reactive data streams',
    '5. Use Provider for dependency injection and immutable values',
    '6. Always handle error states in AsyncValue.when()',
    '7. Use ref.invalidate() to refresh provider state',
    '8. Implement proper disposal in ref.onDispose()',
    '9. Keep providers focused on a single responsibility',
    '10. Use meaningful provider names that indicate their purpose',
  ];

  /// Common patterns and solutions
  static const Map<String, String> commonPatterns = {
    'Combining Providers': '''
@riverpod
String userDisplayName(UserDisplayNameRef ref) {
  final user = ref.watch(currentUserProvider);
  final settings = ref.watch(userSettingsProvider);

  return settings.showFullName
    ? '\${user.firstName} \${user.lastName}'
    : user.username;
}
''',

    'Error Handling': '''
@riverpod
class DataNotifier extends _\$DataNotifier {
  @override
  Future<Data> build() async {
    return await _loadData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    try {
      final data = await _loadData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      // Log error for debugging
      ref.read(errorTrackerProvider.notifier).logError(error, stackTrace);
    }
  }
}
''',

    'State Persistence': '''
@riverpod
class PersistentCounter extends _\$PersistentCounter {
  @override
  int build() {
    // Load from storage on build
    final storage = ref.watch(storageProvider);
    return storage.getInt('counter') ?? 0;
  }

  void increment() {
    state = state + 1;
    // Persist state changes
    final storage = ref.read(storageProvider);
    storage.setInt('counter', state);
  }
}
''',
  };

  /// Performance tips
  static const List<String> performanceTips = [
    '1. Use select() to watch specific parts of complex state',
    '2. Avoid creating providers in build methods',
    '3. Use autoDispose for temporary providers',
    '4. Keep provider state minimal and focused',
    '5. Use family providers for parameterized providers',
    '6. Implement proper caching for expensive operations',
    '7. Dispose of resources in ref.onDispose()',
    '8. Use keepAlive() for providers that should survive rebuilds',
  ];
}