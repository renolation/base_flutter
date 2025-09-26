# Hive Database Configuration

This directory contains the complete Hive database setup for local storage and caching in the Flutter app.

## Architecture Overview

The Hive database system is organized into the following components:

```
lib/core/database/
├── hive_service.dart              # Hive initialization and box management
├── models/
│   ├── app_settings.dart          # App settings model with Hive adapter
│   ├── app_settings.g.dart        # Generated Hive adapter
│   ├── cache_item.dart            # Generic cache wrapper model
│   ├── cache_item.g.dart          # Generated Hive adapter
│   ├── user_preferences.dart      # User preferences model
│   └── user_preferences.g.dart    # Generated Hive adapter
├── repositories/
│   ├── settings_repository.dart   # Settings repository implementation
│   ├── cache_repository.dart      # Cache repository implementation
│   └── user_preferences_repository.dart # User preferences repository
├── providers/
│   └── database_providers.dart    # Riverpod providers for database access
└── examples/
    └── database_usage_example.dart # Usage examples
```

## Features

### 1. HiveService
- **Initialization**: Sets up Hive for Flutter and registers type adapters
- **Box Management**: Manages three main boxes (appSettingsBox, cacheBox, userDataBox)
- **Migration Support**: Handles database schema migrations
- **Error Handling**: Comprehensive error handling and logging
- **Maintenance**: Database compaction and cleanup utilities

### 2. Models with Type Adapters

#### AppSettings (TypeId: 0)
- Application-wide configuration
- Theme mode, locale, notifications
- Cache settings and auto-update preferences
- Custom settings support
- Expiration logic for settings refresh

#### CacheItem (TypeId: 1)
- Generic cache wrapper for any data type
- Expiration logic with TTL support
- Metadata support for cache categorization
- Version control for cache migrations
- Statistics and performance monitoring

#### UserPreferences (TypeId: 2)
- User-specific settings and data
- Favorites management
- Last accessed tracking
- Preference categories with type safety
- User activity statistics

### 3. Repository Pattern
- **SettingsRepository**: Application settings management
- **CacheRepository**: Generic caching with TTL and expiration
- **UserPreferencesRepository**: User-specific data management

### 4. Riverpod Integration
- State management with providers
- Reactive updates when data changes
- Type-safe access to cached data
- Automatic cache invalidation

## Usage Examples

### Basic Initialization
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database service
  await HiveService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}
```

### Settings Management
```dart
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: settings.themeMode == 'dark',
      onChanged: (value) => notifier.updateThemeMode(value ? 'dark' : 'light'),
    );
  }
}
```

### Caching Data
```dart
class DataService {
  final CacheRepository _cache;

  Future<UserData> getUserData(String userId) async {
    // Try cache first
    final cachedData = _cache.get<UserData>('user_$userId');
    if (cachedData != null) {
      return cachedData;
    }

    // Fetch from API
    final userData = await api.fetchUserData(userId);

    // Cache with 1 hour expiration
    await _cache.put<UserData>(
      key: 'user_$userId',
      data: userData,
      expirationDuration: const Duration(hours: 1),
      metadata: {'type': 'user_data', 'userId': userId},
    );

    return userData;
  }
}
```

### User Preferences
```dart
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider(null));
    final notifier = ref.read(userPreferencesProvider(null).notifier);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('Compact Mode'),
          value: preferences?.getPreference<bool>('compactMode', false) ?? false,
          onChanged: (value) => notifier.setPreference('compactMode', value),
        ),
        // Favorites management
        IconButton(
          icon: Icon(preferences?.isFavorite('item123') == true
              ? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            if (preferences?.isFavorite('item123') == true) {
              notifier.removeFavorite('item123');
            } else {
              notifier.addFavorite('item123');
            }
          },
        ),
      ],
    );
  }
}
```

## Database Boxes

### appSettingsBox
- **Purpose**: Application-wide settings
- **Key**: String-based keys (e.g., 'app_settings')
- **Data**: AppSettings objects
- **Usage**: Theme, language, cache strategy, feature flags

### cacheBox
- **Purpose**: Generic caching with TTL
- **Key**: String-based cache keys
- **Data**: CacheItem objects wrapping any data type
- **Usage**: API responses, user data, computed values

### userDataBox
- **Purpose**: User-specific preferences and data
- **Key**: User ID or 'current_user_preferences' for default
- **Data**: UserPreferences objects
- **Usage**: User settings, favorites, activity tracking

## Cache Strategies

### Write-Through Cache
```dart
Future<void> updateUserData(UserData data) async {
  // Update API
  await api.updateUser(data);

  // Update cache
  await cacheRepository.put<UserData>(
    key: 'user_${data.id}',
    data: data,
    expirationDuration: const Duration(hours: 1),
  );
}
```

### Cache-Aside Pattern
```dart
Future<UserData> getUserData(String userId) async {
  // Check cache first
  var userData = cacheRepository.get<UserData>('user_$userId');

  if (userData == null) {
    // Cache miss - fetch from API
    userData = await api.fetchUser(userId);

    // Store in cache
    await cacheRepository.put<UserData>(
      key: 'user_$userId',
      data: userData,
      expirationDuration: const Duration(minutes: 30),
    );
  }

  return userData;
}
```

## Performance Optimizations

### 1. Lazy Loading
- Boxes are opened only when needed
- Data is loaded on-demand

### 2. Batch Operations
```dart
Future<void> cacheMultipleItems(Map<String, dynamic> items) async {
  final futures = items.entries.map((entry) =>
    cacheRepository.put<dynamic>(
      key: entry.key,
      data: entry.value,
      expirationDuration: const Duration(hours: 1),
    )
  );

  await Future.wait(futures);
}
```

### 3. Cache Maintenance
```dart
// Automatic cleanup of expired items
final result = await cacheRepository.performMaintenance();
print('Cleaned ${result['expiredItemsRemoved']} expired items');
```

## Error Handling

### Repository Level
- All repository methods have comprehensive try-catch blocks
- Errors are logged with stack traces
- Graceful degradation (return defaults on errors)

### Provider Level
- State management handles loading/error states
- Automatic retry mechanisms
- User-friendly error messages

### Service Level
- Database initialization errors are handled gracefully
- Box corruption recovery
- Migration failure handling

## Migration Strategy

### Version Control
```dart
class AppSettings {
  final int version; // Used for migrations

  // Migration logic in repository
  AppSettings _migrateSettings(AppSettings oldSettings) {
    if (oldSettings.version < 2) {
      // Perform migration to version 2
      return oldSettings.copyWith(
        version: 2,
        // Add new fields with defaults
        newField: defaultValue,
      );
    }
    return oldSettings;
  }
}
```

### Data Backup
```dart
// Export data before migration
final backup = settingsRepository.exportSettings();
final userBackup = userPreferencesRepository.exportUserPreferences();

// Perform migration
await HiveService.migrate();

// Restore if migration fails
if (migrationFailed) {
  await settingsRepository.importSettings(backup);
  await userPreferencesRepository.importUserPreferences(userBackup);
}
```

## Monitoring and Analytics

### Database Statistics
```dart
final stats = ref.watch(databaseStatsProvider);
print('Total items: ${stats['totalItems']}');
print('Cache hit rate: ${stats['cache']['hitRate']}%');
```

### Performance Metrics
```dart
final cacheStats = await cacheRepository.getStats();
print('Cache performance:');
print('- Hit rate: ${(cacheStats.hitRate * 100).toStringAsFixed(1)}%');
print('- Valid items: ${cacheStats.validItems}');
print('- Expired items: ${cacheStats.expiredItems}');
```

## Best Practices

### 1. Key Naming Convention
- Use descriptive, hierarchical keys: `user_123_profile`
- Include type information: `api_response_movies_popular`
- Use consistent separators: underscores or colons

### 2. TTL Management
- Short TTL for frequently changing data (5-30 minutes)
- Medium TTL for stable data (1-24 hours)
- Long TTL for static data (1-7 days)
- Permanent cache only for user preferences

### 3. Data Validation
- Validate data before caching
- Check data integrity on retrieval
- Handle corrupted data gracefully

### 4. Memory Management
- Regular cleanup of expired items
- Monitor cache size and performance
- Use appropriate data structures

### 5. Security
- Don't cache sensitive data without encryption
- Clear caches on logout
- Validate user access to cached data

## Testing Strategy

### Unit Tests
- Test repository methods with mock boxes
- Validate data serialization/deserialization
- Test error handling scenarios

### Integration Tests
- Test full database workflows
- Validate Riverpod provider interactions
- Test migration scenarios

### Performance Tests
- Measure cache hit rates
- Test with large datasets
- Monitor memory usage

This Hive database setup provides a robust, scalable foundation for local data storage and caching in your Flutter application.