/// Route name constants for type-safe navigation
class RouteNames {
  RouteNames._();

  // Main routes
  static const String home = 'home';
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String about = 'about';

  // Auth routes
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String verifyEmail = 'verify_email';

  // Onboarding routes
  static const String onboarding = 'onboarding';
  static const String welcome = 'welcome';

  // Todo routes (keeping existing feature)
  static const String todos = 'todos';
  static const String todoDetails = 'todo_details';
  static const String addTodo = 'add_todo';
  static const String editTodo = 'edit_todo';

  // Error routes
  static const String error = 'error';
  static const String notFound = '404';

  // Nested routes
  static const String settingsGeneral = 'settings_general';
  static const String settingsPrivacy = 'settings_privacy';
  static const String settingsNotifications = 'settings_notifications';
  static const String settingsTheme = 'settings_theme';
}