/// API constants for network configuration
class ApiConstants {
  // Private constructor to prevent instantiation
  const ApiConstants._();

  // Base URLs for different environments
  static const String baseUrlDev = 'https://api-dev.example.com';
  static const String baseUrlStaging = 'https://api-staging.example.com';
  static const String baseUrlProd = 'https://api.example.com';

  // Current environment base URL
  // In a real app, this would be determined by build configuration
  static const String baseUrl = baseUrlDev;

  // API versioning
  static const String apiVersion = 'v1';
  static const String apiPath = '/api/$apiVersion';

  // Timeout configurations (in milliseconds)
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Retry configurations
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String userAgent = 'BaseFlutter/1.0.0';

  // Authentication
  static const String authHeaderKey = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String apiKeyHeaderKey = 'X-API-Key';

  // Common API endpoints
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '$authEndpoint/login';
  static const String refreshEndpoint = '$authEndpoint/refresh';
  static const String logoutEndpoint = '$authEndpoint/logout';
  static const String userEndpoint = '/user';
  static const String profileEndpoint = '$userEndpoint/profile';

  // Example service endpoints (for demonstration)
  static const String todosEndpoint = '/todos';
  static const String postsEndpoint = '/posts';
  static const String usersEndpoint = '/users';

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

  // Development flags
  static const bool enableLogging = true;
  static const bool enableCertificatePinning = false; // Disabled for development

  // API rate limiting
  static const int maxRequestsPerMinute = 100;
  static const Duration rateLimitWindow = Duration(minutes: 1);
}