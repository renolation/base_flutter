import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Various loading states including circular, linear, and skeleton loaders
///
/// Provides consistent loading indicators with customizable styling
/// and accessibility features.
class AppLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator with the specified type and styling
  const AppLoadingIndicator({
    super.key,
    this.type = AppLoadingType.circular,
    this.size = AppLoadingSize.medium,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.value,
    this.message,
    this.semanticLabel,
  });

  /// The type of loading indicator to display
  final AppLoadingType type;

  /// The size of the loading indicator
  final AppLoadingSize size;

  /// Color override for the indicator
  final Color? color;

  /// Background color override (for linear progress)
  final Color? backgroundColor;

  /// Stroke width override (for circular progress)
  final double? strokeWidth;

  /// Progress value (0.0 to 1.0) for determinate progress indicators
  final double? value;

  /// Optional message to display below the indicator
  final String? message;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget indicator = switch (type) {
      AppLoadingType.circular => _buildCircularIndicator(colorScheme),
      AppLoadingType.linear => _buildLinearIndicator(colorScheme),
      AppLoadingType.adaptive => _buildAdaptiveIndicator(context, colorScheme),
      AppLoadingType.refresh => _buildRefreshIndicator(colorScheme),
    };

    // Add message if provided
    if (message != null) {
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          AppSpacing.verticalSpaceMD,
          Text(
            message!,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      indicator = Semantics(
        label: semanticLabel,
        child: indicator,
      );
    }

    return indicator;
  }

  /// Build circular progress indicator
  Widget _buildCircularIndicator(ColorScheme colorScheme) {
    final indicatorSize = _getIndicatorSize();

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        value: value,
        color: color ?? colorScheme.primary,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
      ),
    );
  }

  /// Build linear progress indicator
  Widget _buildLinearIndicator(ColorScheme colorScheme) {
    return LinearProgressIndicator(
      value: value,
      color: color ?? colorScheme.primary,
      backgroundColor: backgroundColor ?? colorScheme.surfaceContainerHighest,
      minHeight: _getLinearHeight(),
    );
  }

  /// Build adaptive progress indicator (Material on Android, Cupertino on iOS)
  Widget _buildAdaptiveIndicator(BuildContext context, ColorScheme colorScheme) {
    final indicatorSize = _getIndicatorSize();

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator.adaptive(
        value: value,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
      ),
    );
  }

  /// Build refresh indicator style circular indicator
  Widget _buildRefreshIndicator(ColorScheme colorScheme) {
    final indicatorSize = _getIndicatorSize();

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: RefreshProgressIndicator(
        value: value,
        color: color ?? colorScheme.primary,
        backgroundColor: backgroundColor ?? colorScheme.surface,
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
      ),
    );
  }

  /// Get indicator size based on size enum
  double _getIndicatorSize() {
    return switch (size) {
      AppLoadingSize.small => AppSpacing.iconMD,
      AppLoadingSize.medium => AppSpacing.iconLG,
      AppLoadingSize.large => AppSpacing.iconXL,
      AppLoadingSize.extraLarge => AppSpacing.iconXXL,
    };
  }

  /// Get stroke width based on size
  double _getStrokeWidth() {
    return switch (size) {
      AppLoadingSize.small => 2.0,
      AppLoadingSize.medium => 3.0,
      AppLoadingSize.large => 4.0,
      AppLoadingSize.extraLarge => 5.0,
    };
  }

  /// Get linear indicator height based on size
  double _getLinearHeight() {
    return switch (size) {
      AppLoadingSize.small => 2.0,
      AppLoadingSize.medium => 4.0,
      AppLoadingSize.large => 6.0,
      AppLoadingSize.extraLarge => 8.0,
    };
  }
}

/// Available loading indicator types
enum AppLoadingType {
  /// Circular progress indicator
  circular,

  /// Linear progress indicator
  linear,

  /// Adaptive indicator (platform-specific)
  adaptive,

  /// Refresh indicator style
  refresh,
}

/// Available loading indicator sizes
enum AppLoadingSize {
  /// Small indicator (24dp)
  small,

  /// Medium indicator (32dp) - default
  medium,

  /// Large indicator (40dp)
  large,

  /// Extra large indicator (48dp)
  extraLarge,
}

/// Skeleton loader for content placeholders
class AppSkeletonLoader extends StatefulWidget {
  /// Creates a skeleton loader with the specified dimensions and styling
  const AppSkeletonLoader({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  /// Creates a rectangular skeleton loader
  const AppSkeletonLoader.rectangle({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  /// Creates a circular skeleton loader (avatar placeholder)
  AppSkeletonLoader.circle({
    super.key,
    required double diameter,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  })  : width = diameter,
        height = diameter,
        borderRadius = BorderRadius.circular(diameter / 2.0);

  /// Creates a text line skeleton loader
  const AppSkeletonLoader.text({
    super.key,
    this.width,
    this.height = 16.0,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : borderRadius = const BorderRadius.all(Radius.circular(8.0));

  /// Width of the skeleton loader
  final double? width;

  /// Height of the skeleton loader
  final double height;

  /// Border radius for rounded corners
  final BorderRadius? borderRadius;

  /// Base color for the skeleton
  final Color? baseColor;

  /// Highlight color for the animation
  final Color? highlightColor;

  /// Duration of the shimmer animation
  final Duration animationDuration;

  @override
  State<AppSkeletonLoader> createState() => _AppSkeletonLoaderState();
}

class _AppSkeletonLoaderState extends State<AppSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseColor = widget.baseColor ??
        (theme.brightness == Brightness.light
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerLowest);

    final highlightColor = widget.highlightColor ??
        (theme.brightness == Brightness.light
            ? colorScheme.surface
            : colorScheme.surfaceContainerHigh);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? AppSpacing.radiusSM,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value),
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton loader for list items
class AppListItemSkeleton extends StatelessWidget {
  /// Creates a skeleton loader for list items with avatar and text
  const AppListItemSkeleton({
    super.key,
    this.hasAvatar = true,
    this.hasSubtitle = true,
    this.hasTrailing = false,
    this.padding,
  });

  /// Whether to show avatar placeholder
  final bool hasAvatar;

  /// Whether to show subtitle placeholder
  final bool hasSubtitle;

  /// Whether to show trailing element placeholder
  final bool hasTrailing;

  /// Padding around the skeleton
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          if (hasAvatar) ...[
            AppSkeletonLoader.circle(diameter: 40.0),
            AppSpacing.horizontalSpaceMD,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSkeletonLoader.text(width: double.infinity),
                if (hasSubtitle) ...[
                  AppSpacing.verticalSpaceXS,
                  const AppSkeletonLoader.text(width: 200),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            AppSpacing.horizontalSpaceMD,
            const AppSkeletonLoader.rectangle(width: 60, height: 32),
          ],
        ],
      ),
    );
  }
}

/// Skeleton loader for card content
class AppCardSkeleton extends StatelessWidget {
  /// Creates a skeleton loader for card content
  const AppCardSkeleton({
    super.key,
    this.hasImage = false,
    this.hasTitle = true,
    this.hasSubtitle = true,
    this.hasContent = true,
    this.hasActions = false,
    this.padding,
  });

  /// Whether to show image placeholder
  final bool hasImage;

  /// Whether to show title placeholder
  final bool hasTitle;

  /// Whether to show subtitle placeholder
  final bool hasSubtitle;

  /// Whether to show content placeholder
  final bool hasContent;

  /// Whether to show action buttons placeholder
  final bool hasActions;

  /// Padding around the skeleton
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage) ...[
            const AppSkeletonLoader.rectangle(
              width: double.infinity,
              height: 200,
            ),
            AppSpacing.verticalSpaceMD,
          ],
          if (hasTitle) ...[
            const AppSkeletonLoader.text(width: 250),
            AppSpacing.verticalSpaceXS,
          ],
          if (hasSubtitle) ...[
            const AppSkeletonLoader.text(width: 180),
            AppSpacing.verticalSpaceMD,
          ],
          if (hasContent) ...[
            const AppSkeletonLoader.text(width: double.infinity),
            AppSpacing.verticalSpaceXS,
            const AppSkeletonLoader.text(width: double.infinity),
            AppSpacing.verticalSpaceXS,
            const AppSkeletonLoader.text(width: 300),
          ],
          if (hasActions) ...[
            AppSpacing.verticalSpaceMD,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const AppSkeletonLoader.rectangle(width: 80, height: 36),
                AppSpacing.horizontalSpaceSM,
                const AppSkeletonLoader.rectangle(width: 80, height: 36),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading overlay that can be displayed over content
class AppLoadingOverlay extends StatelessWidget {
  /// Creates a loading overlay with the specified content and styling
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.backgroundColor,
    this.message,
    this.dismissible = false,
  });

  /// Whether the loading overlay should be displayed
  final bool isLoading;

  /// The content to display behind the overlay
  final Widget child;

  /// Custom loading widget (defaults to circular indicator)
  final Widget? loadingWidget;

  /// Background color of the overlay
  final Color? backgroundColor;

  /// Optional message to display with the loading indicator
  final String? message;

  /// Whether the overlay can be dismissed by tapping
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: backgroundColor ??
                  theme.colorScheme.surface.withOpacity(0.8),
              child: Center(
                child: loadingWidget ??
                    AppLoadingIndicator(
                      message: message,
                      semanticLabel: 'Loading content',
                    ),
              ),
            ),
          ),
      ],
    );
  }
}