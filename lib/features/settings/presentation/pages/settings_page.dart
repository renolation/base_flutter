import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/routing/route_guards.dart';
import '../../../../shared/presentation/providers/app_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

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
          title: Text(
            'Theme',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            _getThemeModeText(themeMode),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
          title: Text(
            'Quick Theme Toggle',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Switch between light and dark mode',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
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
            leading: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Manage your profile information',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
            onTap: () => context.push(RoutePaths.profile),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Sign out of your account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
            onTap: () => _showSignOutDialog(context, ref),
          ),
        ] else ...[
          ListTile(
            leading: Icon(
              Icons.login,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Sign In',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Sign in to your account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
            onTap: () => context.push(RoutePaths.login),
          ),
          ListTile(
            leading: Icon(
              Icons.person_add_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Create Account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Sign up for a new account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
                ref.read(authNotifierProvider.notifier).logout();
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
          leading: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Manage notification preferences',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () => context.push(RoutePaths.settingsNotifications),
        ),
        ListTile(
          leading: Icon(
            Icons.language,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Language',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'English (United States)',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Language settings coming soon!')),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.storage_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Storage',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Manage local data and cache',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
          leading: Icon(
            Icons.privacy_tip_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Privacy',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Privacy settings and data protection',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () => context.push(RoutePaths.settingsPrivacy),
        ),
        ListTile(
          leading: Icon(
            Icons.security,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Security',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'App security and permissions',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
          leading: Icon(
            Icons.info_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'About',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'App version and information',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () => context.push(RoutePaths.about),
        ),
        ListTile(
          leading: Icon(
            Icons.help_outline,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Help & Support',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Get help and contact support',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & Support coming soon!')),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.article_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Terms of Service',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'View terms and conditions',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terms of Service coming soon!')),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.policy_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Privacy Policy',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'View privacy policy',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  subtitle: const Text('Use light theme'),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  subtitle: const Text('Use dark theme'),
                  value: ThemeMode.dark,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System'),
                  subtitle: const Text('Follow system theme'),
                  value: ThemeMode.system,
                ),
              ],
            ),
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