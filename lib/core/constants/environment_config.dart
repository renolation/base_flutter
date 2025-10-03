/// Environment configuration for API endpoints and settings
enum Environment {
  development,
  production,
}

/// Environment-specific configuration
class EnvironmentConfig {
  // Private constructor to prevent instantiation
  const EnvironmentConfig._();

  /// Current environment - Change this to switch environments
  static const Environment currentEnvironment = Environment.development;

  /// Environment configurations as JSON map for easy editing
  static const Map<Environment, Map<String, dynamic>> _configs = {
    Environment.development: {
      'baseUrl': 'http://103.188.82.191:4003',
      'apiPath': '',
      'connectTimeout': 30000,
      'receiveTimeout': 30000,
      'sendTimeout': 30000,
      'enableLogging': true,
      'enableDetailedLogging': true,
      'enableCertificatePinning': false,
      'maxRetries': 3,
      'retryDelay': 1000, // milliseconds
    },
    Environment.production: {
      'baseUrl': 'https://api.example.com',
      'apiPath': '/api/v1',
      'connectTimeout': 30000,
      'receiveTimeout': 30000,
      'sendTimeout': 30000,
      'enableLogging': false,
      'enableDetailedLogging': false,
      'enableCertificatePinning': true,
      'maxRetries': 3,
      'retryDelay': 1000, // milliseconds
    },
  };

  /// Get current environment configuration
  static Map<String, dynamic> get _currentConfig => _configs[currentEnvironment]!;

  /// Get base URL for current environment
  static String get baseUrl => _currentConfig['baseUrl'] as String;

  /// Get API path for current environment
  static String get apiPath => _currentConfig['apiPath'] as String;

  /// Check if current environment is development
  static bool get isDevelopment => currentEnvironment == Environment.development;

  /// Check if current environment is production
  static bool get isProduction => currentEnvironment == Environment.production;

  /// Check if current environment is staging (for backward compatibility, always false)
  static bool get isStaging => false;

  /// Timeout configurations from config map
  static int get connectTimeout => _currentConfig['connectTimeout'] as int;
  static int get receiveTimeout => _currentConfig['receiveTimeout'] as int;
  static int get sendTimeout => _currentConfig['sendTimeout'] as int;

  /// Enable/disable features from config map
  static bool get enableLogging => _currentConfig['enableLogging'] as bool;
  static bool get enableDetailedLogging => _currentConfig['enableDetailedLogging'] as bool;
  static bool get enableCertificatePinning => _currentConfig['enableCertificatePinning'] as bool;

  /// Retry configurations
  static int get maxRetries => _currentConfig['maxRetries'] as int;
  static Duration get retryDelay => Duration(milliseconds: _currentConfig['retryDelay'] as int);

  /// Authentication endpoints
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '$authEndpoint/login';
  static const String registerEndpoint = '$authEndpoint/register';
  static const String refreshEndpoint = '$authEndpoint/refresh';
  static const String logoutEndpoint = '$authEndpoint/logout';
  static const String resetPasswordEndpoint = '$authEndpoint/reset-password';
  static const String changePasswordEndpoint = '$authEndpoint/change-password';
  static const String verifyEmailEndpoint = '$authEndpoint/verify-email';

  /// Full API URLs
  static String get fullBaseUrl => baseUrl + apiPath;
  static String get loginUrl => baseUrl + loginEndpoint;
  static String get registerUrl => baseUrl + registerEndpoint;
  static String get refreshUrl => baseUrl + refreshEndpoint;
  static String get logoutUrl => baseUrl + logoutEndpoint;
  static String get resetPasswordUrl => baseUrl + resetPasswordEndpoint;
  static String get changePasswordUrl => baseUrl + changePasswordEndpoint;
  static String get verifyEmailUrl => baseUrl + verifyEmailEndpoint;

  /// User endpoints
  static const String userEndpoint = '/user';
  static const String profileEndpoint = '$userEndpoint/profile';
  static const String updateProfileEndpoint = '$userEndpoint/update';
  static const String deleteAccountEndpoint = '$userEndpoint/delete';

  /// Full User URLs
  static String get profileUrl => baseUrl + profileEndpoint;
  static String get updateProfileUrl => baseUrl + updateProfileEndpoint;
  static String get deleteAccountUrl => baseUrl + deleteAccountEndpoint;

  /// Todo endpoints
  static const String todosEndpoint = '/todo';

  /// Full Todo URLs
  static String get todosUrl => baseUrl + todosEndpoint;

  /// Debug information
  static Map<String, dynamic> get debugInfo => {
        'environment': currentEnvironment.name,
        'config': _currentConfig,
        'endpoints': {
          'login': loginUrl,
          'register': registerUrl,
          'refresh': refreshUrl,
          'logout': logoutUrl,
          'profile': profileUrl,
        },
      };

  /// Get a specific config value
  static T? getConfig<T>(String key) => _currentConfig[key] as T?;

  /// Check if a config key exists
  static bool hasConfig(String key) => _currentConfig.containsKey(key);
}