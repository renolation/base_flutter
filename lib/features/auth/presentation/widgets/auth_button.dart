import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

/// Reusable primary button specifically designed for authentication actions
/// Provides consistent styling, loading states, and accessibility features
class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.type = AuthButtonType.filled,
    this.icon,
    this.width = double.infinity,
    this.height = AppSpacing.buttonHeightLarge,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final AuthButtonType type;
  final Widget? icon;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    Widget child = _buildButtonChild(theme, colorScheme);

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedContainer(
        duration: AppSpacing.animationNormal,
        curve: Curves.easeInOut,
        child: _buildButtonByType(context, child, isButtonEnabled),
      ),
    );
  }

  Widget _buildButtonChild(ThemeData theme, ColorScheme colorScheme) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSpacing.iconSM,
            height: AppSpacing.iconSM,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getLoadingIndicatorColor(colorScheme),
            ),
          ),
          AppSpacing.horizontalSpaceSM,
          Text(
            'Please wait...',
            style: _getTextStyle(theme, colorScheme),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: _getIconColor(colorScheme),
              size: AppSpacing.iconSM,
            ),
            child: icon!,
          ),
          AppSpacing.horizontalSpaceSM,
          Flexible(
            child: Text(
              text,
              style: _getTextStyle(theme, colorScheme),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(theme, colorScheme),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildButtonByType(BuildContext context, Widget child, bool enabled) {
    switch (type) {
      case AuthButtonType.filled:
        return FilledButton(
          onPressed: enabled ? onPressed : null,
          style: _getFilledButtonStyle(context),
          child: child,
        );
      case AuthButtonType.outlined:
        return OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: _getOutlinedButtonStyle(context),
          child: child,
        );
      case AuthButtonType.text:
        return TextButton(
          onPressed: enabled ? onPressed : null,
          style: _getTextButtonStyle(context),
          child: child,
        );
    }
  }

  ButtonStyle _getFilledButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      elevation: AppSpacing.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
        vertical: AppSpacing.buttonPaddingVertical,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onPrimary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onPrimary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.onPrimary.withValues(alpha: 0.1);
          }
          return null;
        },
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      side: BorderSide(
        color: colorScheme.outline,
        width: AppSpacing.borderWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
        vertical: AppSpacing.buttonPaddingVertical,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    ).copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
              width: AppSpacing.borderWidth,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: colorScheme.primary,
              width: AppSpacing.borderWidthThick,
            );
          }
          return BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidth,
          );
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.primary.withValues(alpha: 0.1);
          }
          return null;
        },
      ),
    );
  }

  ButtonStyle _getTextButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
        vertical: AppSpacing.buttonPaddingVertical,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.primary.withValues(alpha: 0.1);
          }
          return null;
        },
      ),
    );
  }

  TextStyle _getTextStyle(ThemeData theme, ColorScheme colorScheme) {
    final baseStyle = theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ) ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        );

    if (!isEnabled || isLoading) {
      return baseStyle.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.38),
      );
    }

    switch (type) {
      case AuthButtonType.filled:
        return baseStyle.copyWith(color: colorScheme.onPrimary);
      case AuthButtonType.outlined:
      case AuthButtonType.text:
        return baseStyle.copyWith(color: colorScheme.primary);
    }
  }

  Color _getLoadingIndicatorColor(ColorScheme colorScheme) {
    switch (type) {
      case AuthButtonType.filled:
        return colorScheme.onPrimary;
      case AuthButtonType.outlined:
      case AuthButtonType.text:
        return colorScheme.primary;
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    if (!isEnabled) {
      return colorScheme.onSurface.withValues(alpha: 0.38);
    }

    switch (type) {
      case AuthButtonType.filled:
        return colorScheme.onPrimary;
      case AuthButtonType.outlined:
      case AuthButtonType.text:
        return colorScheme.primary;
    }
  }
}

/// Types of auth buttons available
enum AuthButtonType {
  /// Filled button with primary color background
  filled,

  /// Outlined button with transparent background and border
  outlined,

  /// Text button with no background or border
  text,
}