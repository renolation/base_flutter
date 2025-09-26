import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Snackbar utilities for consistent notifications and user feedback
///
/// Provides easy-to-use static methods for showing different types of
/// snackbars with Material 3 styling and customization options.
class AppSnackbar {
  // Prevent instantiation
  AppSnackbar._();

  /// Show a basic snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
    double? elevation,
    EdgeInsets? margin,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final snackBarTheme = theme.snackBarTheme;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(
          color: textColor ?? snackBarTheme.contentTextStyle?.color,
        ),
      ),
      duration: duration,
      action: action,
      backgroundColor: backgroundColor ?? snackBarTheme.backgroundColor,
      elevation: elevation ?? snackBarTheme.elevation,
      margin: margin ?? _getDefaultMargin(context),
      shape: shape ?? snackBarTheme.shape,
      behavior: behavior,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show a success snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final successColor = _getSuccessColor(theme);

    return _showWithIcon(
      context: context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: successColor,
      textColor: _getOnColor(successColor),
      iconColor: _getOnColor(successColor),
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );
  }

  /// Show an error snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    SnackBarAction? action,
    bool showCloseIcon = true,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _showWithIcon(
      context: context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
      iconColor: colorScheme.onError,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );
  }

  /// Show a warning snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final warningColor = _getWarningColor(theme);

    return _showWithIcon(
      context: context,
      message: message,
      icon: Icons.warning_outlined,
      backgroundColor: warningColor,
      textColor: _getOnColor(warningColor),
      iconColor: _getOnColor(warningColor),
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );
  }

  /// Show an info snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final infoColor = _getInfoColor(theme);

    return _showWithIcon(
      context: context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: infoColor,
      textColor: _getOnColor(infoColor),
      iconColor: _getOnColor(infoColor),
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );
  }

  /// Show a loading snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading({
    required BuildContext context,
    String message = 'Loading...',
    Duration duration = const Duration(seconds: 30),
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final snackBar = SnackBar(
      content: Row(
        children: [
          SizedBox(
            width: AppSpacing.iconSM,
            height: AppSpacing.iconSM,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      duration: duration,
      backgroundColor: colorScheme.surfaceContainerHighest,
      margin: _getDefaultMargin(context),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusSM,
      ),
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show an action snackbar with custom button
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAction({
    required BuildContext context,
    required String message,
    required String actionLabel,
    required VoidCallback onActionPressed,
    Duration duration = const Duration(seconds: 6),
    Color? backgroundColor,
    Color? textColor,
    Color? actionColor,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return show(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onActionPressed,
        textColor: actionColor ?? colorScheme.inversePrimary,
      ),
    );
  }

  /// Show an undo snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showUndo({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    String undoLabel = 'Undo',
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onVisible,
  }) {
    return showAction(
      context: context,
      message: message,
      actionLabel: undoLabel,
      onActionPressed: onUndo,
      duration: duration,
      onVisible: onVisible,
    );
  }

  /// Show a retry snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showRetry({
    required BuildContext context,
    String message = 'Something went wrong',
    required VoidCallback onRetry,
    String retryLabel = 'Retry',
    Duration duration = const Duration(seconds: 6),
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _showWithIcon(
      context: context,
      message: message,
      icon: Icons.refresh,
      backgroundColor: colorScheme.errorContainer,
      textColor: colorScheme.onErrorContainer,
      iconColor: colorScheme.onErrorContainer,
      duration: duration,
      action: SnackBarAction(
        label: retryLabel,
        onPressed: onRetry,
        textColor: colorScheme.error,
      ),
      onVisible: onVisible,
    );
  }

  /// Show a custom snackbar with icon
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustom({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    if (icon != null) {
      return _showWithIcon(
        context: context,
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        iconColor: iconColor,
        duration: duration,
        action: action,
        showCloseIcon: showCloseIcon,
        onVisible: onVisible,
      );
    }

    return show(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );
  }

  /// Hide current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Remove all snackbars
  static void removeAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  // Helper methods

  /// Show snackbar with icon
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showWithIcon({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    bool showCloseIcon = false,
    VoidCallback? onVisible,
  }) {
    final theme = Theme.of(context);
    final snackBarTheme = theme.snackBarTheme;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSM,
            color: iconColor ?? textColor,
          ),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: textColor ?? snackBarTheme.contentTextStyle?.color,
              ),
            ),
          ),
        ],
      ),
      duration: duration,
      action: action,
      backgroundColor: backgroundColor ?? snackBarTheme.backgroundColor,
      elevation: snackBarTheme.elevation,
      margin: _getDefaultMargin(context),
      shape: snackBarTheme.shape,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: showCloseIcon,
      onVisible: onVisible,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Get default margin for floating snackbars
  static EdgeInsets _getDefaultMargin(BuildContext context) {
    return const EdgeInsets.all(AppSpacing.md);
  }

  /// Get success color from theme extension or fallback
  static Color _getSuccessColor(ThemeData theme) {
    return const Color(0xFF4CAF50); // Material Green 500
  }

  /// Get warning color from theme extension or fallback
  static Color _getWarningColor(ThemeData theme) {
    return const Color(0xFFFF9800); // Material Orange 500
  }

  /// Get info color from theme extension or fallback
  static Color _getInfoColor(ThemeData theme) {
    return theme.colorScheme.primary;
  }

  /// Get appropriate "on" color for given background color
  static Color _getOnColor(Color backgroundColor) {
    // Simple calculation based on luminance
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
  }
}

/// Custom snackbar widget for more complex layouts
class AppCustomSnackbar extends StatelessWidget {
  /// Creates a custom snackbar widget
  const AppCustomSnackbar({
    super.key,
    required this.child,
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.shape,
    this.behavior = SnackBarBehavior.floating,
    this.width,
    this.padding,
  });

  /// The content to display in the snackbar
  final Widget child;

  /// Background color override
  final Color? backgroundColor;

  /// Elevation override
  final double? elevation;

  /// Margin around the snackbar
  final EdgeInsets? margin;

  /// Shape override
  final ShapeBorder? shape;

  /// Snackbar behavior
  final SnackBarBehavior behavior;

  /// Fixed width override
  final double? width;

  /// Content padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snackBarTheme = theme.snackBarTheme;

    Widget content = Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );

    return SnackBar(
      content: content,
      backgroundColor: backgroundColor ?? snackBarTheme.backgroundColor,
      elevation: elevation ?? snackBarTheme.elevation,
      margin: margin ?? const EdgeInsets.all(AppSpacing.md),
      shape: shape ?? snackBarTheme.shape,
      behavior: behavior,
      padding: EdgeInsets.zero, // Remove default padding since we handle it
    );
  }

  /// Show this custom snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    Duration duration = const Duration(seconds: 4),
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: child,
        backgroundColor: backgroundColor,
        elevation: elevation,
        margin: margin ?? const EdgeInsets.all(AppSpacing.md),
        shape: shape,
        behavior: behavior,
        duration: duration,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

/// Snackbar with rich content (title, subtitle, actions)
class AppRichSnackbar extends StatelessWidget {
  /// Creates a rich snackbar with title, subtitle, and actions
  const AppRichSnackbar({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actions,
    this.backgroundColor,
    this.onTap,
  });

  /// Main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional leading icon
  final IconData? icon;

  /// Optional action widgets
  final List<Widget>? actions;

  /// Background color override
  final Color? backgroundColor;

  /// Tap callback for the entire snackbar
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppSpacing.iconMD,
            color: backgroundColor != null
                ? _getOnColor(backgroundColor!)
                : colorScheme.onSurfaceVariant,
          ),
          AppSpacing.horizontalSpaceMD,
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  color: backgroundColor != null
                      ? _getOnColor(backgroundColor!)
                      : colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                AppSpacing.verticalSpaceXS,
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(
                    color: backgroundColor != null
                        ? _getOnColor(backgroundColor!).withOpacity(0.8)
                        : colorScheme.onSurfaceVariant.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (actions != null && actions!.isNotEmpty) ...[
          AppSpacing.horizontalSpaceSM,
          Row(children: actions!),
        ],
      ],
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.radiusSM,
        child: content,
      );
    }

    return AppCustomSnackbar(
      backgroundColor: backgroundColor,
      child: content,
    );
  }

  /// Show this rich snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    Duration duration = const Duration(seconds: 5),
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: this,
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Get appropriate "on" color for given background color
  static Color _getOnColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
  }
}