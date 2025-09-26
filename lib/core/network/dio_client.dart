import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_info.dart';

/// Dio HTTP client wrapper with comprehensive configuration
class DioClient {
  late final Dio _dio;
  final NetworkInfo _networkInfo;
  late final AuthInterceptor _authInterceptor;
  final LoggingInterceptor _loggingInterceptor;
  final ErrorInterceptor _errorInterceptor;

  DioClient({
    required NetworkInfo networkInfo,
    required FlutterSecureStorage secureStorage,
    String? baseUrl,
  }) : _networkInfo = networkInfo,
       _loggingInterceptor = LoggingInterceptor(),
       _errorInterceptor = ErrorInterceptor() {
    _dio = _createDio(baseUrl ?? ApiConstants.baseUrl);
    _authInterceptor = AuthInterceptor(
      secureStorage: secureStorage,
      dio: _dio,
    );
    _setupInterceptors();
    _configureHttpClient();
  }

  /// Getter for the underlying Dio instance
  Dio get dio => _dio;

  /// Create and configure Dio instance
  Dio _createDio(String baseUrl) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl + ApiConstants.apiPath,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
      headers: {
        'Content-Type': ApiConstants.contentType,
        'Accept': ApiConstants.accept,
        'User-Agent': ApiConstants.userAgent,
      },
      responseType: ResponseType.json,
      followRedirects: true,
      validateStatus: (status) {
        // Consider all status codes as valid to handle them in interceptors
        return status != null && status < 500;
      },
    ));

    return dio;
  }

  /// Setup interceptors in the correct order
  void _setupInterceptors() {
    // Add interceptors in order:
    // 1. Request logging and preparation
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add request start time for duration calculation
          options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;
          handler.next(options);
        },
      ),
    );

    // 2. Authentication (adds tokens to requests)
    _dio.interceptors.add(_authInterceptor);

    // 3. Retry interceptor for network failures
    _dio.interceptors.add(_createRetryInterceptor());

    // 4. Logging (logs requests and responses)
    _dio.interceptors.add(_loggingInterceptor);

    // 5. Error handling (last to catch all errors)
    _dio.interceptors.add(_errorInterceptor);
  }

  /// Configure HTTP client for certificate pinning and other security features
  void _configureHttpClient() {
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;

      adapter.createHttpClient = () {
        final client = HttpClient();
        // Configure certificate pinning in production
        if (ApiConstants.enableCertificatePinning) {
          client.badCertificateCallback = (cert, host, port) {
            // Implement certificate pinning logic here
            // For now, return false to reject invalid certificates
            return false;
          };
        }

        // Configure timeouts
        client.connectionTimeout = const Duration(
          milliseconds: ApiConstants.connectTimeout,
        );

        return client;
      };
    }
  }

  /// Create retry interceptor for handling network failures
  InterceptorsWrapper _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        // Only retry on network errors, not server errors
        if (_shouldRetry(error)) {
          final retryCount = error.requestOptions.extra['retry_count'] as int? ?? 0;

          if (retryCount < ApiConstants.maxRetries) {
            error.requestOptions.extra['retry_count'] = retryCount + 1;

            // Wait before retrying
            await Future.delayed(
              ApiConstants.retryDelay * (retryCount + 1),
            );

            // Check network connectivity before retry
            final isConnected = await _networkInfo.isConnected;
            if (!isConnected) {
              handler.next(error);
              return;
            }

            try {
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              // If retry fails, continue with original error
            }
          }
        }

        handler.next(error);
      },
    );
  }

  /// Determine if an error should trigger a retry
  bool _shouldRetry(DioException error) {
    // Retry on network connectivity issues
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on server errors (5xx)
    if (error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;
      return statusCode >= 500 && statusCode < 600;
    }

    return false;
  }

  // HTTP Methods

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String? field,
    String? filename,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData();

    // Add file
    formData.files.add(MapEntry(
      field ?? 'file',
      await MultipartFile.fromFile(
        file.path,
        filename: filename ?? file.path.split('/').last,
      ),
    ));

    // Add other form fields
    if (data != null) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    return await _dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Download file
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.download(
      urlPath,
      savePath,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Utility Methods

  /// Check network connectivity
  Future<bool> get isConnected => _networkInfo.isConnected;

  /// Get network connection stream
  Stream<bool> get connectionStream => _networkInfo.connectionStream;

  /// Update base URL (useful for environment switching)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl + ApiConstants.apiPath;
  }

  /// Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Clear all custom headers (keeps default headers)
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll({
      'Content-Type': ApiConstants.contentType,
      'Accept': ApiConstants.accept,
      'User-Agent': ApiConstants.userAgent,
    });
  }

  /// Get auth interceptor for token management
  AuthInterceptor get authInterceptor => _authInterceptor;

  /// Enable/disable logging
  void setLoggingEnabled(bool enabled) {
    _loggingInterceptor.enabled = enabled;
  }

  /// Create a CancelToken for request cancellation
  CancelToken createCancelToken() => CancelToken();

  /// Close the client and clean up resources
  void close({bool force = false}) {
    _dio.close(force: force);
  }
}