import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';
import 'route_paths.dart';
import 'route_guards.dart';
import 'error_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/todos/presentation/screens/home_screen.dart';

/// GoRouter provider for the entire app
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RoutePaths.home,
    redirect: (context, state) {
      return RouteGuard.getRedirectPath(state.fullPath ?? '', authState);
    },
    routes: [
      // Home route
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const HomePage(),
          state: state,
        ),
      ),

      // Settings routes with nested navigation
      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const SettingsPage(),
          state: state,
        ),
        routes: [
          // Settings sub-pages
          GoRoute(
            path: '/theme',
            name: RouteNames.settingsTheme,
            pageBuilder: (context, state) => _buildPageWithTransition(
              child: const ThemeSettingsPage(),
              state: state,
            ),
          ),
          GoRoute(
            path: '/general',
            name: RouteNames.settingsGeneral,
            pageBuilder: (context, state) => _buildPageWithTransition(
              child: const _PlaceholderPage(title: 'General Settings'),
              state: state,
            ),
          ),
          GoRoute(
            path: '/privacy',
            name: RouteNames.settingsPrivacy,
            pageBuilder: (context, state) => _buildPageWithTransition(
              child: const _PlaceholderPage(title: 'Privacy Settings'),
              state: state,
            ),
          ),
          GoRoute(
            path: '/notifications',
            name: RouteNames.settingsNotifications,
            pageBuilder: (context, state) => _buildPageWithTransition(
              child: const _PlaceholderPage(title: 'Notification Settings'),
              state: state,
            ),
          ),
        ],
      ),

      // Profile route
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const _PlaceholderPage(title: 'Profile'),
          state: state,
        ),
      ),

      // About route
      GoRoute(
        path: RoutePaths.about,
        name: RouteNames.about,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const _AboutPage(),
          state: state,
        ),
      ),

      // Auth routes
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const _PlaceholderPage(title: 'Login'),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const _PlaceholderPage(title: 'Register'),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const _PlaceholderPage(title: 'Forgot Password'),
          state: state,
        ),
      ),

      // Todo routes (keeping existing functionality)
      GoRoute(
        path: RoutePaths.todos,
        name: RouteNames.todos,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const HomeScreen(), // Using existing TodoScreen
          state: state,
        ),
        routes: [
          GoRoute(
            path: '/add',
            name: RouteNames.addTodo,
            pageBuilder: (context, state) => _buildPageWithTransition(
              child: const _PlaceholderPage(title: 'Add Todo'),
              state: state,
            ),
          ),
          GoRoute(
            path: '/:id',
            name: RouteNames.todoDetails,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return _buildPageWithTransition(
                child: _PlaceholderPage(title: 'Todo Details: $id'),
                state: state,
              );
            },
            routes: [
              GoRoute(
                path: '/edit',
                name: RouteNames.editTodo,
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _buildPageWithTransition(
                    child: _PlaceholderPage(title: 'Edit Todo: $id'),
                    state: state,
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // Onboarding routes
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const _PlaceholderPage(title: 'Onboarding'),
          state: state,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(
        error: state.error.toString(),
        path: state.fullPath,
      ),
    ),
  );
});

/// Helper function to build pages with transitions
Page<T> _buildPageWithTransition<T>({
  required Widget child,
  required GoRouterState state,
  Duration transitionDuration = const Duration(milliseconds: 250),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: transitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide transition from right to left
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// Extension methods for GoRouter navigation
extension GoRouterExtension on GoRouter {
  /// Navigate to a named route with parameters
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Check if we can pop the current route
  bool get canPop => routerDelegate.currentConfiguration.matches.length > 1;
}

/// Extension methods for BuildContext navigation
extension BuildContextGoRouterExtension on BuildContext {
  /// Get the GoRouter instance
  GoRouter get router => GoRouter.of(this);

  /// Navigate with typed route names
  void goToHome() => go(RoutePaths.home);
  void goToSettings() => go(RoutePaths.settings);
  void goToLogin() => go(RoutePaths.login);
  void goToProfile() => go(RoutePaths.profile);

  /// Navigate to todo details with ID
  void goToTodoDetails(String id) => go(RoutePaths.todoDetailsPath(id));

  /// Navigate to edit todo with ID
  void goToEditTodo(String id) => go(RoutePaths.editTodoPath(id));

  /// Push with typed route names
  void pushHome() => push(RoutePaths.home);
  void pushSettings() => push(RoutePaths.settings);
  void pushLogin() => push(RoutePaths.login);
  void pushProfile() => push(RoutePaths.profile);

  /// Get current route information
  String get currentPath => GoRouterState.of(this).fullPath ?? '/';
  String get currentName => GoRouterState.of(this).name ?? '';
  Map<String, String> get pathParameters => GoRouterState.of(this).pathParameters;
  Map<String, dynamic> get queryParameters => GoRouterState.of(this).uri.queryParameters;
}

/// About page implementation
class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.flutter_dash,
                    size: 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Base Flutter App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Version 1.0.0+1',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About This App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'A foundational Flutter application with clean architecture, '
                      'state management using Riverpod, local storage with Hive, '
                      'and navigation using GoRouter.',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('• Clean Architecture with feature-first structure'),
                    Text('• State management with Riverpod'),
                    Text('• Local storage with Hive'),
                    Text('• Navigation with GoRouter'),
                    Text('• Material 3 design system'),
                    Text('• Theme switching (Light/Dark/System)'),
                    Text('• Secure storage for sensitive data'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder page for routes that aren't implemented yet
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This page is coming soon!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}