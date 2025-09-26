import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// Reusable card component with Material 3 styling and customization options
///
/// Provides a consistent card design with support for different variants,
/// elevation levels, and content layouts.
class AppCard extends StatelessWidget {
  /// Creates a card with the specified content and styling options
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.clipBehavior = Clip.none,
    this.onTap,
    this.semanticLabel,
  }) : title = null,
       subtitle = null,
       leading = null,
       trailing = null,
       actions = null,
       mediaWidget = null;

  /// Creates a card with a title, subtitle, and optional actions
  const AppCard.titled({
    super.key,
    required this.title,
    this.subtitle,
    this.child,
    this.leading,
    this.trailing,
    this.actions,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.clipBehavior = Clip.none,
    this.onTap,
    this.semanticLabel,
  }) : mediaWidget = null;

  /// Creates a card optimized for displaying media content
  const AppCard.media({
    super.key,
    required this.mediaWidget,
    this.title,
    this.subtitle,
    this.child,
    this.actions,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
    this.semanticLabel,
  }) : leading = null,
       trailing = null;

  /// The content to display inside the card
  final Widget? child;

  /// Title for titled cards
  final String? title;

  /// Subtitle for titled cards
  final String? subtitle;

  /// Leading widget for titled cards (typically an icon or avatar)
  final Widget? leading;

  /// Trailing widget for titled cards (typically an icon or button)
  final Widget? trailing;

  /// Action buttons displayed at the bottom of the card
  final List<Widget>? actions;

  /// Media widget for media cards (typically an image or video)
  final Widget? mediaWidget;

  /// The visual variant of the card
  final AppCardVariant variant;

  /// Internal padding of the card content
  final EdgeInsets? padding;

  /// External margin around the card
  final EdgeInsets? margin;

  /// Background color override
  final Color? backgroundColor;

  /// Shadow color override
  final Color? shadowColor;

  /// Surface tint color for Material 3
  final Color? surfaceTintColor;

  /// Elevation level override
  final double? elevation;

  /// Shape override
  final ShapeBorder? shape;

  /// Clipping behavior for card content
  final Clip clipBehavior;

  /// Called when the card is tapped
  final VoidCallback? onTap;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;

    // Determine card content based on constructor used
    Widget content;
    if (title != null) {
      content = _buildTitledContent(context);
    } else if (mediaWidget != null) {
      content = _buildMediaContent(context);
    } else if (child != null) {
      content = child!;
    } else {
      content = const SizedBox.shrink();
    }

    // Apply padding if specified
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    } else if (title != null || mediaWidget != null) {
      // Apply default padding for titled/media cards
      content = Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: content,
      );
    }

    // Create the card widget
    Widget card = Card(
      elevation: _getElevation(theme),
      color: backgroundColor ?? cardTheme.color,
      shadowColor: shadowColor ?? cardTheme.shadowColor,
      surfaceTintColor: surfaceTintColor ?? cardTheme.surfaceTintColor,
      shape: shape ?? cardTheme.shape ??
        RoundedRectangleBorder(borderRadius: AppSpacing.cardRadius),
      clipBehavior: clipBehavior,
      margin: margin ?? cardTheme.margin ?? const EdgeInsets.all(AppSpacing.cardMargin),
      child: content,
    );

    // Make card tappable if onTap is provided
    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: shape is RoundedRectangleBorder
          ? (shape as RoundedRectangleBorder).borderRadius as BorderRadius?
          : AppSpacing.cardRadius,
        child: card,
      );
    }

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      card = Semantics(
        label: semanticLabel,
        child: card,
      );
    }

    return card;
  }

  /// Build content for titled cards
  Widget _buildTitledContent(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final List<Widget> children = [];

    // Add header with title, subtitle, leading, and trailing
    if (title != null || leading != null || trailing != null) {
      children.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              leading!,
              AppSpacing.horizontalSpaceMD,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (subtitle != null) ...[
                    AppSpacing.verticalSpaceXS,
                    Text(
                      subtitle!,
                      style: subtitleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              AppSpacing.horizontalSpaceXS,
              trailing!,
            ],
          ],
        ),
      );
    }

    // Add main content
    if (child != null) {
      if (children.isNotEmpty) {
        children.add(AppSpacing.verticalSpaceLG);
      }
      children.add(child!);
    }

    // Add actions
    if (actions != null && actions!.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(AppSpacing.verticalSpaceLG);
      }
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions!
              .expand((action) => [action, AppSpacing.horizontalSpaceSM])
              .take(actions!.length * 2 - 1)
              .toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  /// Build content for media cards
  Widget _buildMediaContent(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final List<Widget> children = [];

    // Add media widget
    if (mediaWidget != null) {
      children.add(mediaWidget!);
    }

    // Add title and subtitle
    if (title != null || subtitle != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (subtitle != null) ...[
                AppSpacing.verticalSpaceXS,
                Text(
                  subtitle!,
                  style: subtitleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Add main content
    if (child != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
          ).copyWith(
            bottom: AppSpacing.cardPadding,
          ),
          child: child!,
        ),
      );
    }

    // Add actions
    if (actions != null && actions!.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
          ).copyWith(
            bottom: AppSpacing.cardPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!
                .expand((action) => [action, AppSpacing.horizontalSpaceSM])
                .take(actions!.length * 2 - 1)
                .toList(),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  /// Get elevation based on variant and theme
  double _getElevation(ThemeData theme) {
    if (elevation != null) {
      return elevation!;
    }

    return switch (variant) {
      AppCardVariant.elevated => theme.cardTheme.elevation ?? AppSpacing.elevationLow,
      AppCardVariant.filled => AppSpacing.elevationNone,
      AppCardVariant.outlined => AppSpacing.elevationNone,
    };
  }
}

/// Available card variants
enum AppCardVariant {
  /// Elevated card with shadow (default)
  elevated,

  /// Filled card with background color and no shadow
  filled,

  /// Outlined card with border and no shadow
  outlined,
}

/// Compact card for list items
class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.margin,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.filled,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            AppSpacing.horizontalSpaceMD,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  AppSpacing.verticalSpaceXS,
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            AppSpacing.horizontalSpaceSM,
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Action card for interactive content
class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.margin,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      variant: AppCardVariant.filled,
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      margin: margin,
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppSpacing.iconXL,
              color: foregroundColor ?? theme.colorScheme.primary,
            ),
            AppSpacing.verticalSpaceMD,
          ],
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: foregroundColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            AppSpacing.verticalSpaceXS,
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foregroundColor ?? theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}