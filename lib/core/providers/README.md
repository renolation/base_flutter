# Riverpod State Management Setup

This directory contains a comprehensive Riverpod state management setup following Riverpod 2.x best practices with modern provider patterns.

## 📁 Directory Structure

```
lib/core/providers/
├── providers.dart                 # Barrel file - single import point
├── app_providers.dart            # Global app state and initialization
├── theme_providers.dart          # Theme and UI state management
├── storage_providers.dart        # Secure storage and Hive management
├── network_providers.dart        # HTTP clients and API providers
├── api_providers.dart           # API-specific providers
└── provider_usage_example.dart   # Usage examples and patterns

lib/shared/presentation/providers/
└── connectivity_providers.dart   # Network connectivity monitoring
```

## 🚀 Key Features

### Modern Riverpod 2.x Patterns
- **AsyncNotifierProvider**: For async mutable state management
- **NotifierProvider**: For synchronous mutable state management
- **StreamProvider**: For reactive data streams
- **Provider**: For dependency injection and immutable values
- **Code Generation**: Using `@riverpod` annotation for type safety

### Comprehensive State Management
- **App Initialization**: Multi-stage app startup with error handling
- **Theme Management**: Dark/light mode with system preference support
- **Storage Integration**: Hive + Secure Storage with health monitoring
- **Network Connectivity**: Real-time connection status and history
- **Feature Flags**: Dynamic feature toggling
- **Error Tracking**: Centralized error logging and monitoring

### Performance Optimized
- **State Persistence**: Automatic state saving and restoration
- **Efficient Rebuilds**: Minimal widget rebuilds with proper selectors
- **Resource Management**: Automatic disposal and cleanup
- **Caching Strategy**: Intelligent data caching with expiration

## 📋 Provider Categories

### 🏗️ Core Application (`app_providers.dart`)
```dart
// App initialization with multi-stage loading
final initData = ref.watch(appInitializationProvider);

// Global app state management
final globalState = ref.watch(globalAppStateProvider);

// Feature flags for conditional features
final featureFlags = ref.watch(featureFlagsProvider);
```

### 🎨 Theme & UI (`theme_providers.dart`)
```dart
// Theme mode management with persistence
final themeMode = ref.watch(currentThemeModeProvider);
await ref.read(appSettingsNotifierProvider.notifier)
    .updateThemeMode(AppThemeMode.dark);

// Reactive theme changes
final isDark = ref.watch(isDarkModeProvider);
```

### 💾 Storage Management (`storage_providers.dart`)
```dart
// Secure storage operations
final secureNotifier = ref.read(secureStorageNotifierProvider.notifier);
await secureNotifier.store('token', 'secure_value');

// Hive storage with health monitoring
final storageHealth = ref.watch(storageHealthMonitorProvider);
```

### 🌐 Network Connectivity (`connectivity_providers.dart`)
```dart
// Real-time connectivity monitoring
final isConnected = ref.watch(isConnectedProvider);
final connectionType = ref.watch(connectionTypeProvider);

// Network history and statistics
final networkHistory = ref.watch(networkHistoryNotifierProvider);
```

## 🔧 Usage Patterns

### 1. Basic Provider Consumption
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsNotifierProvider);

    return settingsAsync.when(
      data: (settings) => Text('Theme: ${settings.themeMode}'),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 2. State Mutation
```dart
// Theme change
await ref.read(appSettingsNotifierProvider.notifier)
    .updateThemeMode(AppThemeMode.dark);

// Feature flag toggle
ref.read(featureFlagsProvider.notifier)
    .toggleFeature('darkMode');

// Storage operations
await ref.read(secureStorageNotifierProvider.notifier)
    .store('api_key', newApiKey);
```

### 3. Provider Listening
```dart
// Listen for state changes
ref.listen(networkStatusNotifierProvider, (previous, next) {
  if (next.isConnected && !previous?.isConnected) {
    // Connection restored
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connection restored')),
    );
  }
});
```

### 4. Combining Providers
```dart
@riverpod
String userStatus(UserStatusRef ref) {
  final isConnected = ref.watch(isConnectedProvider);
  final settings = ref.watch(appSettingsNotifierProvider);

  return settings.when(
    data: (data) => isConnected
        ? 'Online - ${data.locale}'
        : 'Offline - ${data.locale}',
    loading: () => 'Loading...',
    error: (_, __) => 'Error',
  );
}
```

## 📱 App Integration

### 1. Provider Setup
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive before app starts
  await HiveService.init();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}
```

### 2. App Initialization
```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(appInitializationProvider);

    return initAsync.when(
      data: (data) => data.state == AppInitializationState.initialized
          ? const MainApp()
          : const SplashScreen(),
      loading: () => const SplashScreen(),
      error: (error, stack) => ErrorApp(error: error),
    );
  }
}
```

### 3. Theme Integration
```dart
class MainApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(effectiveThemeModeProvider);

    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
```

## 🔄 State Persistence

### Automatic Persistence
- **Theme Mode**: Automatically saved to Hive
- **User Preferences**: Persisted across app restarts
- **Feature Flags**: Maintained in local storage
- **Network History**: Cached for analytics

### Manual Persistence
```dart
// Save custom app state
await ref.read(appSettingsNotifierProvider.notifier)
    .setCustomSetting('user_preference', value);

// Restore state on app start
final customValue = settings.getCustomSetting<String>('user_preference');
```

## 🚨 Error Handling

### Provider-Level Error Handling
```dart
@riverpod
class DataNotifier extends _$DataNotifier {
  @override
  Future<Data> build() async {
    try {
      return await loadData();
    } catch (error, stackTrace) {
      // Log error for debugging
      ref.read(errorTrackerProvider.notifier)
          .logError(error, stackTrace);
      rethrow;
    }
  }
}
```

### Global Error Tracking
```dart
// Access error history
final recentErrors = ref.read(errorTrackerProvider.notifier)
    .getRecentErrors(count: 5);

// Clear error history
ref.read(errorTrackerProvider.notifier).clearErrors();
```

## 🔍 Debugging & Monitoring

### Provider Inspector
```dart
// Check provider state in debug mode
if (kDebugMode) {
  final globalState = ref.read(globalAppStateProvider);
  debugPrint('App State: $globalState');
}
```

### Storage Health Monitoring
```dart
// Perform health check
await ref.read(storageHealthMonitorProvider.notifier)
    .performHealthCheck();

// Check storage statistics
final stats = ref.read(hiveStorageNotifierProvider.notifier)
    .getStorageStats();
```

## 🛠️ Best Practices

1. **Import**: Use the barrel file `import '../core/providers/providers.dart'`
2. **Error Handling**: Always handle AsyncValue error states
3. **Disposal**: Providers auto-dispose, but manual cleanup when needed
4. **Performance**: Use `select()` for specific state slices
5. **Testing**: Mock providers using `ProviderContainer`
6. **State Size**: Keep provider state minimal and focused
7. **Provider Names**: Use descriptive names indicating purpose
8. **Documentation**: Document complex provider logic

## 📚 Code Generation

The providers use Riverpod's code generation. Run this command after making changes:

```bash
dart run build_runner build
```

For continuous generation during development:

```bash
dart run build_runner watch
```

## 🧪 Testing

### Provider Testing
```dart
test('theme provider updates correctly', () async {
  final container = ProviderContainer();

  final notifier = container.read(appSettingsNotifierProvider.notifier);
  await notifier.updateThemeMode(AppThemeMode.dark);

  final settings = container.read(appSettingsNotifierProvider);
  expect(settings.value?.themeMode, 'dark');

  container.dispose();
});
```

### Widget Testing with Providers
```dart
testWidgets('widget shows correct theme', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MyWidget(),
      ),
    ),
  );

  expect(find.text('Theme: system'), findsOneWidget);
});
```

## 📄 Dependencies

This setup requires the following dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  connectivity_plus: ^6.0.5
  flutter_secure_storage: ^9.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.7
```

## 🔄 Migration from Provider/Bloc

If migrating from other state management solutions:

1. Replace Provider with Riverpod providers
2. Convert Bloc to AsyncNotifierProvider
3. Update UI to use ConsumerWidget
4. Migrate state persistence logic
5. Update testing to use ProviderContainer

This setup provides a solid foundation for scalable Flutter applications with proper state management, error handling, and performance optimization.