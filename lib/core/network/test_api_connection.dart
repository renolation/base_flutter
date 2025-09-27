import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/environment_config.dart';

/// Simple utility to test API connection
class ApiConnectionTest {
  static Future<void> testConnection(BuildContext context) async {
    final dio = Dio();

    try {
      debugPrint('🔍 Testing API connection...');
      debugPrint('Base URL: ${EnvironmentConfig.baseUrl}');
      debugPrint('Auth endpoint: ${EnvironmentConfig.authEndpoint}');

      // Test basic connectivity to the auth endpoint
      final response = await dio.get(
        '${EnvironmentConfig.baseUrl}${EnvironmentConfig.authEndpoint}',
        options: Options(
          validateStatus: (status) => true, // Accept any status code
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      debugPrint('✅ Connection successful!');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API Connected! Status: ${response.statusCode}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Connection failed: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Get current environment info as formatted string
  static String getEnvironmentInfo() {
    final info = EnvironmentConfig.debugInfo;
    final buffer = StringBuffer();

    buffer.writeln('📊 Environment Configuration:');
    buffer.writeln('================================');
    info.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    buffer.writeln('================================');
    buffer.writeln('\n📍 Auth Endpoints:');
    buffer.writeln('Login: ${EnvironmentConfig.loginUrl}');
    buffer.writeln('Register: ${EnvironmentConfig.registerUrl}');
    buffer.writeln('Refresh: ${EnvironmentConfig.refreshUrl}');
    buffer.writeln('Logout: ${EnvironmentConfig.logoutUrl}');

    return buffer.toString();
  }

  /// Print environment info to console
  static void printEnvironmentInfo() {
    debugPrint(getEnvironmentInfo());
  }
}