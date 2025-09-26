import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/routing/route_guards.dart';
import '../../../../shared/presentation/providers/app_providers.dart';

/// Main settings page with theme switcher and navigation to other settings
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            _SectionHeader(title: 'Appearance'),
            _ThemeSection(themeMode: themeMode, ref: ref),

            const Divider(),

            // Account Section
            _SectionHeader(title: 'Account'),
            _AccountSection(authState: authState, ref: ref),

            const Divider(),

            // App Settings Section
            _SectionHeader(title: 'App Settings'),
            _AppSettingsSection(),

            const Divider(),

            // Privacy & Security Section
            _SectionHeader(title: 'Privacy & Security'),
            _PrivacySection(),

            const Divider(),

            // About Section
            _SectionHeader(title: 'About'),
            _AboutSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  final ThemeMode themeMode;
  final WidgetRef ref;

  const _ThemeSection({
    required this.themeMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.palette_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: const Text('Theme'),
          subtitle: Text(_getThemeModeText(themeMode)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(RoutePaths.settingsTheme),
        ),
        ListTile(
          leading: Icon(
            themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : themeMode == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: const Text('Quick Theme Toggle'),
          subtitle: const Text('Switch between light and dark mode'),
          trailing: Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
        ),
      ],
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'Follow system';
    }
  }
}

class _AccountSection extends StatelessWidget {
  final AuthState authState;
  final WidgetRef ref;

  const _AccountSection({
    required this.authState,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (authState == AuthState.authenticated) ...[
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            subtitle: const Text('Manage your profile information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.profile),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            subtitle: const Text('Sign out of your account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSignOutDialog(context, ref),
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Sign In'),
            subtitle: const Text('Sign in to your account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.login),
          ),
          ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title: const Text('Create Account'),
            subtitle: const Text('Sign up for a new account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.register),
          ),
        ],
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authStateProvider.notifier).logout();
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}

class _AppSettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          subtitle: const Text('Manage notification preferences'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(RoutePaths.settingsNotifications),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English (United States)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Language settings coming soon!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.storage_outlined),
          title: const Text('Storage'),
          subtitle: const Text('Manage local data and cache'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Storage settings coming soon!')),
            );
          },
        ),
      ],
    );
  }
}

class _PrivacySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy'),
          subtitle: const Text('Privacy settings and data protection'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(RoutePaths.settingsPrivacy),
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Security'),
          subtitle: const Text('App security and permissions'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Security settings coming soon!')),
            );
          },
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outlined),
          title: const Text('About'),
          subtitle: const Text('App version and information'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(RoutePaths.about),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          subtitle: const Text('Get help and contact support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & Support coming soon!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: const Text('Terms of Service'),
          subtitle: const Text('View terms and conditions'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terms of Service coming soon!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.policy_outlined),
          title: const Text('Privacy Policy'),
          subtitle: const Text('View privacy policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy Policy coming soon!')),
            );
          },
        ),
      ],
    );
  }
}

/// Theme settings page
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            subtitle: const Text('Use light theme'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            subtitle: const Text('Use dark theme'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            subtitle: const Text('Follow system theme'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {},
                            child: const Text('Filled Button'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('Outlined Button'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This is how your theme looks with sample content. The theme will be applied across the entire app.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}