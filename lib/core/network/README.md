# Network Layer Documentation

This network layer provides a comprehensive HTTP client implementation using Dio with advanced features like authentication, retry logic, error handling, and connectivity monitoring.

## Features

- ✅ **Configured Dio client** with timeouts and base URL management
- ✅ **Authentication interceptor** with automatic token refresh
- ✅ **Comprehensive error handling** with domain-specific exceptions
- ✅ **Request/response logging** for debugging
- ✅ **Automatic retry logic** for failed requests
- ✅ **Network connectivity monitoring**
- ✅ **Certificate pinning setup** (configurable)
- ✅ **File upload/download support**
- ✅ **Standardized API response models**

## Architecture

```
lib/core/network/
├── dio_client.dart              # Main HTTP client wrapper
├── api_constants.dart           # API configuration and endpoints
├── network_info.dart            # Connectivity monitoring
├── interceptors/
│   ├── auth_interceptor.dart    # Token management and refresh
│   ├── logging_interceptor.dart # Request/response logging
│   └── error_interceptor.dart   # Error handling and mapping
├── models/
│   └── api_response.dart        # Standardized response models
└── README.md                    # This documentation
```

## Quick Start

### 1. Setup Providers

```dart
// In your app, use the pre-configured providers
final dioClient = ref.watch(dioClientProvider);

// Or manually create
final dioClient = DioClient(
  networkInfo: NetworkInfoImpl(Connectivity()),
  secureStorage: FlutterSecureStorage(),
);
```

### 2. Basic HTTP Requests

```dart
// GET request
final response = await dioClient.get('/users/123');

// POST request
final response = await dioClient.post('/posts', data: {
  'title': 'My Post',
  'content': 'Post content'
});

// PUT request
final response = await dioClient.put('/users/123', data: userData);

// DELETE request
final response = await dioClient.delete('/posts/456');
```

### 3. File Operations

```dart
// Upload file
final response = await dioClient.uploadFile(
  '/upload',
  File('/path/to/file.jpg'),
  filename: 'avatar.jpg',
);

// Download file
await dioClient.downloadFile(
  '/files/document.pdf',
  '/local/path/document.pdf',
);
```

### 4. Authentication

```dart
// Store tokens after login
await dioClient.authInterceptor.storeTokens(
  accessToken: 'your-access-token',
  refreshToken: 'your-refresh-token',
  expiresIn: 3600, // 1 hour
);

// Check authentication status
final isAuth = await dioClient.authInterceptor.isAuthenticated();

// Logout (clears tokens)
await dioClient.authInterceptor.logout();
```

### 5. Network Connectivity

```dart
// Check current connectivity
final isConnected = await dioClient.isConnected;

// Listen to connectivity changes
dioClient.connectionStream.listen((isConnected) {
  if (isConnected) {
    print('Connected to internet');
  } else {
    print('No internet connection');
  }
});
```

## Configuration

### API Constants (`api_constants.dart`)

```dart
class ApiConstants {
  // Environment URLs
  static const String baseUrlDev = 'https://api-dev.example.com';
  static const String baseUrlProd = 'https://api.example.com';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String userEndpoint = '/user';
}
```

### Environment Switching

```dart
// Update base URL at runtime
dioClient.updateBaseUrl('https://api-staging.example.com');

// Add custom headers
dioClient.addHeader('X-Custom-Header', 'value');

// Remove headers
dioClient.removeHeader('X-Custom-Header');
```

## Error Handling

The network layer provides comprehensive error handling with domain-specific exceptions:

```dart
try {
  final response = await dioClient.get('/api/data');
  // Handle success
} on DioException catch (e) {
  final failure = e.networkFailure;

  failure.when(
    serverError: (statusCode, message, errors) {
      // Handle server errors (5xx)
    },
    networkError: (message) {
      // Handle network connectivity issues
    },
    timeoutError: (message) {
      // Handle timeout errors
    },
    unauthorizedError: (message) {
      // Handle authentication errors (401)
    },
    forbiddenError: (message) {
      // Handle authorization errors (403)
    },
    notFoundError: (message) {
      // Handle not found errors (404)
    },
    validationError: (message, errors) {
      // Handle validation errors (422)
    },
    unknownError: (message) {
      // Handle unknown errors
    },
  );
}
```

### Error Types

- **ServerError**: HTTP 5xx errors from the server
- **NetworkConnectionError**: Network connectivity issues
- **TimeoutError**: Request/response timeouts
- **UnauthorizedError**: HTTP 401 authentication failures
- **ForbiddenError**: HTTP 403 authorization failures
- **NotFoundError**: HTTP 404 resource not found
- **ValidationError**: HTTP 422 validation failures with field details
- **UnknownError**: Any other unexpected errors

## Authentication Flow

The authentication interceptor automatically handles:

1. **Adding tokens** to requests (Authorization header)
2. **Token refresh** when access token expires
3. **Retry failed requests** after token refresh
4. **Token storage** in secure storage
5. **Automatic logout** when refresh fails

### Token Storage

Tokens are securely stored using `flutter_secure_storage`:

- `access_token`: Current access token
- `refresh_token`: Refresh token for getting new access tokens
- `token_expiry`: Token expiration timestamp

### Automatic Refresh

When a request fails with 401 Unauthorized:

1. Interceptor checks if refresh token exists
2. Makes refresh request to `/auth/refresh`
3. Stores new tokens if successful
4. Retries original request with new token
5. If refresh fails, clears all tokens

## Retry Logic

Requests are automatically retried for:

- **Connection timeouts**
- **Server errors (5xx)**
- **Network connectivity issues**

Configuration:
- Maximum retries: 3
- Delay between retries: Progressive (1s, 2s, 3s)
- Only retries on recoverable errors

## Logging

Request/response logging is automatically handled by the logging interceptor:

### Log Output Example

```
🚀 REQUEST: GET https://api.example.com/api/v1/users/123
📋 Headers: {"Authorization": "***HIDDEN***", "Content-Type": "application/json"}
✅ RESPONSE: GET https://api.example.com/api/v1/users/123 [200] (245ms)
📥 Response Body: {"id": 123, "name": "John Doe"}
```

### Log Features

- **Request/response timing**
- **Sensitive header sanitization** (Authorization, API keys, etc.)
- **Body truncation** for large responses
- **Error stack traces** in debug mode
- **Configurable log levels**

### Controlling Logging

```dart
// Disable logging
dioClient.setLoggingEnabled(false);

// Create client with custom logging
final loggingInterceptor = LoggingInterceptor(
  enabled: true,
  logRequestBody: true,
  logResponseBody: false, // Disable response body logging
  maxBodyLength: 1000,    // Limit body length
);
```

## Network Monitoring

The network info service provides detailed connectivity information:

```dart
final networkInfo = NetworkInfoImpl(Connectivity());

// Simple connectivity check
final isConnected = await networkInfo.isConnected;

// Detailed connection info
final details = await networkInfo.getConnectionDetails();
print(details.connectionDescription); // "Connected via WiFi"

// Connection type checks
final isWiFi = await networkInfo.isConnectedToWiFi;
final isMobile = await networkInfo.isConnectedToMobile;
```

## API Response Models

### Basic API Response

```dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;
  final Map<String, dynamic>? meta;

  // Factory constructors
  factory ApiResponse.success({required T data});
  factory ApiResponse.error({required String message});
}
```

### Usage with Services

```dart
class UserService {
  Future<User> getUser(String id) async {
    final response = await dioClient.get('/users/$id');

    return handleApiResponse(
      response,
      (data) => User.fromJson(data),
    );
  }

  T handleApiResponse<T>(Response response, T Function(dynamic) fromJson) {
    if (response.statusCode == 200) {
      return fromJson(response.data);
    }
    throw Exception('Request failed');
  }
}
```

## Best Practices

### 1. Use Providers for Dependency Injection

```dart
final userServiceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UserService(dioClient);
});
```

### 2. Create Service Classes

```dart
class UserService extends BaseApiService {
  UserService(super.dioClient);

  Future<User> getUser(String id) => executeRequest(
    () => dioClient.get('/users/$id'),
    User.fromJson,
  );
}
```

### 3. Handle Errors Gracefully

```dart
try {
  final user = await userService.getUser('123');
  // Handle success
} catch (e) {
  // Show user-friendly error message
  showErrorSnackBar(context, e.toString());
}
```

### 4. Use Network Status

```dart
Widget build(BuildContext context) {
  final networkStatus = ref.watch(networkConnectivityProvider);

  return networkStatus.when(
    data: (isConnected) => isConnected
      ? MainContent()
      : OfflineWidget(),
    loading: () => LoadingWidget(),
    error: (_, __) => ErrorWidget(),
  );
}
```

### 5. Configure for Different Environments

```dart
class ApiEnvironment {
  static String get baseUrl {
    if (kDebugMode) return ApiConstants.baseUrlDev;
    if (kProfileMode) return ApiConstants.baseUrlStaging;
    return ApiConstants.baseUrlProd;
  }
}
```

## Testing

### Mock Network Responses

```dart
class MockDioClient extends DioClient {
  @override
  Future<Response<T>> get<T>(String path, {options, cancelToken, queryParameters}) async {
    // Return mock response
    return Response(
      data: {'id': 1, 'name': 'Test User'},
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}
```

### Test Network Info

```dart
class MockNetworkInfo implements NetworkInfo {
  final bool _isConnected;

  MockNetworkInfo({required bool isConnected}) : _isConnected = isConnected;

  @override
  Future<bool> get isConnected => Future.value(_isConnected);
}
```

## Security Considerations

### 1. Certificate Pinning

```dart
// Enable in production
class ApiConstants {
  static const bool enableCertificatePinning = true;
  static const List<String> certificateHashes = [
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
  ];
}
```

### 2. Secure Token Storage

Tokens are automatically stored in secure storage with platform-specific encryption.

### 3. Request Sanitization

Sensitive headers are automatically sanitized in logs to prevent token leakage.

## Troubleshooting

### Common Issues

1. **Connection Timeouts**
   - Increase timeout values in `ApiConstants`
   - Check network connectivity
   - Verify server availability

2. **Authentication Failures**
   - Ensure tokens are correctly stored
   - Verify refresh endpoint configuration
   - Check token expiration handling

3. **Certificate Errors**
   - Disable certificate pinning in development
   - Add proper certificate hashes for production
   - Check server SSL configuration

### Debug Mode

Enable detailed logging to troubleshoot issues:

```dart
final dioClient = DioClient(
  networkInfo: networkInfo,
  secureStorage: secureStorage,
);

// Enable detailed logging
dioClient.setLoggingEnabled(true);
```

## Migration Guide

When migrating from basic Dio to this network layer:

1. Replace `Dio()` instances with `DioClient`
2. Update error handling to use `NetworkFailure` types
3. Use providers for dependency injection
4. Migrate to service classes extending `BaseApiService`
5. Update authentication flow to use interceptor methods

This network layer provides a solid foundation for any Flutter app requiring robust HTTP communication with proper error handling, authentication, and network monitoring.