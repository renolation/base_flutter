import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

/// Custom dialog components with Material 3 styling and consistent design
///
/// Provides reusable dialog widgets for common use cases like confirmation,
/// information display, and custom content dialogs.
class AppDialog extends StatelessWidget {
  /// Creates a dialog with the specified content and actions
  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.icon,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.insetPadding,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
  }) : onConfirm = null,
       onCancel = null,
       onOk = null,
       confirmText = '',
       cancelText = '',
       okText = '',
       isDestructive = false;

  /// Creates a confirmation dialog
  const AppDialog.confirmation({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.insetPadding,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
  }) : actions = null,
       onOk = null,
       okText = '';

  /// Creates an information dialog
  const AppDialog.info({
    super.key,
    required this.title,
    required this.content,
    this.icon = Icons.info_outline,
    this.onOk,
    this.okText = 'OK',
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.insetPadding,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
  }) : actions = null,
       onConfirm = null,
       onCancel = null,
       confirmText = 'OK',
       cancelText = '',
       isDestructive = false;

  /// Creates a warning dialog
  const AppDialog.warning({
    super.key,
    required this.title,
    required this.content,
    this.icon = Icons.warning_outlined,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText = 'Continue',
    this.cancelText = 'Cancel',
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.insetPadding,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
  }) : actions = null,
       isDestructive = true,
       onOk = null,
       okText = '';

  /// Creates an error dialog
  const AppDialog.error({
    super.key,
    this.title = 'Error',
    required this.content,
    this.icon = Icons.error_outline,
    this.onOk,
    this.okText = 'OK',
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.insetPadding,
    this.contentPadding,
    this.actionsPadding,
    this.semanticLabel,
  }) : actions = null,
       onConfirm = null,
       onCancel = null,
       confirmText = 'OK',
       cancelText = '',
       isDestructive = false;

  /// Dialog title
  final String? title;

  /// Dialog content (text or widget)
  final dynamic content;

  /// Custom action widgets
  final List<Widget>? actions;

  /// Dialog icon
  final IconData? icon;

  /// Confirm button callback
  final VoidCallback? onConfirm;

  /// Cancel button callback
  final VoidCallback? onCancel;

  /// OK button callback (for info/error dialogs)
  final VoidCallback? onOk;

  /// Confirm button text
  final String confirmText;

  /// Cancel button text
  final String cancelText;

  /// OK button text
  final String okText;

  /// Whether the confirm action is destructive
  final bool isDestructive;

  /// Background color override
  final Color? backgroundColor;

  /// Elevation override
  final double? elevation;

  /// Shape override
  final ShapeBorder? shape;

  /// Inset padding override
  final EdgeInsets? insetPadding;

  /// Content padding override
  final EdgeInsets? contentPadding;

  /// Actions padding override
  final EdgeInsets? actionsPadding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? titleWidget;
    if (title != null || icon != null) {
      titleWidget = _buildTitle(context);
    }

    Widget? contentWidget;
    if (content != null) {
      contentWidget = _buildContent(context);
    }

    List<Widget>? actionWidgets;
    if (actions != null) {
      actionWidgets = actions;
    } else {
      actionWidgets = _buildDefaultActions(context);
    }

    Widget dialog = AlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: actionWidgets,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: AppSpacing.dialogRadius,
          ),
      insetPadding: insetPadding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.screenPaddingLarge,
          ),
      contentPadding: contentPadding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingLarge,
            AppSpacing.lg,
            AppSpacing.screenPaddingLarge,
            AppSpacing.sm,
          ),
      actionsPadding: actionsPadding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingLarge,
            0,
            AppSpacing.screenPaddingLarge,
            AppSpacing.lg,
          ),
    );

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      dialog = Semantics(
        label: semanticLabel,
        child: dialog,
      );
    }

    return dialog;
  }

  /// Build dialog title with optional icon
  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (icon != null && title != null) {
      return Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconMD,
            color: _getIconColor(colorScheme),
          ),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Text(
              title!,
              style: theme.dialogTheme.titleTextStyle ??
                  AppTypography.headlineSmall,
            ),
          ),
        ],
      );
    } else if (icon != null) {
      return Icon(
        icon,
        size: AppSpacing.iconLG,
        color: _getIconColor(colorScheme),
      );
    } else if (title != null) {
      return Text(
        title!,
        style: theme.dialogTheme.titleTextStyle ??
            AppTypography.headlineSmall,
      );
    }

    return const SizedBox.shrink();
  }

  /// Build dialog content
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    if (content is Widget) {
      return content as Widget;
    } else if (content is String) {
      return Text(
        content as String,
        style: theme.dialogTheme.contentTextStyle ??
            AppTypography.bodyMedium,
      );
    }

    return const SizedBox.shrink();
  }

  /// Build default action buttons based on dialog type
  List<Widget>? _buildDefaultActions(BuildContext context) {
    // Info/Error dialog with single OK button
    if (onOk != null) {
      return [
        AppButton(
          text: okText,
          onPressed: () {
            Navigator.of(context).pop();
            onOk?.call();
          },
          variant: AppButtonVariant.text,
        ),
      ];
    }

    // Confirmation dialog with Cancel and Confirm buttons
    if (onConfirm != null && onCancel != null) {
      return [
        AppButton(
          text: cancelText,
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          variant: AppButtonVariant.text,
        ),
        AppSpacing.horizontalSpaceSM,
        AppButton(
          text: confirmText,
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          variant: isDestructive
              ? AppButtonVariant.filled
              : AppButtonVariant.filled,
          backgroundColor: isDestructive
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ];
    }

    return null;
  }

  /// Get appropriate icon color based on dialog type
  Color _getIconColor(ColorScheme colorScheme) {
    if (icon == Icons.error_outline) {
      return colorScheme.error;
    } else if (icon == Icons.warning_outlined) {
      return colorScheme.error;
    } else if (icon == Icons.info_outline) {
      return colorScheme.primary;
    }
    return colorScheme.onSurfaceVariant;
  }

  /// Show this dialog
  static Future<T?> show<T extends Object?>({
    required BuildContext context,
    required AppDialog dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => dialog,
    );
  }
}

/// Simple confirmation dialog helper
class AppConfirmDialog {
  /// Show a confirmation dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    IconData? icon,
    bool barrierDismissible = true,
  }) {
    return AppDialog.show<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      dialog: AppDialog.confirmation(
        title: title,
        content: message,
        icon: icon,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () {},
        onCancel: () {},
      ),
    );
  }

  /// Show a delete confirmation dialog
  static Future<bool?> showDelete({
    required BuildContext context,
    String title = 'Delete Item',
    String message = 'Are you sure you want to delete this item? This action cannot be undone.',
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: true,
      icon: Icons.delete_outline,
      barrierDismissible: barrierDismissible,
    );
  }
}

/// Simple info dialog helper
class AppInfoDialog {
  /// Show an information dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String okText = 'OK',
    IconData icon = Icons.info_outline,
    bool barrierDismissible = true,
  }) {
    return AppDialog.show<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      dialog: AppDialog.info(
        title: title,
        content: message,
        icon: icon,
        okText: okText,
        onOk: () {},
      ),
    );
  }

  /// Show a success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    String title = 'Success',
    required String message,
    String okText = 'OK',
    bool barrierDismissible = true,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      okText: okText,
      icon: Icons.check_circle_outline,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show an error dialog
  static Future<void> showError({
    required BuildContext context,
    String title = 'Error',
    required String message,
    String okText = 'OK',
    bool barrierDismissible = true,
  }) {
    return AppDialog.show<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      dialog: AppDialog.error(
        title: title,
        content: message,
        okText: okText,
        onOk: () {},
      ),
    );
  }
}

/// Loading dialog that shows a progress indicator
class AppLoadingDialog extends StatelessWidget {
  /// Creates a loading dialog
  const AppLoadingDialog({
    super.key,
    this.message = 'Loading...',
    this.showProgress = false,
    this.progress,
    this.barrierDismissible = false,
  });

  /// Loading message
  final String message;

  /// Whether to show determinate progress
  final bool showProgress;

  /// Progress value (0.0 to 1.0)
  final double? progress;

  /// Whether the dialog can be dismissed
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.dialogRadius,
      ),
      content: IntrinsicHeight(
        child: Column(
          children: [
            if (showProgress && progress != null)
              LinearProgressIndicator(value: progress)
            else
              const CircularProgressIndicator(),
            AppSpacing.verticalSpaceLG,
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Show loading dialog
  static Future<T> show<T>({
    required BuildContext context,
    required Future<T> future,
    String message = 'Loading...',
    bool showProgress = false,
    bool barrierDismissible = false,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppLoadingDialog(
        message: message,
        showProgress: showProgress,
        barrierDismissible: barrierDismissible,
      ),
    );

    try {
      final result = await future;
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      return result;
    } catch (error) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      rethrow;
    }
  }
}

/// Custom bottom sheet dialog
class AppBottomSheetDialog extends StatelessWidget {
  /// Creates a bottom sheet dialog
  const AppBottomSheetDialog({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showDragHandle = true,
    this.isScrollControlled = false,
    this.maxHeight,
    this.padding,
    this.semanticLabel,
  });

  /// Dialog title
  final String? title;

  /// Dialog content
  final Widget child;

  /// Action buttons
  final List<Widget>? actions;

  /// Whether to show drag handle
  final bool showDragHandle;

  /// Whether the sheet should be full screen
  final bool isScrollControlled;

  /// Maximum height of the sheet
  final double? maxHeight;

  /// Content padding
  final EdgeInsets? padding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final defaultMaxHeight = mediaQuery.size.height * 0.9;

    Widget content = Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? defaultMaxHeight,
      ),
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor ??
            theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingLarge),
              child: Text(
                title!,
                style: AppTypography.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          Flexible(
            child: Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingLarge,
                  ),
              child: child,
            ),
          ),
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .expand((action) => [action, AppSpacing.horizontalSpaceSM])
                    .take(actions!.length * 2 - 1)
                    .toList(),
              ),
            ),
        ],
      ),
    );

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      content = Semantics(
        label: semanticLabel,
        child: content,
      );
    }

    return content;
  }

  /// Show bottom sheet dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required AppBottomSheetDialog dialog,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => dialog,
      isScrollControlled: dialog.isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
    );
  }
}