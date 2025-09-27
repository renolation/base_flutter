/// Environment configuration for API endpoints and settings
enum Environment {
  development,
  staging,
  production,
}

/// Environment-specific configuration
class EnvironmentConfig {
  // Private constructor to prevent instantiation
  const EnvironmentConfig._();

  /// Current environment - Change this to switch environments
  static const Environment currentEnvironment = Environment.development;

  /// Get base URL for current environment
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://api-staging.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }

  /// Get API path for current environment
  static String get apiPath {
    switch (currentEnvironment) {
      case Environment.development:
        // No API prefix for local development - endpoints are directly at /auth/
        return '';
      case Environment.staging:
      case Environment.production:
        return '/api/v1';
    }
  }

  /// Check if current environment is development
  static bool get isDevelopment => currentEnvironment == Environment.development;

  /// Check if current environment is staging
  static bool get isStaging => currentEnvironment == Environment.staging;

  /// Check if current environment is production
  static bool get isProduction => currentEnvironment == Environment.production;

  /// Get timeout configurations based on environment
  static int get connectTimeout {
    switch (currentEnvironment) {
      case Environment.development:
        return 10000; // 10 seconds for local development
      case Environment.staging:
        return 20000; // 20 seconds for staging
      case Environment.production:
        return 30000; // 30 seconds for production
    }
  }

  static int get receiveTimeout {
    switch (currentEnvironment) {
      case Environment.development:
        return 15000; // 15 seconds for local development
      case Environment.staging:
        return 25000; // 25 seconds for staging
      case Environment.production:
        return 30000; // 30 seconds for production
    }
  }

  static int get sendTimeout {
    switch (currentEnvironment) {
      case Environment.development:
        return 15000; // 15 seconds for local development
      case Environment.staging:
        return 25000; // 25 seconds for staging
      case Environment.production:
        return 30000; // 30 seconds for production
    }
  }

  /// Get retry configurations based on environment
  static int get maxRetries {
    switch (currentEnvironment) {
      case Environment.development:
        return 2; // Fewer retries for local development
      case Environment.staging:
        return 3; // Standard retries for staging
      case Environment.production:
        return 3; // Standard retries for production
    }
  }

  static Duration get retryDelay {
    switch (currentEnvironment) {
      case Environment.development:
        return const Duration(milliseconds: 500); // Faster retry for local
      case Environment.staging:
        return const Duration(seconds: 1); // Standard retry delay
      case Environment.production:
        return const Duration(seconds: 1); // Standard retry delay
    }
  }

  /// Enable/disable features based on environment
  static bool get enableLogging => !isProduction;
  static bool get enableDetailedLogging => isDevelopment;
  static bool get enableCertificatePinning => isProduction;

  /// Authentication endpoints (consistent across environments)
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '$authEndpoint/login';
  static const String registerEndpoint = '$authEndpoint/register';
  static const String refreshEndpoint = '$authEndpoint/refresh';
  static const String logoutEndpoint = '$authEndpoint/logout';

  /// Full API URLs
  static String get fullBaseUrl => baseUrl + apiPath;
  static String get loginUrl => baseUrl + loginEndpoint;
  static String get registerUrl => baseUrl + registerEndpoint;
  static String get refreshUrl => baseUrl + refreshEndpoint;
  static String get logoutUrl => baseUrl + logoutEndpoint;

  /// Debug information
  static Map<String, dynamic> get debugInfo => {
        'environment': currentEnvironment.name,
        'baseUrl': baseUrl,
        'apiPath': apiPath,
        'fullBaseUrl': fullBaseUrl,
        'connectTimeout': connectTimeout,
        'receiveTimeout': receiveTimeout,
        'sendTimeout': sendTimeout,
        'maxRetries': maxRetries,
        'retryDelay': retryDelay.inMilliseconds,
        'enableLogging': enableLogging,
        'enableDetailedLogging': enableDetailedLogging,
        'enableCertificatePinning': enableCertificatePinning,
      };
}