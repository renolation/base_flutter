import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';

/// Theme showcase page demonstrating Material 3 design system
class ThemeShowcasePage extends ConsumerWidget {
  /// Creates a theme showcase page
  const ThemeShowcasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Theme Showcase'),
        actions: const [
          ThemeToggleIconButton(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.responsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Switch Section
            _buildSection(
              context,
              'Theme Mode Switch',
              Column(
                children: [
                  const ThemeModeSwitch(
                    style: ThemeSwitchStyle.segmented,
                    showLabel: true,
                  ),
                  AppSpacing.verticalSpaceLG,
                  const AnimatedThemeModeSwitch(),
                  AppSpacing.verticalSpaceLG,
                  const ThemeModeSwitch(
                    style: ThemeSwitchStyle.toggle,
                    showLabel: true,
                    labelText: 'Dark Mode',
                  ),
                ],
              ),
            ),

            // Typography Section
            _buildSection(
              context,
              'Typography',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: textTheme.displayLarge),
                  AppSpacing.verticalSpaceSM,
                  Text('Display Medium', style: textTheme.displayMedium),
                  AppSpacing.verticalSpaceSM,
                  Text('Display Small', style: textTheme.displaySmall),
                  AppSpacing.verticalSpaceMD,
                  Text('Headline Large', style: textTheme.headlineLarge),
                  AppSpacing.verticalSpaceXS,
                  Text('Headline Medium', style: textTheme.headlineMedium),
                  AppSpacing.verticalSpaceXS,
                  Text('Headline Small', style: textTheme.headlineSmall),
                  AppSpacing.verticalSpaceMD,
                  Text('Title Large', style: textTheme.titleLarge),
                  AppSpacing.verticalSpaceXS,
                  Text('Title Medium', style: textTheme.titleMedium),
                  AppSpacing.verticalSpaceXS,
                  Text('Title Small', style: textTheme.titleSmall),
                  AppSpacing.verticalSpaceMD,
                  Text('Body Large', style: textTheme.bodyLarge),
                  AppSpacing.verticalSpaceXS,
                  Text('Body Medium', style: textTheme.bodyMedium),
                  AppSpacing.verticalSpaceXS,
                  Text('Body Small', style: textTheme.bodySmall),
                  AppSpacing.verticalSpaceMD,
                  Text('Label Large', style: textTheme.labelLarge),
                  AppSpacing.verticalSpaceXS,
                  Text('Label Medium', style: textTheme.labelMedium),
                  AppSpacing.verticalSpaceXS,
                  Text('Label Small', style: textTheme.labelSmall),
                ],
              ),
            ),

            // Color Palette Section
            _buildSection(
              context,
              'Color Palette',
              Column(
                children: [
                  _buildColorRow(
                    context,
                    'Primary',
                    colorScheme.primary,
                    colorScheme.onPrimary,
                  ),
                  _buildColorRow(
                    context,
                    'Primary Container',
                    colorScheme.primaryContainer,
                    colorScheme.onPrimaryContainer,
                  ),
                  _buildColorRow(
                    context,
                    'Secondary',
                    colorScheme.secondary,
                    colorScheme.onSecondary,
                  ),
                  _buildColorRow(
                    context,
                    'Secondary Container',
                    colorScheme.secondaryContainer,
                    colorScheme.onSecondaryContainer,
                  ),
                  _buildColorRow(
                    context,
                    'Tertiary',
                    colorScheme.tertiary,
                    colorScheme.onTertiary,
                  ),
                  _buildColorRow(
                    context,
                    'Error',
                    colorScheme.error,
                    colorScheme.onError,
                  ),
                  _buildColorRow(
                    context,
                    'Surface',
                    colorScheme.surface,
                    colorScheme.onSurface,
                  ),
                ],
              ),
            ),

            // Buttons Section
            _buildSection(
              context,
              'Buttons',
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Filled Button'),
                  ),
                  AppSpacing.verticalSpaceSM,
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                  AppSpacing.verticalSpaceSM,
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  AppSpacing.verticalSpaceSM,
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                  AppSpacing.verticalSpaceSM,
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                      ),
                      AppSpacing.horizontalSpaceSM,
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                      ),
                      AppSpacing.horizontalSpaceSM,
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form Components Section
            _buildSection(
              context,
              'Form Components',
              Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Label',
                      hintText: 'Hint text',
                      helperText: 'Helper text',
                    ),
                  ),
                  AppSpacing.verticalSpaceLG,
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Error state',
                      errorText: 'Error message',
                      prefixIcon: Icon(Icons.error),
                    ),
                  ),
                  AppSpacing.verticalSpaceLG,
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                      const Text('Checkbox'),
                      AppSpacing.horizontalSpaceLG,
                      Radio<bool>(
                        value: true,
                        groupValue: true,
                        onChanged: null,
                      ),
                      const Text('Radio'),
                      const Spacer(),
                      Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cards Section
            _buildSection(
              context,
              'Cards',
              Column(
                children: [
                  Card(
                    child: Padding(
                      padding: AppSpacing.paddingLG,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Title',
                            style: theme.textTheme.titleMedium,
                          ),
                          AppSpacing.verticalSpaceSM,
                          Text(
                            'Card content with some descriptive text that demonstrates how cards look in the Material 3 design system.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          AppSpacing.verticalSpaceSM,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text('Action'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.verticalSpaceSM,
                  Card.filled(
                    child: Padding(
                      padding: AppSpacing.paddingLG,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filled Card',
                            style: theme.textTheme.titleMedium,
                          ),
                          AppSpacing.verticalSpaceSM,
                          Text(
                            'This is a filled card variant.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Spacing Demonstration
            _buildSection(
              context,
              'Spacing System',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('XS (4dp)', style: theme.textTheme.bodyMedium),
                  Container(
                    height: 2,
                    width: AppSpacing.xs,
                    color: colorScheme.primary,
                  ),
                  AppSpacing.verticalSpaceSM,
                  Text('SM (8dp)', style: theme.textTheme.bodyMedium),
                  Container(
                    height: 2,
                    width: AppSpacing.sm,
                    color: colorScheme.primary,
                  ),
                  AppSpacing.verticalSpaceSM,
                  Text('MD (12dp)', style: theme.textTheme.bodyMedium),
                  Container(
                    height: 2,
                    width: AppSpacing.md,
                    color: colorScheme.primary,
                  ),
                  AppSpacing.verticalSpaceSM,
                  Text('LG (16dp)', style: theme.textTheme.bodyMedium),
                  Container(
                    height: 2,
                    width: AppSpacing.lg,
                    color: colorScheme.primary,
                  ),
                  AppSpacing.verticalSpaceSM,
                  Text('XL (20dp)', style: theme.textTheme.bodyMedium),
                  Container(
                    height: 2,
                    width: AppSpacing.xl,
                    color: colorScheme.primary,
                  ),
                  AppSpacing.verticalSpaceSM,
                  Text('XXL (24dp)', style: theme.textTheme.bodyMedium),
                  Container(
                    height: 2,
                    width: AppSpacing.xxl,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        AppSpacing.verticalSpaceLG,
        content,
        AppSpacing.verticalSpaceXXL,
      ],
    );
  }

  Widget _buildColorRow(
    BuildContext context,
    String label,
    Color color,
    Color onColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppSpacing.radiusSM,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: onColor,
                ),
          ),
        ),
      ),
    );
  }
}