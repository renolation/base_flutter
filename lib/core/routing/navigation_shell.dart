import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_paths.dart';
import 'route_guards.dart';

/// Navigation shell with bottom navigation or navigation drawer
class NavigationShell extends ConsumerStatefulWidget {
  final Widget child;
  final GoRouterState state;

  const NavigationShell({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  ConsumerState<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends ConsumerState<NavigationShell> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final currentPath = widget.state.fullPath ?? '/';

    // Determine if we should show bottom navigation
    final showBottomNav = _shouldShowBottomNavigation(currentPath, authState);

    if (!showBottomNav) {
      return widget.child;
    }

    // Get current navigation index
    final currentIndex = _getCurrentNavigationIndex(currentPath);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onNavigationTapped(context, index),
        destinations: _getNavigationDestinations(authState),
      ),
    );
  }

  /// Determine if bottom navigation should be shown
  bool _shouldShowBottomNavigation(String path, AuthState authState) {
    // Don't show on auth pages
    if (RoutePaths.isAuthPath(path)) {
      return false;
    }

    // Don't show on onboarding
    if (path.startsWith(RoutePaths.onboarding) || path.startsWith(RoutePaths.welcome)) {
      return false;
    }

    // Don't show on error pages
    if (path.startsWith(RoutePaths.error) || path.startsWith(RoutePaths.notFound)) {
      return false;
    }

    // Don't show on specific detail pages
    final hideOnPaths = [
      '/todos/add',
      '/todos/',
      '/settings/',
    ];

    for (final hidePath in hideOnPaths) {
      if (path.contains(hidePath) && path != RoutePaths.todos && path != RoutePaths.settings) {
        return false;
      }
    }

    return true;
  }

  /// Get current navigation index based on path
  int _getCurrentNavigationIndex(String path) {
    if (path.startsWith(RoutePaths.todos)) {
      return 1;
    } else if (path.startsWith(RoutePaths.settings)) {
      return 2;
    } else if (path.startsWith(RoutePaths.profile)) {
      return 3;
    }
    return 0; // Home
  }

  /// Get navigation destinations based on auth state
  List<NavigationDestination> _getNavigationDestinations(AuthState authState) {
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.check_circle_outline),
        selectedIcon: Icon(Icons.check_circle),
        label: 'Todos',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
      if (authState == AuthState.authenticated)
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
    ];
  }

  /// Handle navigation tap
  void _onNavigationTapped(BuildContext context, int index) {
    final authState = ref.read(authStateProvider);

    switch (index) {
      case 0:
        if (GoRouterState.of(context).fullPath != RoutePaths.home) {
          context.go(RoutePaths.home);
        }
        break;
      case 1:
        if (!GoRouterState.of(context).fullPath!.startsWith(RoutePaths.todos)) {
          context.go(RoutePaths.todos);
        }
        break;
      case 2:
        if (!GoRouterState.of(context).fullPath!.startsWith(RoutePaths.settings)) {
          context.go(RoutePaths.settings);
        }
        break;
      case 3:
        if (authState == AuthState.authenticated) {
          if (GoRouterState.of(context).fullPath != RoutePaths.profile) {
            context.go(RoutePaths.profile);
          }
        }
        break;
    }
  }
}

/// Adaptive navigation shell that changes based on screen size
class AdaptiveNavigationShell extends ConsumerWidget {
  final Widget child;
  final GoRouterState state;

  const AdaptiveNavigationShell({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use rail navigation on tablets and desktop
    if (screenWidth >= 840) {
      return _NavigationRailShell(
        child: child,
        state: state,
      );
    }

    // Use bottom navigation on mobile
    return NavigationShell(
      child: child,
      state: state,
    );
  }
}

/// Navigation rail for larger screens
class _NavigationRailShell extends ConsumerStatefulWidget {
  final Widget child;
  final GoRouterState state;

  const _NavigationRailShell({
    required this.child,
    required this.state,
  });

  @override
  ConsumerState<_NavigationRailShell> createState() => _NavigationRailShellState();
}

class _NavigationRailShellState extends ConsumerState<_NavigationRailShell> {
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final currentPath = widget.state.fullPath ?? '/';

    // Determine if we should show navigation rail
    final showNavRail = _shouldShowNavigationRail(currentPath, authState);

    if (!showNavRail) {
      return widget.child;
    }

    // Get current navigation index
    final currentIndex = _getCurrentNavigationIndex(currentPath);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isExtended,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => _onNavigationTapped(context, index),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  isExtended = !isExtended;
                });
              },
            ),
            destinations: _getNavigationDestinations(authState),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  bool _shouldShowNavigationRail(String path, AuthState authState) {
    // Same logic as bottom navigation
    if (RoutePaths.isAuthPath(path)) return false;
    if (path.startsWith(RoutePaths.onboarding) || path.startsWith(RoutePaths.welcome)) return false;
    if (path.startsWith(RoutePaths.error) || path.startsWith(RoutePaths.notFound)) return false;

    return true;
  }

  int _getCurrentNavigationIndex(String path) {
    if (path.startsWith(RoutePaths.todos)) {
      return 1;
    } else if (path.startsWith(RoutePaths.settings)) {
      return 2;
    } else if (path.startsWith(RoutePaths.profile)) {
      return 3;
    }
    return 0; // Home
  }

  List<NavigationRailDestination> _getNavigationDestinations(AuthState authState) {
    return [
      const NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Home'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.check_circle_outline),
        selectedIcon: Icon(Icons.check_circle),
        label: Text('Todos'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
      if (authState == AuthState.authenticated)
        const NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
    ];
  }

  void _onNavigationTapped(BuildContext context, int index) {
    final authState = ref.read(authStateProvider);

    switch (index) {
      case 0:
        if (GoRouterState.of(context).fullPath != RoutePaths.home) {
          context.go(RoutePaths.home);
        }
        break;
      case 1:
        if (!GoRouterState.of(context).fullPath!.startsWith(RoutePaths.todos)) {
          context.go(RoutePaths.todos);
        }
        break;
      case 2:
        if (!GoRouterState.of(context).fullPath!.startsWith(RoutePaths.settings)) {
          context.go(RoutePaths.settings);
        }
        break;
      case 3:
        if (authState == AuthState.authenticated) {
          if (GoRouterState.of(context).fullPath != RoutePaths.profile) {
            context.go(RoutePaths.profile);
          }
        }
        break;
    }
  }
}