/// Route path constants for URL patterns
class RoutePaths {
  RoutePaths._();

  // Main routes
  static const String home = '/';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String lesson = '/lesson';

  // Auth routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // Onboarding routes
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';

  // Todo routes (keeping existing feature)
  static const String todos = '/todos';
  static const String todoDetails = '/todos/:id';
  static const String addTodo = '/todos/add';
  static const String editTodo = '/todos/:id/edit';

  // Error routes
  static const String error = '/error';
  static const String notFound = '/404';

  // Nested settings routes
  static const String settingsGeneral = '/settings/general';
  static const String settingsPrivacy = '/settings/privacy';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsTheme = '/settings/theme';

  /// Helper method to build paths with parameters
  static String todoDetailsPath(String id) => '/todos/$id';
  static String editTodoPath(String id) => '/todos/$id/edit';

  /// Helper method to check if path requires authentication
  static bool requiresAuth(String path) {
    const publicPaths = [
      home,
      login,
      register,
      forgotPassword,
      resetPassword,
      verifyEmail,
      onboarding,
      welcome,
      error,
      notFound,
    ];
    return !publicPaths.contains(path);
  }

  /// Helper method to check if path is auth related
  static bool isAuthPath(String path) {
    const authPaths = [
      login,
      register,
      forgotPassword,
      resetPassword,
      verifyEmail,
    ];
    return authPaths.contains(path);
  }
}