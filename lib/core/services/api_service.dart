import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../network/models/api_response.dart';

/// Base API service class that provides common functionality for all API services
abstract class BaseApiService {
  final DioClient _dioClient;

  BaseApiService(this._dioClient);

  /// Handle API response and extract data
  T handleApiResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      try {
        // If the response data is already the expected type
        if (response.data is T) {
          return response.data as T;
        }

        // If the response data is a Map, try to parse it
        if (response.data is Map<String, dynamic>) {
          return fromJson(response.data);
        }

        // If the response data is a List, try to parse each item
        if (response.data is List && T.toString().contains('List')) {
          return response.data as T;
        }

        return fromJson(response.data);
      } catch (e) {
        throw Exception('Failed to parse response: $e');
      }
    } else {
      throw Exception('API request failed with status: ${response.statusCode}');
    }
  }

  /// Handle API response with ApiResponse wrapper
  T handleWrappedApiResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    try {
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          final apiResponse = ApiResponse<T>.fromJson(
            response.data as Map<String, dynamic>,
            fromJson,
          );

          if (apiResponse.success && apiResponse.data != null) {
            return apiResponse.data!;
          } else {
            throw Exception(apiResponse.message);
          }
        }
        return fromJson(response.data);
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to handle API response: $e');
    }
  }

  /// Execute a request with error handling
  Future<T> executeRequest<T>(
    Future<Response> Function() request,
    T Function(dynamic) fromJson, {
    bool useWrapper = false,
  }) async {
    try {
      final response = await request();

      if (useWrapper) {
        return handleWrappedApiResponse<T>(response, fromJson);
      } else {
        return handleApiResponse<T>(response, fromJson);
      }
    } on DioException catch (e) {
      // The error interceptor will have already processed this
      if (e.error is NetworkFailure) {
        final failure = e.error as NetworkFailure;
        throw Exception(failure.message);
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get the underlying dio client for advanced usage
  DioClient get dioClient => _dioClient;
}

/// Example API service for demonstration
class ExampleApiService extends BaseApiService {
  ExampleApiService(super.dioClient);

  /// Example: Get user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    return executeRequest(
      () => dioClient.get('/users/$userId'),
      (data) => data as Map<String, dynamic>,
    );
  }

  /// Example: Create a new post
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    return executeRequest(
      () => dioClient.post('/posts', data: postData),
      (data) => data as Map<String, dynamic>,
    );
  }

  /// Example: Get posts with pagination
  Future<List<Map<String, dynamic>>> getPosts({
    int page = 1,
    int limit = 10,
  }) async {
    return executeRequest(
      () => dioClient.get(
        '/posts',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      ),
      (data) => (data as List).cast<Map<String, dynamic>>(),
    );
  }

  /// Example: Upload file
  Future<Map<String, dynamic>> uploadFile(
    String filePath,
    String filename,
  ) async {
    try {
      // Note: This is a placeholder. In real implementation, you would use:
      // final response = await dioClient.uploadFile(
      //   '/upload',
      //   File(filePath),
      //   filename: filename,
      // );

      final response = await dioClient.post('/upload', data: {
        'filename': filename,
        'path': filePath,
      });

      return handleApiResponse(
        response,
        (data) => data as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /// Example: Download file
  Future<void> downloadFile(String url, String savePath) async {
    try {
      await dioClient.downloadFile(url, savePath);
    } catch (e) {
      throw Exception('File download failed: $e');
    }
  }

  /// Example: Test network connectivity
  Future<bool> testConnection() async {
    try {
      await dioClient.get('/health');
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Authentication API service
class AuthApiService extends BaseApiService {
  AuthApiService(super.dioClient);

  /// Login with credentials
  Future<Map<String, dynamic>> login(String email, String password) async {
    return executeRequest(
      () => dioClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      }),
      (data) => data as Map<String, dynamic>,
    );
  }

  /// Logout
  Future<void> logout() async {
    try {
      await dioClient.post('/auth/logout');
      await dioClient.authInterceptor.logout();
    } catch (e) {
      // Even if the API call fails, clear local tokens
      await dioClient.authInterceptor.logout();
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return executeRequest(
      () => dioClient.post('/auth/register', data: userData),
      (data) => data as Map<String, dynamic>,
    );
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await dioClient.authInterceptor.isAuthenticated();
  }

  /// Store authentication tokens
  Future<void> storeTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) async {
    await dioClient.authInterceptor.storeTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}