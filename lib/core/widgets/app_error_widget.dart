import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

/// Error display widget with retry action and customizable styling
///
/// Provides consistent error handling UI with support for different error types,
/// retry functionality, and accessibility features.
class AppErrorWidget extends StatelessWidget {
  /// Creates an error widget with the specified configuration
  const AppErrorWidget({
    super.key,
    this.error,
    this.stackTrace,
    this.title,
    this.message,
    this.icon,
    this.onRetry,
    this.retryText = 'Retry',
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showDetails = false,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  });

  /// Creates a network error widget
  const AppErrorWidget.network({
    super.key,
    this.error,
    this.stackTrace,
    this.title = 'Network Error',
    this.message = 'Please check your internet connection and try again.',
    this.onRetry,
    this.retryText = 'Retry',
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showDetails = false,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  }) : icon = Icons.wifi_off_outlined;

  /// Creates a server error widget
  const AppErrorWidget.server({
    super.key,
    this.error,
    this.stackTrace,
    this.title = 'Server Error',
    this.message = 'Something went wrong on our end. Please try again later.',
    this.onRetry,
    this.retryText = 'Retry',
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showDetails = false,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  }) : icon = Icons.dns_outlined;

  /// Creates a not found error widget
  const AppErrorWidget.notFound({
    super.key,
    this.error,
    this.stackTrace,
    this.title = 'Not Found',
    this.message = 'The requested content could not be found.',
    this.onRetry,
    this.retryText = 'Go Back',
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showDetails = false,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  }) : icon = Icons.search_off_outlined;

  /// Creates a generic error widget
  const AppErrorWidget.generic({
    super.key,
    this.error,
    this.stackTrace,
    this.title = 'Something went wrong',
    this.message = 'An unexpected error occurred. Please try again.',
    this.onRetry,
    this.retryText = 'Retry',
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showDetails = false,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  }) : icon = Icons.error_outline;

  /// The error object (for development/debugging)
  final Object? error;

  /// Stack trace (for development/debugging)
  final StackTrace? stackTrace;

  /// Error title
  final String? title;

  /// Error message
  final String? message;

  /// Error icon
  final IconData? icon;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Retry button text
  final String retryText;

  /// Secondary action text
  final String? secondaryActionText;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  /// Whether to show error details (for debugging)
  final bool showDetails;

  /// Maximum width of the error content
  final double maxWidth;

  /// Padding around the content
  final EdgeInsets? padding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDebug = _isDebugMode();

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Error icon
        if (icon != null)
          Icon(
            icon,
            size: AppSpacing.iconXXL * 1.5, // 72dp
            color: colorScheme.error.withOpacity(0.8),
          ),

        AppSpacing.verticalSpaceXL,

        // Error title
        if (title != null)
          Text(
            title!,
            style: AppTypography.headlineSmall.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

        // Error message
        if (message != null) ...[
          if (title != null) AppSpacing.verticalSpaceMD,
          Text(
            message!,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Error details (debug mode only)
        if (isDebug && showDetails && error != null) ...[
          AppSpacing.verticalSpaceLG,
          _buildErrorDetails(context),
        ],

        // Action buttons
        if (onRetry != null || onSecondaryAction != null) ...[
          AppSpacing.verticalSpaceXXL,
          _buildActions(context),
        ],
      ],
    );

    // Apply maximum width constraint
    content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: content,
    );

    // Apply padding
    content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.screenPadding),
      child: content,
    );

    // Center the content
    content = Center(child: content);

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      content = Semantics(
        label: semanticLabel,
        child: content,
      );
    }

    return content;
  }

  /// Build action buttons
  Widget _buildActions(BuildContext context) {
    final List<Widget> actions = [];

    // Retry button
    if (onRetry != null) {
      actions.add(
        AppButton(
          text: retryText,
          onPressed: onRetry,
          variant: AppButtonVariant.filled,
          isFullWidth: secondaryActionText == null,
        ),
      );
    }

    // Secondary action
    if (secondaryActionText != null && onSecondaryAction != null) {
      if (actions.isNotEmpty) {
        actions.add(AppSpacing.verticalSpaceMD);
      }
      actions.add(
        AppButton(
          text: secondaryActionText!,
          onPressed: onSecondaryAction,
          variant: AppButtonVariant.outlined,
          isFullWidth: true,
        ),
      );
    }

    return Column(children: actions);
  }

  /// Build error details for debugging
  Widget _buildErrorDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: AppSpacing.radiusMD,
        border: Border.all(
          color: colorScheme.error.withOpacity(0.3),
          width: AppSpacing.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_outlined,
                size: AppSpacing.iconSM,
                color: colorScheme.error,
              ),
              AppSpacing.horizontalSpaceXS,
              Text(
                'Debug Information',
                style: AppTypography.labelMedium.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            error.toString(),
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onErrorContainer,
              fontFamily: 'monospace',
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          if (stackTrace != null) ...[
            AppSpacing.verticalSpaceXS,
            Text(
              'Stack trace available (check console)',
              style: AppTypography.bodySmall.copyWith(
                color: colorScheme.onErrorContainer.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Check if app is in debug mode
  bool _isDebugMode() {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

/// Compact error widget for smaller spaces
class AppCompactErrorWidget extends StatelessWidget {
  /// Creates a compact error widget
  const AppCompactErrorWidget({
    super.key,
    this.error,
    this.message = 'An error occurred',
    this.onRetry,
    this.retryText = 'Retry',
    this.padding,
    this.semanticLabel,
  });

  /// The error object
  final Object? error;

  /// Error message
  final String message;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Retry button text
  final String retryText;

  /// Padding around the content
  final EdgeInsets? padding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: AppSpacing.iconLG,
          color: colorScheme.error.withOpacity(0.8),
        ),
        AppSpacing.verticalSpaceMD,
        Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (onRetry != null) ...[
          AppSpacing.verticalSpaceMD,
          AppButton(
            text: retryText,
            onPressed: onRetry,
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
          ),
        ],
      ],
    );

    // Apply padding
    content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: content,
    );

    // Center the content
    content = Center(child: content);

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      content = Semantics(
        label: semanticLabel,
        child: content,
      );
    }

    return content;
  }
}

/// Inline error widget for form fields and small spaces
class AppInlineErrorWidget extends StatelessWidget {
  /// Creates an inline error widget
  const AppInlineErrorWidget({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryText = 'Retry',
    this.color,
    this.backgroundColor,
    this.padding,
    this.semanticLabel,
  });

  /// Error message
  final String message;

  /// Error icon
  final IconData icon;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Retry button text
  final String retryText;

  /// Error color override
  final Color? color;

  /// Background color override
  final Color? backgroundColor;

  /// Padding around the content
  final EdgeInsets? padding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorColor = color ?? colorScheme.error;

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? errorColor.withOpacity(0.1),
        borderRadius: AppSpacing.radiusSM,
        border: Border.all(
          color: errorColor.withOpacity(0.3),
          width: AppSpacing.borderWidth,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSM,
            color: errorColor,
          ),
          AppSpacing.horizontalSpaceXS,
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: errorColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRetry != null) ...[
            AppSpacing.horizontalSpaceSM,
            AppButton(
              text: retryText,
              onPressed: onRetry,
              variant: AppButtonVariant.text,
              size: AppButtonSize.small,
            ),
          ],
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
}

/// Error boundary widget that catches errors in child widgets
class AppErrorBoundary extends StatefulWidget {
  /// Creates an error boundary that catches errors in child widgets
  const AppErrorBoundary({
    super.key,
    required this.child,
    this.onError,
    this.errorWidgetBuilder,
    this.fallbackWidget,
  });

  /// The child widget to wrap with error handling
  final Widget child;

  /// Callback when an error occurs
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Custom error widget builder
  final Widget Function(Object error, StackTrace stackTrace)? errorWidgetBuilder;

  /// Fallback widget to show when error occurs (used if errorWidgetBuilder is null)
  final Widget? fallbackWidget;

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          _error = details.exception;
          _stackTrace = details.stack;
        });
      }
      widget.onError?.call(details.exception, details.stack ?? StackTrace.current);

      return widget.errorWidgetBuilder?.call(
        details.exception,
        details.stack ?? StackTrace.current,
      ) ?? widget.fallbackWidget ?? const AppErrorWidget.generic();
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorWidgetBuilder?.call(_error!, _stackTrace!) ??
          widget.fallbackWidget ??
          AppErrorWidget.generic(
            error: _error,
            stackTrace: _stackTrace,
            onRetry: _handleRetry,
          );
    }

    return widget.child;
  }

  void _handleRetry() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }
}