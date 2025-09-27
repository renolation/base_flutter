import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/environment_config.dart';
import 'api_constants.dart';
import 'dio_client.dart';

/// Example authentication service demonstrating the localhost:3000 configuration
/// This service shows how to use the updated API configuration with the backend
class AuthServiceExample {
  final DioClient _dioClient;

  AuthServiceExample(this._dioClient);

  /// Test connection to the backend
  Future<Map<String, dynamic>> testConnection() async {
    try {
      debugPrint('🔍 Testing connection to ${EnvironmentConfig.baseUrl}...');

      final response = await _dioClient.get('/');

      return {
        'status': 'success',
        'message': 'Connected to backend successfully',
        'baseUrl': EnvironmentConfig.baseUrl,
        'statusCode': response.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (error) {
      debugPrint('❌ Connection test failed: $error');
      return {
        'status': 'error',
        'message': 'Failed to connect to backend',
        'error': error.toString(),
        'baseUrl': EnvironmentConfig.baseUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Login with email and password
  /// Calls POST localhost:3000/auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Attempting login to ${EnvironmentConfig.loginUrl}...');

      final response = await _dioClient.post(
        ApiConstants.loginEndpoint, // This resolves to /auth/login
        data: {
          'email': email,
          'password': password,
        },
      );

      debugPrint('✅ Login successful');
      return {
        'status': 'success',
        'data': response.data,
        'endpoint': EnvironmentConfig.loginUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } on DioException catch (dioError) {
      debugPrint('❌ Login failed with DioException: ${dioError.message}');
      return {
        'status': 'error',
        'error': dioError.message ?? 'Unknown Dio error',
        'statusCode': dioError.response?.statusCode,
        'endpoint': EnvironmentConfig.loginUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (error) {
      debugPrint('❌ Login failed: $error');
      return {
        'status': 'error',
        'error': error.toString(),
        'endpoint': EnvironmentConfig.loginUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Register new user
  /// Calls POST localhost:3000/auth/register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      debugPrint('📝 Attempting registration to ${EnvironmentConfig.registerUrl}...');

      final response = await _dioClient.post(
        ApiConstants.registerEndpoint, // This resolves to /auth/register
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      debugPrint('✅ Registration successful');
      return {
        'status': 'success',
        'data': response.data,
        'endpoint': EnvironmentConfig.registerUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } on DioException catch (dioError) {
      debugPrint('❌ Registration failed with DioException: ${dioError.message}');
      return {
        'status': 'error',
        'error': dioError.message ?? 'Unknown Dio error',
        'statusCode': dioError.response?.statusCode,
        'endpoint': EnvironmentConfig.registerUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (error) {
      debugPrint('❌ Registration failed: $error');
      return {
        'status': 'error',
        'error': error.toString(),
        'endpoint': EnvironmentConfig.registerUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Refresh authentication token
  /// Calls POST localhost:3000/auth/refresh
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      debugPrint('🔄 Attempting token refresh to ${EnvironmentConfig.refreshUrl}...');

      final response = await _dioClient.post(
        ApiConstants.refreshEndpoint, // This resolves to /auth/refresh
        data: {
          'refreshToken': refreshToken,
        },
      );

      debugPrint('✅ Token refresh successful');
      return {
        'status': 'success',
        'data': response.data,
        'endpoint': EnvironmentConfig.refreshUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } on DioException catch (dioError) {
      debugPrint('❌ Token refresh failed with DioException: ${dioError.message}');
      return {
        'status': 'error',
        'error': dioError.message ?? 'Unknown Dio error',
        'statusCode': dioError.response?.statusCode,
        'endpoint': EnvironmentConfig.refreshUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (error) {
      debugPrint('❌ Token refresh failed: $error');
      return {
        'status': 'error',
        'error': error.toString(),
        'endpoint': EnvironmentConfig.refreshUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Logout user
  /// Calls POST localhost:3000/auth/logout
  Future<Map<String, dynamic>> logout(String accessToken) async {
    try {
      debugPrint('🚪 Attempting logout to ${EnvironmentConfig.logoutUrl}...');

      final response = await _dioClient.post(
        ApiConstants.logoutEndpoint, // This resolves to /auth/logout
        options: Options(
          headers: {
            ApiConstants.authHeaderKey: '${ApiConstants.bearerPrefix} $accessToken',
          },
        ),
      );

      debugPrint('✅ Logout successful');
      return {
        'status': 'success',
        'data': response.data,
        'endpoint': EnvironmentConfig.logoutUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } on DioException catch (dioError) {
      debugPrint('❌ Logout failed with DioException: ${dioError.message}');
      return {
        'status': 'error',
        'error': dioError.message ?? 'Unknown Dio error',
        'statusCode': dioError.response?.statusCode,
        'endpoint': EnvironmentConfig.logoutUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (error) {
      debugPrint('❌ Logout failed: $error');
      return {
        'status': 'error',
        'error': error.toString(),
        'endpoint': EnvironmentConfig.logoutUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get current environment configuration for debugging
  Map<String, dynamic> getEnvironmentInfo() {
    return {
      'environment': EnvironmentConfig.currentEnvironment.name,
      'baseUrl': EnvironmentConfig.baseUrl,
      'apiPath': EnvironmentConfig.apiPath,
      'fullBaseUrl': EnvironmentConfig.fullBaseUrl,
      'endpoints': {
        'login': EnvironmentConfig.loginUrl,
        'register': EnvironmentConfig.registerUrl,
        'refresh': EnvironmentConfig.refreshUrl,
        'logout': EnvironmentConfig.logoutUrl,
      },
      'timeouts': {
        'connect': EnvironmentConfig.connectTimeout,
        'receive': EnvironmentConfig.receiveTimeout,
        'send': EnvironmentConfig.sendTimeout,
      },
      'retry': {
        'maxRetries': EnvironmentConfig.maxRetries,
        'retryDelay': EnvironmentConfig.retryDelay.inMilliseconds,
      },
      'flags': {
        'enableLogging': EnvironmentConfig.enableLogging,
        'enableDetailedLogging': EnvironmentConfig.enableDetailedLogging,
        'enableCertificatePinning': EnvironmentConfig.enableCertificatePinning,
      },
    };
  }
}