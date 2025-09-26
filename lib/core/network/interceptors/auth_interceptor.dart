import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api_constants.dart';

/// Interceptor that handles authentication tokens and automatic token refresh
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  // Token storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  // Track if we're currently refreshing to prevent multiple refresh attempts
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];

  AuthInterceptor({
    required FlutterSecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Skip auth for certain endpoints
      if (_shouldSkipAuth(options.path)) {
        handler.next(options);
        return;
      }

      // Add access token to request
      final accessToken = await _getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers[ApiConstants.authHeaderKey] =
            '${ApiConstants.bearerPrefix} $accessToken';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to add authentication token: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 unauthorized errors
    if (err.response?.statusCode != ApiConstants.unauthorizedCode) {
      handler.next(err);
      return;
    }

    // Skip refresh for certain endpoints
    if (_shouldSkipAuth(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    try {
      // Attempt to refresh token
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry the original request with new token
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
      } else {
        // Refresh failed, clear tokens and propagate error
        await _clearTokens();
        handler.next(err);
      }
    } catch (e) {
      // If refresh fails, clear tokens and propagate original error
      await _clearTokens();
      handler.next(err);
    }
  }

  /// Check if the endpoint should skip authentication
  bool _shouldSkipAuth(String path) {
    final skipAuthEndpoints = [
      ApiConstants.loginEndpoint,
      ApiConstants.refreshEndpoint,
      // Add other public endpoints here
    ];

    return skipAuthEndpoints.any((endpoint) => path.contains(endpoint));
  }

  /// Get the stored access token
  Future<String?> _getAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get the stored refresh token
  Future<String?> _getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if the token is expired
  Future<bool> _isTokenExpired() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null) return true;

      final expiry = DateTime.parse(expiryString);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  /// Refresh the access token using the refresh token
  Future<bool> _refreshToken() async {
    // If already refreshing, wait for it to complete
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshCompleters.add(completer);
      await completer.future;
      return await _getAccessToken() != null;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Make refresh request
      final response = await _dio.post(
        ApiConstants.refreshEndpoint,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.contentType,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;

        // Store new tokens
        await _storeTokens(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String?,
          expiresIn: data['expires_in'] as int?,
        );

        return true;
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      _isRefreshing = false;

      // Complete all waiting requests
      for (final completer in _refreshCompleters) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      _refreshCompleters.clear();
    }
  }

  /// Retry the original request with the new token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    // Add the new access token
    final accessToken = await _getAccessToken();
    if (accessToken != null) {
      requestOptions.headers[ApiConstants.authHeaderKey] =
          '${ApiConstants.bearerPrefix} $accessToken';
    }

    // Retry the request
    return await _dio.fetch(requestOptions);
  }

  /// Store authentication tokens securely
  Future<void> storeTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) async {
    await _storeTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }

  Future<void> _storeTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) async {
    try {
      // Store access token
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);

      // Store refresh token if provided
      if (refreshToken != null) {
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }

      // Calculate and store expiry time
      if (expiresIn != null) {
        final expiry = DateTime.now().add(Duration(seconds: expiresIn));
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: expiry.toIso8601String(),
        );
      }
    } catch (e) {
      throw Exception('Failed to store tokens: $e');
    }
  }

  /// Clear all stored tokens
  Future<void> _clearTokens() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _tokenExpiryKey);
    } catch (e) {
      // Log error but don't throw
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await _getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    // Check if token is expired
    return !(await _isTokenExpired());
  }

  /// Logout by clearing all tokens
  Future<void> logout() async {
    await _clearTokens();
  }

  /// Get current access token (for debugging or manual API calls)
  Future<String?> getCurrentAccessToken() async {
    return await _getAccessToken();
  }

  /// Get current refresh token (for debugging)
  Future<String?> getCurrentRefreshToken() async {
    return await _getRefreshToken();
  }
}