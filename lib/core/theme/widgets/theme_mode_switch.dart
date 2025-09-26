import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

/// Theme mode switch widget with Material 3 design
class ThemeModeSwitch extends ConsumerWidget {
  /// Creates a theme mode switch
  const ThemeModeSwitch({
    super.key,
    this.showLabel = true,
    this.labelText,
    this.onChanged,
    this.size = ThemeSwitchSize.medium,
    this.style = ThemeSwitchStyle.toggle,
  });

  /// Whether to show the label
  final bool showLabel;

  /// Custom label text
  final String? labelText;

  /// Callback when theme mode changes
  final ValueChanged<ThemeMode>? onChanged;

  /// Size of the switch
  final ThemeSwitchSize size;

  /// Style of the switch
  final ThemeSwitchStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll use a simple state provider
    // In a real app, this would be connected to your theme provider
    final themeMode = ref.watch(_themeModeProvider);
    final theme = Theme.of(context);

    switch (style) {
      case ThemeSwitchStyle.toggle:
        return _buildToggleSwitch(context, theme, themeMode, ref);
      case ThemeSwitchStyle.segmented:
        return _buildSegmentedSwitch(context, theme, themeMode, ref);
      case ThemeSwitchStyle.radio:
        return _buildRadioSwitch(context, theme, themeMode, ref);
      case ThemeSwitchStyle.dropdown:
        return _buildDropdownSwitch(context, theme, themeMode, ref);
    }
  }

  Widget _buildToggleSwitch(
    BuildContext context,
    ThemeData theme,
    ThemeMode themeMode,
    WidgetRef ref,
  ) {
    final isDark = themeMode == ThemeMode.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Icon(
            Icons.light_mode,
            size: _getIconSize(),
            color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.6) : theme.colorScheme.primary,
          ),
          AppSpacing.horizontalSpaceSM,
        ],
        Switch(
          value: isDark,
          onChanged: (value) {
            final newMode = value ? ThemeMode.dark : ThemeMode.light;
            ref.read(_themeModeProvider.notifier).state = newMode;
            onChanged?.call(newMode);
          },
          thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Icon(
                  Icons.dark_mode,
                  size: _getIconSize() * 0.7,
                );
              }
              return Icon(
                Icons.light_mode,
                size: _getIconSize() * 0.7,
              );
            },
          ),
        ),
        if (showLabel) ...[
          AppSpacing.horizontalSpaceSM,
          Icon(
            Icons.dark_mode,
            size: _getIconSize(),
            color: isDark ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
        if (showLabel && labelText != null) ...[
          AppSpacing.horizontalSpaceSM,
          Text(
            labelText!,
            style: _getLabelStyle(),
          ),
        ],
      ],
    );
  }

  Widget _buildSegmentedSwitch(
    BuildContext context,
    ThemeData theme,
    ThemeMode themeMode,
    WidgetRef ref,
  ) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.light_mode, size: _getIconSize()),
              if (showLabel) ...[
                AppSpacing.horizontalSpaceXS,
                Text('Light', style: _getLabelStyle()),
              ],
            ],
          ),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.brightness_auto, size: _getIconSize()),
              if (showLabel) ...[
                AppSpacing.horizontalSpaceXS,
                Text('Auto', style: _getLabelStyle()),
              ],
            ],
          ),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dark_mode, size: _getIconSize()),
              if (showLabel) ...[
                AppSpacing.horizontalSpaceXS,
                Text('Dark', style: _getLabelStyle()),
              ],
            ],
          ),
        ),
      ],
      selected: {themeMode},
      onSelectionChanged: (Set<ThemeMode> selection) {
        final newMode = selection.first;
        ref.read(_themeModeProvider.notifier).state = newMode;
        onChanged?.call(newMode);
      },
    );
  }

  Widget _buildRadioSwitch(
    BuildContext context,
    ThemeData theme,
    ThemeMode themeMode,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel && labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              labelText!,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ...ThemeMode.values.map((mode) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            dense: size == ThemeSwitchSize.small,
            leading: Radio<ThemeMode>(
              value: mode,
              groupValue: themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  ref.read(_themeModeProvider.notifier).state = value;
                  onChanged?.call(value);
                }
              },
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getThemeModeIcon(mode), size: _getIconSize()),
                AppSpacing.horizontalSpaceSM,
                Text(_getThemeModeLabel(mode), style: _getLabelStyle()),
              ],
            ),
            onTap: () {
              ref.read(_themeModeProvider.notifier).state = mode;
              onChanged?.call(mode);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDropdownSwitch(
    BuildContext context,
    ThemeData theme,
    ThemeMode themeMode,
    WidgetRef ref,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel && labelText != null) ...[
          Text(
            labelText!,
            style: theme.textTheme.titleMedium,
          ),
          AppSpacing.horizontalSpaceSM,
        ],
        DropdownButton<ThemeMode>(
          value: themeMode,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              ref.read(_themeModeProvider.notifier).state = value;
              onChanged?.call(value);
            }
          },
          items: ThemeMode.values.map((mode) {
            return DropdownMenuItem<ThemeMode>(
              value: mode,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getThemeModeIcon(mode), size: _getIconSize()),
                  AppSpacing.horizontalSpaceSM,
                  Text(_getThemeModeLabel(mode), style: _getLabelStyle()),
                ],
              ),
            );
          }).toList(),
          underline: const SizedBox(),
        ),
      ],
    );
  }

  double _getIconSize() {
    switch (size) {
      case ThemeSwitchSize.small:
        return AppSpacing.iconSM;
      case ThemeSwitchSize.medium:
        return AppSpacing.iconMD;
      case ThemeSwitchSize.large:
        return AppSpacing.iconLG;
    }
  }

  TextStyle _getLabelStyle() {
    switch (size) {
      case ThemeSwitchSize.small:
        return AppTypography.labelSmall;
      case ThemeSwitchSize.medium:
        return AppTypography.labelMedium;
      case ThemeSwitchSize.large:
        return AppTypography.labelLarge;
    }
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

/// Theme switch sizes
enum ThemeSwitchSize {
  small,
  medium,
  large,
}

/// Theme switch styles
enum ThemeSwitchStyle {
  toggle,
  segmented,
  radio,
  dropdown,
}

/// Animated theme mode switch with smooth transitions
class AnimatedThemeModeSwitch extends ConsumerStatefulWidget {
  /// Creates an animated theme mode switch
  const AnimatedThemeModeSwitch({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.showIcon = true,
    this.iconSize = 24.0,
  });

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to show the theme icon
  final bool showIcon;

  /// Size of the theme icon
  final double iconSize;

  @override
  ConsumerState<AnimatedThemeModeSwitch> createState() => _AnimatedThemeModeSwitchState();
}

class _AnimatedThemeModeSwitchState extends ConsumerState<AnimatedThemeModeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(_themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    // Update animation based on theme mode
    if (isDark) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return GestureDetector(
      onTap: () {
        final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
        ref.read(_themeModeProvider.notifier).state = newMode;
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.iconSize * 2.5,
            height: widget.iconSize * 1.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.iconSize * 0.7),
              color: Color.lerp(
                theme.colorScheme.surfaceContainerHighest,
                theme.colorScheme.inverseSurface,
                _animation.value,
              ),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Sun icon
                AnimatedPositioned(
                  duration: widget.duration,
                  curve: widget.curve,
                  left: isDark ? -widget.iconSize : widget.iconSize * 0.2,
                  top: widget.iconSize * 0.2,
                  child: AnimatedOpacity(
                    duration: widget.duration,
                    opacity: isDark ? 0.0 : 1.0,
                    child: Icon(
                      Icons.light_mode,
                      size: widget.iconSize,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                // Moon icon
                AnimatedPositioned(
                  duration: widget.duration,
                  curve: widget.curve,
                  left: isDark ? widget.iconSize * 1.3 : widget.iconSize * 2.5,
                  top: widget.iconSize * 0.2,
                  child: AnimatedOpacity(
                    duration: widget.duration,
                    opacity: isDark ? 1.0 : 0.0,
                    child: Icon(
                      Icons.dark_mode,
                      size: widget.iconSize,
                      color: theme.colorScheme.onInverseSurface,
                    ),
                  ),
                ),
                // Sliding thumb
                AnimatedPositioned(
                  duration: widget.duration,
                  curve: widget.curve,
                  left: isDark ? widget.iconSize * 1.1 : widget.iconSize * 0.1,
                  top: widget.iconSize * 0.1,
                  child: Container(
                    width: widget.iconSize * 1.2,
                    height: widget.iconSize * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Simple theme toggle icon button
class ThemeToggleIconButton extends ConsumerWidget {
  /// Creates a theme toggle icon button
  const ThemeToggleIconButton({
    super.key,
    this.tooltip,
    this.iconSize,
    this.onPressed,
  });

  /// Tooltip text
  final String? tooltip;

  /// Icon size
  final double? iconSize;

  /// Custom callback
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(_themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      onPressed: onPressed ??
          () {
            final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
            ref.read(_themeModeProvider.notifier).state = newMode;
          },
      icon: AnimatedSwitcher(
        duration: AppSpacing.animationNormal,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(turns: animation, child: child);
        },
        child: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          key: ValueKey(isDark),
          size: iconSize,
        ),
      ),
      tooltip: tooltip ?? (isDark ? 'Switch to light mode' : 'Switch to dark mode'),
    );
  }
}

/// Theme mode provider - replace with your actual theme provider
final _themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Theme mode controller for managing theme state
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system);

  /// Switch to light mode
  void setLightMode() => state = ThemeMode.light;

  /// Switch to dark mode
  void setDarkMode() => state = ThemeMode.dark;

  /// Switch to system mode
  void setSystemMode() => state = ThemeMode.system;

  /// Toggle between light and dark (ignoring system)
  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Check if current mode is dark
  bool get isDark => state == ThemeMode.dark;

  /// Check if current mode is light
  bool get isLight => state == ThemeMode.light;

  /// Check if current mode is system
  bool get isSystem => state == ThemeMode.system;
}

/// Provider for theme mode controller
final themeModeControllerProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController();
});

/// Utility methods for theme mode
extension ThemeModeExtensions on ThemeMode {
  /// Get the display name for the theme mode
  String get displayName {
    switch (this) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get the icon for the theme mode
  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Get the description for the theme mode
  String get description {
    switch (this) {
      case ThemeMode.light:
        return 'Use light theme';
      case ThemeMode.dark:
        return 'Use dark theme';
      case ThemeMode.system:
        return 'Follow system setting';
    }
  }
}