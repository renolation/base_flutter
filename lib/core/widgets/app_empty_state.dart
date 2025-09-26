import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

/// Empty state widget with icon, message, and optional action button
///
/// Provides a consistent empty state design with customizable content
/// and actions for when no data is available.
class AppEmptyState extends StatelessWidget {
  /// Creates an empty state widget with the specified content
  const AppEmptyState({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.illustration,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  });

  /// Creates a "no data" empty state
  const AppEmptyState.noData({
    super.key,
    this.title = 'No data available',
    this.message = 'There is no data to display at the moment.',
    this.actionText,
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  })  : icon = Icons.inbox_outlined,
        illustration = null;

  /// Creates a "no search results" empty state
  const AppEmptyState.noSearchResults({
    super.key,
    this.title = 'No results found',
    this.message = 'Try adjusting your search criteria or filters.',
    this.actionText = 'Clear filters',
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  })  : icon = Icons.search_off_outlined,
        illustration = null;

  /// Creates a "no network" empty state
  const AppEmptyState.noNetwork({
    super.key,
    this.title = 'No internet connection',
    this.message = 'Please check your network connection and try again.',
    this.actionText = 'Retry',
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  })  : icon = Icons.wifi_off_outlined,
        illustration = null;

  /// Creates an "error" empty state
  const AppEmptyState.error({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'An error occurred while loading the data.',
    this.actionText = 'Try again',
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  })  : icon = Icons.error_outline,
        illustration = null;

  /// Creates a "coming soon" empty state
  const AppEmptyState.comingSoon({
    super.key,
    this.title = 'Coming soon',
    this.message = 'This feature is currently under development.',
    this.actionText,
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  })  : icon = Icons.construction_outlined,
        illustration = null;

  /// Creates an "access denied" empty state
  const AppEmptyState.accessDenied({
    super.key,
    this.title = 'Access denied',
    this.message = 'You do not have permission to view this content.',
    this.actionText = 'Request access',
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.maxWidth = 320,
    this.padding,
    this.semanticLabel,
  })  : icon = Icons.lock_outline,
        illustration = null;

  /// Icon to display (ignored if illustration is provided)
  final IconData? icon;

  /// Custom illustration widget
  final Widget? illustration;

  /// Main title text
  final String? title;

  /// Descriptive message text
  final String? message;

  /// Primary action button text
  final String? actionText;

  /// Callback for primary action
  final VoidCallback? onActionPressed;

  /// Secondary action button text
  final String? secondaryActionText;

  /// Callback for secondary action
  final VoidCallback? onSecondaryActionPressed;

  /// Maximum width of the empty state content
  final double maxWidth;

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
        // Icon or illustration
        if (illustration != null)
          illustration!
        else if (icon != null)
          Icon(
            icon,
            size: AppSpacing.iconXXL * 2, // 96dp
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),

        AppSpacing.verticalSpaceXXL,

        // Title
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

        // Message
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

        // Actions
        if (actionText != null || secondaryActionText != null) ...[
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

    // Primary action
    if (actionText != null && onActionPressed != null) {
      actions.add(
        AppButton(
          text: actionText!,
          onPressed: onActionPressed,
          variant: AppButtonVariant.filled,
          isFullWidth: secondaryActionText == null, // Full width if only one button
        ),
      );
    }

    // Secondary action
    if (secondaryActionText != null && onSecondaryActionPressed != null) {
      if (actions.isNotEmpty) {
        actions.add(AppSpacing.verticalSpaceMD);
      }
      actions.add(
        AppButton(
          text: secondaryActionText!,
          onPressed: onSecondaryActionPressed,
          variant: AppButtonVariant.outlined,
          isFullWidth: true,
        ),
      );
    }

    // If both actions exist and we want them side by side
    if (actions.length >= 3) {
      return Column(children: actions);
    }

    // Single action or side-by-side layout
    if (actions.length == 1) {
      return actions.first;
    }

    return Column(children: actions);
  }
}

/// Compact empty state for smaller spaces (like lists)
class AppCompactEmptyState extends StatelessWidget {
  /// Creates a compact empty state widget
  const AppCompactEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.padding,
    this.semanticLabel,
  });

  /// Icon to display
  final IconData icon;

  /// Message text
  final String message;

  /// Action button text
  final String? actionText;

  /// Callback for action
  final VoidCallback? onActionPressed;

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
          icon,
          size: AppSpacing.iconLG,
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
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
        if (actionText != null && onActionPressed != null) ...[
          AppSpacing.verticalSpaceMD,
          AppButton(
            text: actionText!,
            onPressed: onActionPressed,
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

/// Empty state for specific list/grid scenarios
class AppListEmptyState extends StatelessWidget {
  /// Creates an empty state for lists
  const AppListEmptyState({
    super.key,
    this.type = AppListEmptyType.noItems,
    this.title,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.searchQuery,
    this.padding,
    this.semanticLabel,
  });

  /// Type of empty state
  final AppListEmptyType type;

  /// Custom title (overrides default)
  final String? title;

  /// Custom message (overrides default)
  final String? message;

  /// Action button text
  final String? actionText;

  /// Callback for action
  final VoidCallback? onActionPressed;

  /// Search query for search results empty state
  final String? searchQuery;

  /// Padding around the content
  final EdgeInsets? padding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyStateConfig();

    return AppEmptyState(
      icon: config.icon,
      title: title ?? config.title,
      message: message ?? _getMessageWithQuery(config.message),
      actionText: actionText ?? config.actionText,
      onActionPressed: onActionPressed,
      padding: padding,
      semanticLabel: semanticLabel,
    );
  }

  /// Get configuration based on type
  _EmptyStateConfig _getEmptyStateConfig() {
    return switch (type) {
      AppListEmptyType.noItems => _EmptyStateConfig(
          icon: Icons.inbox_outlined,
          title: 'No items',
          message: 'There are no items to display.',
          actionText: 'Add item',
        ),
      AppListEmptyType.noFavorites => _EmptyStateConfig(
          icon: Icons.favorite_border_outlined,
          title: 'No favorites',
          message: 'Items you mark as favorite will appear here.',
          actionText: 'Browse items',
        ),
      AppListEmptyType.noSearchResults => _EmptyStateConfig(
          icon: Icons.search_off_outlined,
          title: 'No results found',
          message: 'No results found for your search.',
          actionText: 'Clear search',
        ),
      AppListEmptyType.noNotifications => _EmptyStateConfig(
          icon: Icons.notifications_none_outlined,
          title: 'No notifications',
          message: 'You have no new notifications.',
          actionText: null,
        ),
      AppListEmptyType.noMessages => _EmptyStateConfig(
          icon: Icons.message_outlined,
          title: 'No messages',
          message: 'You have no messages yet.',
          actionText: 'Start conversation',
        ),
      AppListEmptyType.noHistory => _EmptyStateConfig(
          icon: Icons.history,
          title: 'No history',
          message: 'Your activity history will appear here.',
          actionText: null,
        ),
    };
  }

  /// Get message with search query if applicable
  String _getMessageWithQuery(String defaultMessage) {
    if (type == AppListEmptyType.noSearchResults && searchQuery != null) {
      return 'No results found for "$searchQuery". Try different keywords.';
    }
    return defaultMessage;
  }
}

/// Configuration for empty state
class _EmptyStateConfig {
  const _EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
}

/// Types of list empty states
enum AppListEmptyType {
  /// Generic no items state
  noItems,

  /// No favorite items
  noFavorites,

  /// No search results
  noSearchResults,

  /// No notifications
  noNotifications,

  /// No messages
  noMessages,

  /// No history
  noHistory,
}