import '../constants/environment_config.dart';

/// API constants for network configuration
class ApiConstants {
  // Private constructor to prevent instantiation
  const ApiConstants._();

  // Environment-based configuration
  static String get baseUrl => EnvironmentConfig.baseUrl;
  static String get apiPath => EnvironmentConfig.apiPath;

  // Timeout configurations
  static int get connectTimeout => EnvironmentConfig.connectTimeout;
  static int get receiveTimeout => EnvironmentConfig.receiveTimeout;
  static int get sendTimeout => EnvironmentConfig.sendTimeout;

  // Retry configurations
  static int get maxRetries => EnvironmentConfig.maxRetries;
  static Duration get retryDelay => EnvironmentConfig.retryDelay;

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String userAgent = 'BaseFlutter/1.0.0';

  // Authentication
  static const String authHeaderKey = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String apiKeyHeaderKey = 'X-API-Key';

  // Authentication endpoints
  static String get authEndpoint => EnvironmentConfig.authEndpoint;
  static String get loginEndpoint => EnvironmentConfig.loginEndpoint;
  static String get registerEndpoint => EnvironmentConfig.registerEndpoint;
  static String get refreshEndpoint => EnvironmentConfig.refreshEndpoint;
  static String get logoutEndpoint => EnvironmentConfig.logoutEndpoint;
  static String get resetPasswordEndpoint => EnvironmentConfig.resetPasswordEndpoint;
  static String get changePasswordEndpoint => EnvironmentConfig.changePasswordEndpoint;
  static String get verifyEmailEndpoint => EnvironmentConfig.verifyEmailEndpoint;

  // User endpoints
  static String get userEndpoint => EnvironmentConfig.userEndpoint;
  static String get profileEndpoint => EnvironmentConfig.profileEndpoint;
  static String get updateProfileEndpoint => EnvironmentConfig.updateProfileEndpoint;
  static String get deleteAccountEndpoint => EnvironmentConfig.deleteAccountEndpoint;

  // Cache configurations
  static const Duration cacheMaxAge = Duration(minutes: 5);
  static const String cacheControlHeader = 'Cache-Control';
  static const String etagHeader = 'ETag';
  static const String ifNoneMatchHeader = 'If-None-Match';

  // Error codes
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int internalServerErrorCode = 500;
  static const int badGatewayCode = 502;
  static const int serviceUnavailableCode = 503;

  // Certificate pinning (for production)
  static const List<String> certificateHashes = [
    // Add SHA256 hashes of your server certificates here
    // Example: 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
  ];

  // Development flags (environment-specific)
  static bool get enableLogging => EnvironmentConfig.enableLogging;
  static bool get enableCertificatePinning => EnvironmentConfig.enableCertificatePinning;
  static bool get enableDetailedLogging => EnvironmentConfig.enableDetailedLogging;
}