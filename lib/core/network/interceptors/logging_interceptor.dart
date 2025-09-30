import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../api_constants.dart';

/// Custom logging interceptor for detailed request/response logging
class LoggingInterceptor extends Interceptor {
   bool enabled;
  final bool logRequestBody;
  final bool logResponseBody;
  final bool logHeaders;
  final int maxBodyLength;

  LoggingInterceptor({
    bool? enabled,
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.logHeaders = true,
    this.maxBodyLength = 2000,
  }) : enabled = enabled ?? ApiConstants.enableLogging;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      _logError(err);
    }
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final uri = options.uri;
    final method = options.method.toUpperCase();

    developer.log(
      '🚀 REQUEST: $method $uri',
      name: 'HTTP_REQUEST',
    );

    // Log headers
    if (logHeaders && options.headers.isNotEmpty) {
      final headers = _sanitizeHeaders(options.headers);
      developer.log(
        '📋 Headers: ${_formatJson(headers)}',
        name: 'HTTP_REQUEST',
      );
    }

    // Log query parameters
    if (options.queryParameters.isNotEmpty) {
      developer.log(
        '🔍 Query Parameters: ${_formatJson(options.queryParameters)}',
        name: 'HTTP_REQUEST',
      );
    }

    // Log request body
    if (logRequestBody && options.data != null) {
      final body = _formatRequestBody(options.data);
      if (body.isNotEmpty) {
        developer.log(
          '📝 Request Body: $body',
          name: 'HTTP_REQUEST',
        );
      }
    }
  }

  void _logResponse(Response response) {
    final statusCode = response.statusCode;
    final method = response.requestOptions.method.toUpperCase();
    final uri = response.requestOptions.uri;
    final duration = DateTime.now().millisecondsSinceEpoch -
        (response.requestOptions.extra['start_time'] as int? ?? 0);

    // Status icon based on response code
    String statusIcon;
    if (statusCode != null && statusCode != 0) {
      if (statusCode >= 200 && statusCode < 300) {
        statusIcon = '✅';
      } else if (statusCode >= 300 && statusCode < 400) {
        statusIcon = '↩️';
      } else if (statusCode >= 400 && statusCode < 500) {
        statusIcon = '❌';
      } else {
        statusIcon = '💥';
      }
    } else {
      statusIcon = '❓';
    }

    developer.log(
      '$statusIcon RESPONSE: $method $uri [$statusCode] (${duration}ms)',
      name: 'HTTP_RESPONSE',
    );

    // Log response headers
    if (logHeaders && response.headers.map.isNotEmpty) {
      final headers = _sanitizeHeaders(response.headers.map);
      developer.log(
        '📋 Response Headers: ${_formatJson(headers)}',
        name: 'HTTP_RESPONSE',
      );
    }

    // Log response body
    if (logResponseBody && response.data != null) {
      final body = _formatResponseBody(response.data);
      if (body.isNotEmpty) {
        developer.log(
          '📥 Response Body: $body',
          name: 'HTTP_RESPONSE',
        );
      }
    }
  }

  void _logError(DioException error) {
    final method = error.requestOptions.method.toUpperCase();
    final uri = error.requestOptions.uri;
    final statusCode = error.response?.statusCode;

    developer.log(
      '💥 ERROR: $method $uri [${statusCode ?? 'NO_STATUS'}] - ${error.type.name}',
      name: 'HTTP_ERROR',
      error: error,
    );

    // Log error message
    if (error.message != null) {
      developer.log(
        '❗ Error Message: ${error.message}',
        name: 'HTTP_ERROR',
      );
    }

    // Log error response if available
    if (error.response?.data != null) {
      final errorBody = _formatResponseBody(error.response!.data);
      if (errorBody.isNotEmpty) {
        developer.log(
          '📥 Error Response: $errorBody',
          name: 'HTTP_ERROR',
        );
      }
    }

    // Log stack trace in debug mode
    if (error.stackTrace.toString().isNotEmpty) {
      developer.log(
        '🔍 Stack Trace: ${error.stackTrace}',
        name: 'HTTP_ERROR',
      );
    }
  }

  String _formatRequestBody(dynamic data) {
    if (data == null) return '';

    try {
      String body;

      if (data is Map || data is List) {
        body = _formatJson(data);
      } else if (data is FormData) {
        body = _formatFormData(data);
      } else {
        body = data.toString();
      }

      return _truncateIfNeeded(body);
    } catch (e) {
      return 'Failed to format request body: $e';
    }
  }

  String _formatResponseBody(dynamic data) {
    if (data == null) return '';

    try {
      String body;

      if (data is Map || data is List) {
        body = _formatJson(data);
      } else {
        body = data.toString();
      }

      return _truncateIfNeeded(body);
    } catch (e) {
      return 'Failed to format response body: $e';
    }
  }

  String _formatJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  String _formatFormData(FormData formData) {
    final buffer = StringBuffer('FormData{\n');

    for (final field in formData.fields) {
      buffer.writeln('  ${field.key}: ${field.value}');
    }

    for (final file in formData.files) {
      buffer.writeln('  ${file.key}: ${file.value.filename} (${file.value.length} bytes)');
    }

    buffer.write('}');
    return buffer.toString();
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = <String, dynamic>{};

    headers.forEach((key, value) {
      final lowerKey = key.toLowerCase();

      // Sanitize sensitive headers
      if (_isSensitiveHeader(lowerKey)) {
        sanitized[key] = '***HIDDEN***';
      } else {
        sanitized[key] = value;
      }
    });

    return sanitized;
  }

  bool _isSensitiveHeader(String headerName) {
    const sensitiveHeaders = [
      'authorization',
      'cookie',
      'set-cookie',
      'x-api-key',
      'x-auth-token',
      'x-access-token',
      'x-refresh-token',
    ];

    return sensitiveHeaders.contains(headerName);
  }

  String _truncateIfNeeded(String text) {
    if (text.length <= maxBodyLength) {
      return text;
    }

    return '${text.substring(0, maxBodyLength)}... (truncated ${text.length - maxBodyLength} characters)';
  }
}

/// Extension to add start time to request options for duration calculation
extension RequestOptionsExtension on RequestOptions {
  void markStartTime() {
    extra['start_time'] = DateTime.now().millisecondsSinceEpoch;
  }
}
