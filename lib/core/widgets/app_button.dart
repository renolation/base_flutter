import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Customizable button component with multiple variants following Material 3 design
///
/// Supports filled, outlined, text, and icon variants with consistent theming
/// and accessibility features.
class AppButton extends StatelessWidget {
  /// Creates an app button with the specified variant and configuration
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.semanticLabel,
  });

  /// The text displayed on the button
  final String text;

  /// Called when the button is pressed
  final VoidCallback? onPressed;

  /// The visual variant of the button
  final AppButtonVariant variant;

  /// The size of the button
  final AppButtonSize size;

  /// Optional icon to display alongside text
  final IconData? icon;

  /// Whether to show a loading indicator
  final bool isLoading;

  /// Whether the button should take full width
  final bool isFullWidth;

  /// Custom background color override
  final Color? backgroundColor;

  /// Custom foreground color override
  final Color? foregroundColor;

  /// Custom border color override (for outlined variant)
  final Color? borderColor;

  /// Custom elevation override
  final double? elevation;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get button configuration based on size
    final buttonHeight = _getButtonHeight();
    final buttonPadding = _getButtonPadding();
    final textStyle = _getTextStyle();
    final iconSize = _getIconSize();

    // Create button style
    final buttonStyle = _createButtonStyle(
      theme: theme,
      height: buttonHeight,
      padding: buttonPadding,
    );

    // Handle loading state
    if (isLoading) {
      return _buildLoadingButton(
        context: context,
        style: buttonStyle,
        height: buttonHeight,
      );
    }

    // Build appropriate button variant
    Widget button = switch (variant) {
      AppButtonVariant.filled => _buildFilledButton(
          context: context,
          style: buttonStyle,
          textStyle: textStyle,
          iconSize: iconSize,
        ),
      AppButtonVariant.outlined => _buildOutlinedButton(
          context: context,
          style: buttonStyle,
          textStyle: textStyle,
          iconSize: iconSize,
        ),
      AppButtonVariant.text => _buildTextButton(
          context: context,
          style: buttonStyle,
          textStyle: textStyle,
          iconSize: iconSize,
        ),
      AppButtonVariant.icon => _buildIconButton(
          context: context,
          iconSize: iconSize,
        ),
    };

    // Apply full width if needed
    if (isFullWidth && variant != AppButtonVariant.icon) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      button = Semantics(
        label: semanticLabel,
        child: button,
      );
    }

    return button;
  }

  /// Build filled button variant
  Widget _buildFilledButton({
    required BuildContext context,
    required ButtonStyle style,
    required TextStyle textStyle,
    required double iconSize,
  }) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Text(text, style: textStyle),
        style: style,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: Text(text, style: textStyle),
    );
  }

  /// Build outlined button variant
  Widget _buildOutlinedButton({
    required BuildContext context,
    required ButtonStyle style,
    required TextStyle textStyle,
    required double iconSize,
  }) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Text(text, style: textStyle),
        style: style,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text, style: textStyle),
    );
  }

  /// Build text button variant
  Widget _buildTextButton({
    required BuildContext context,
    required ButtonStyle style,
    required TextStyle textStyle,
    required double iconSize,
  }) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Text(text, style: textStyle),
        style: style,
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: style,
      child: Text(text, style: textStyle),
    );
  }

  /// Build icon button variant
  Widget _buildIconButton({
    required BuildContext context,
    required double iconSize,
  }) {
    if (icon == null) {
      throw ArgumentError('Icon button requires an icon');
    }

    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        minimumSize: Size(_getButtonHeight(), _getButtonHeight()),
        maximumSize: Size(_getButtonHeight(), _getButtonHeight()),
      ),
      tooltip: text,
    );
  }

  /// Build loading button state
  Widget _buildLoadingButton({
    required BuildContext context,
    required ButtonStyle style,
    required double height,
  }) {
    final theme = Theme.of(context);

    return FilledButton(
      onPressed: null,
      style: style,
      child: SizedBox(
        height: height * 0.5,
        width: height * 0.5,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  /// Create button style based on variant and customizations
  ButtonStyle _createButtonStyle({
    required ThemeData theme,
    required double height,
    required EdgeInsets padding,
  }) {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(0, height)),
      padding: WidgetStateProperty.all(padding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonRadius,
        ),
      ),
      backgroundColor: backgroundColor != null
          ? WidgetStateProperty.all(backgroundColor)
          : null,
      foregroundColor: foregroundColor != null
          ? WidgetStateProperty.all(foregroundColor)
          : null,
      side: borderColor != null && variant == AppButtonVariant.outlined
          ? WidgetStateProperty.all(BorderSide(color: borderColor!))
          : null,
      elevation: elevation != null
          ? WidgetStateProperty.all(elevation)
          : null,
    );
  }

  /// Get button height based on size
  double _getButtonHeight() {
    return switch (size) {
      AppButtonSize.small => AppSpacing.buttonHeightSmall,
      AppButtonSize.medium => AppSpacing.buttonHeight,
      AppButtonSize.large => AppSpacing.buttonHeightLarge,
    };
  }

  /// Get button padding based on size
  EdgeInsets _getButtonPadding() {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        ),
      AppButtonSize.large => const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxxl,
          vertical: AppSpacing.lg,
        ),
    };
  }

  /// Get text style based on size
  TextStyle _getTextStyle() {
    return switch (size) {
      AppButtonSize.small => AppTypography.labelMedium,
      AppButtonSize.medium => AppTypography.buttonText,
      AppButtonSize.large => AppTypography.labelLarge,
    };
  }

  /// Get icon size based on button size
  double _getIconSize() {
    return switch (size) {
      AppButtonSize.small => AppSpacing.iconSM,
      AppButtonSize.medium => AppSpacing.iconMD,
      AppButtonSize.large => AppSpacing.iconLG,
    };
  }
}

/// Available button variants
enum AppButtonVariant {
  /// Filled button with background color (primary action)
  filled,

  /// Outlined button with border (secondary action)
  outlined,

  /// Text button without background (tertiary action)
  text,

  /// Icon-only button
  icon,
}

/// Available button sizes
enum AppButtonSize {
  /// Small button (32dp height)
  small,

  /// Medium button (40dp height) - default
  medium,

  /// Large button (56dp height)
  large,
}