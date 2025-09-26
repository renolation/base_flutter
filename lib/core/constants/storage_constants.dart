/// Storage-related constants for Hive boxes and secure storage keys
class StorageConstants {
  // Hive Box Names
  static const String appSettingsBox = 'app_settings';
  static const String userDataBox = 'user_data';
  static const String cacheBox = 'cache_box';

  // Secure Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userCredentialsKey = 'user_credentials';
  static const String biometricKey = 'biometric_enabled';

  // Cache Keys
  static const String userPreferencesKey = 'user_preferences';
  static const String appThemeKey = 'app_theme';
  static const String languageKey = 'selected_language';
  static const String firstRunKey = 'is_first_run';

  // Settings Keys
  static const String isDarkModeKey = 'is_dark_mode';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String autoSyncKey = 'auto_sync_enabled';
}