import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_providers.dart';

/// Example widget showing how to use the Hive database system
class DatabaseUsageExample extends ConsumerWidget {
  const DatabaseUsageExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Usage Example'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AppSettingsSection(),
            SizedBox(height: 24),
            _CacheSection(),
            SizedBox(height: 24),
            _UserPreferencesSection(),
            SizedBox(height: 24),
            _DatabaseStatsSection(),
          ],
        ),
      ),
    );
  }
}

/// App Settings Section
class _AppSettingsSection extends ConsumerWidget {
  const _AppSettingsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Theme Mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Theme Mode'),
                DropdownButton<String>(
                  value: settings.themeMode,
                  onChanged: (value) => notifier.updateThemeMode(value!),
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('System')),
                    DropdownMenuItem(value: 'light', child: Text('Light')),
                    DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  ],
                ),
              ],
            ),

            // Notifications
            SwitchListTile(
              title: const Text('Notifications'),
              value: settings.notificationsEnabled,
              onChanged: (value) => notifier.updateNotificationsEnabled(value),
            ),

            // Analytics
            SwitchListTile(
              title: const Text('Analytics'),
              value: settings.analyticsEnabled,
              onChanged: (value) => notifier.updateAnalyticsEnabled(value),
            ),

            // Cache Strategy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Cache Strategy'),
                DropdownButton<String>(
                  value: settings.cacheStrategy,
                  onChanged: (value) => notifier.updateCacheStrategy(value!),
                  items: const [
                    DropdownMenuItem(value: 'minimal', child: Text('Minimal')),
                    DropdownMenuItem(value: 'normal', child: Text('Normal')),
                    DropdownMenuItem(value: 'aggressive', child: Text('Aggressive')),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => notifier.resetToDefault(),
              child: const Text('Reset to Default'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cache Section
class _CacheSection extends ConsumerWidget {
  const _CacheSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheRepository = ref.watch(cacheRepositoryProvider);
    final cacheStatsAsyncValue = ref.watch(cacheStatsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cache Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Cache Statistics
            cacheStatsAsyncValue.when(
              data: (stats) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Items: ${stats.totalItems}'),
                  Text('Valid Items: ${stats.validItems}'),
                  Text('Expired Items: ${stats.expiredItems}'),
                  Text('Hit Rate: ${(stats.hitRate * 100).toStringAsFixed(1)}%'),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
            ),

            const SizedBox(height: 12),

            // Cache Actions
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Example: Cache some data
                    await cacheRepository.put<String>(
                      key: 'example_key',
                      data: 'Hello, Cache!',
                      expirationDuration: const Duration(minutes: 30),
                      metadata: {'type': 'example', 'created_by': 'user'},
                    );
                    ref.invalidate(cacheStatsProvider);
                  },
                  child: const Text('Add Cache Item'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final data = cacheRepository.get<String>('example_key');
                    if (data != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cached data: $data')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No cached data found')),
                      );
                    }
                  },
                  child: const Text('Get Cache Item'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final expiredCount = await cacheRepository.clearExpired();
                    ref.invalidate(cacheStatsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cleared $expiredCount expired items')),
                      );
                    }
                  },
                  child: const Text('Clear Expired'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// User Preferences Section
class _UserPreferencesSection extends ConsumerWidget {
  const _UserPreferencesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferences = ref.watch(userPreferencesProvider(null));
    final notifier = ref.read(userPreferencesProvider(null).notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (userPreferences == null)
              Column(
                children: [
                  const Text('No user preferences found'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await notifier.createUserPreferences(
                        userId: 'demo_user',
                        displayName: 'Demo User',
                        email: 'demo@example.com',
                        preferences: {
                          'compactMode': false,
                          'sortBy': 'name',
                          'gridColumns': 2,
                        },
                      );
                    },
                    child: const Text('Create Demo User'),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User ID: ${userPreferences.userId}'),
                  Text('Display Name: ${userPreferences.displayName}'),
                  Text('Email: ${userPreferences.email ?? 'Not set'}'),
                  Text('Favorites: ${userPreferences.favoriteItems.length}'),
                  Text('Preferences: ${userPreferences.preferences.length}'),

                  const SizedBox(height: 12),

                  // Preference Controls
                  SwitchListTile(
                    title: const Text('Compact Mode'),
                    value: userPreferences.getPreference<bool>('compactMode', false),
                    onChanged: (value) => notifier.setPreference('compactMode', value),
                  ),

                  const SizedBox(height: 12),

                  // Actions
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await notifier.addFavorite('item_${DateTime.now().millisecondsSinceEpoch}');
                        },
                        child: const Text('Add Random Favorite'),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          await notifier.updateLastAccessed('demo_item');
                        },
                        child: const Text('Update Last Accessed'),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          await notifier.clearPreferences();
                        },
                        child: const Text('Clear User Data'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Database Statistics Section
class _DatabaseStatsSection extends ConsumerWidget {
  const _DatabaseStatsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStats = ref.watch(databaseStatsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Database Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Text('Total Items: ${databaseStats['totalItems']}'),

            if (databaseStats['settings'] != null) ...[
              const SizedBox(height: 8),
              const Text('Settings:', style: TextStyle(fontWeight: FontWeight.w500)),
              ...((databaseStats['settings'] as Map<String, dynamic>).entries.map(
                (entry) => Text('  ${entry.key}: ${entry.value}'),
              )),
            ],

            if (databaseStats['cache'] != null) ...[
              const SizedBox(height: 8),
              const Text('Cache:', style: TextStyle(fontWeight: FontWeight.w500)),
              ...((databaseStats['cache'] as Map<String, dynamic>).entries.map(
                (entry) => Text('  ${entry.key}: ${entry.value}'),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

/// Helper functions for demonstrating cache operations
class CacheExamples {
  static Future<void> demonstrateCaching(WidgetRef ref) async {
    final cacheRepository = ref.read(cacheRepositoryProvider);

    // Store different types of data
    await cacheRepository.put<String>(
      key: 'user_token',
      data: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
      expirationDuration: const Duration(hours: 1),
      metadata: {'type': 'auth_token'},
    );

    await cacheRepository.put<Map<String, dynamic>>(
      key: 'user_profile',
      data: {
        'id': 123,
        'name': 'John Doe',
        'email': 'john@example.com',
      },
      expirationDuration: const Duration(minutes: 30),
      metadata: {'type': 'user_data'},
    );

    await cacheRepository.put<List<String>>(
      key: 'recent_searches',
      data: ['flutter', 'dart', 'hive'],
      expirationDuration: const Duration(days: 7),
      metadata: {'type': 'user_activity'},
    );

    // Retrieve data
    final token = cacheRepository.get<String>('user_token');
    final profile = cacheRepository.get<Map<String, dynamic>>('user_profile');
    final searches = cacheRepository.get<List<String>>('recent_searches');

    print('Token: $token');
    print('Profile: $profile');
    print('Searches: $searches');
  }

  static Future<void> demonstrateUserPreferences(WidgetRef ref) async {
    final repository = ref.read(userPreferencesRepositoryProvider);

    // Create user preferences
    final preferences = await repository.createUserPreferences(
      userId: 'user_123',
      displayName: 'Alice Smith',
      email: 'alice@example.com',
      preferences: {
        'theme': 'dark',
        'notifications': true,
        'language': 'en',
        'autoBackup': false,
      },
    );

    print('Created preferences: $preferences');

    // Update preferences
    await repository.setPreference('theme', 'light', 'user_123');
    await repository.addFavorite('movie_456', 'user_123');
    await repository.updateLastAccessed('series_789', 'user_123');

    // Retrieve data
    final theme = repository.getPreference<String>('theme', 'system', 'user_123');
    final favorites = repository.getFavorites('user_123');
    final recentItems = repository.getRecentlyAccessed(userId: 'user_123');

    print('Theme: $theme');
    print('Favorites: $favorites');
    print('Recent items: $recentItems');
  }
}