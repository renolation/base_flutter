import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_paths.dart';

/// Authentication state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);

/// Authentication state
enum AuthState {
  unknown,
  authenticated,
  unauthenticated,
}

/// Authentication state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.unknown) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    // TODO: Implement actual auth check logic
    // For now, simulate checking stored auth token
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock authentication check
    // In a real app, you would check secure storage for auth token
    state = AuthState.unauthenticated;
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic
    await Future.delayed(const Duration(seconds: 1));
    state = AuthState.authenticated;
  }

  Future<void> logout() async {
    // TODO: Implement actual logout logic
    await Future.delayed(const Duration(milliseconds: 300));
    state = AuthState.unauthenticated;
  }

  Future<void> register(String email, String password) async {
    // TODO: Implement actual registration logic
    await Future.delayed(const Duration(seconds: 1));
    state = AuthState.authenticated;
  }
}

/// Route guard utility class
class RouteGuard {
  /// Check if user can access the given route
  static bool canAccess(String path, AuthState authState) {
    // Allow access during unknown state (loading)
    if (authState == AuthState.unknown) {
      return true;
    }

    // Check if route requires authentication
    final requiresAuth = RoutePaths.requiresAuth(path);
    final isAuthenticated = authState == AuthState.authenticated;

    if (requiresAuth && !isAuthenticated) {
      return false;
    }

    // Prevent authenticated users from accessing auth pages
    if (RoutePaths.isAuthPath(path) && isAuthenticated) {
      return false;
    }

    return true;
  }

  /// Get redirect path based on current route and auth state
  static String? getRedirectPath(String path, AuthState authState) {
    if (authState == AuthState.unknown) {
      return null; // Don't redirect during loading
    }

    final requiresAuth = RoutePaths.requiresAuth(path);
    final isAuthenticated = authState == AuthState.authenticated;

    // Redirect unauthenticated users to login
    if (requiresAuth && !isAuthenticated) {
      return RoutePaths.login;
    }

    // Redirect authenticated users away from auth pages
    if (RoutePaths.isAuthPath(path) && isAuthenticated) {
      return RoutePaths.home;
    }

    return null;
  }
}

/// Onboarding state provider
final onboardingStateProvider = StateNotifierProvider<OnboardingStateNotifier, bool>(
  (ref) => OnboardingStateNotifier(),
);

/// Onboarding state notifier
class OnboardingStateNotifier extends StateNotifier<bool> {
  OnboardingStateNotifier() : super(true) {
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // TODO: Check if user has completed onboarding
    // For now, simulate that onboarding is not completed
    await Future.delayed(const Duration(milliseconds: 300));
    state = false; // false means onboarding is completed
  }

  void completeOnboarding() {
    state = false;
    // TODO: Save onboarding completion status to storage
  }
}

/// Permission types
enum Permission {
  camera,
  microphone,
  location,
  storage,
  notifications,
}

/// Permission state provider
final permissionStateProvider = StateNotifierProvider<PermissionStateNotifier, Map<Permission, bool>>(
  (ref) => PermissionStateNotifier(),
);

/// Permission state notifier
class PermissionStateNotifier extends StateNotifier<Map<Permission, bool>> {
  PermissionStateNotifier() : super({}) {
    _initializePermissions();
  }

  void _initializePermissions() {
    // Initialize all permissions as not granted
    state = {
      for (final permission in Permission.values) permission: false,
    };
  }

  Future<void> requestPermission(Permission permission) async {
    // TODO: Implement actual permission request logic
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock permission grant
    state = {
      ...state,
      permission: true,
    };
  }

  bool hasPermission(Permission permission) {
    return state[permission] ?? false;
  }

  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every((permission) => hasPermission(permission));
  }
}