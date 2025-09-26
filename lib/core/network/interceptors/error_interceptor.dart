import 'dart:io';

import 'package:dio/dio.dart';

import '../api_constants.dart';
import '../models/api_response.dart';

/// Interceptor that handles and transforms network errors into domain-specific exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final networkFailure = _mapDioExceptionToNetworkFailure(err);

    // Create a new DioException with our custom error
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: networkFailure,
      type: err.type,
      message: networkFailure.message,
      stackTrace: err.stackTrace,
    );

    handler.next(customError);
  }

  NetworkFailure _mapDioExceptionToNetworkFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutError(
          message: _getTimeoutMessage(error.type),
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const NetworkConnectionError(
          message: 'Request was cancelled',
        );

      case DioExceptionType.connectionError:
        return _handleConnectionError(error);

      case DioExceptionType.badCertificate:
        return const NetworkConnectionError(
          message: 'Certificate verification failed. Please check your connection security.',
        );

      case DioExceptionType.unknown:
        return _handleUnknownError(error);
    }
  }

  NetworkFailure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (statusCode) {
      case ApiConstants.unauthorizedCode:
        return UnauthorizedError(
          message: _extractErrorMessage(responseData) ??
                   'Authentication failed. Please log in again.',
        );

      case ApiConstants.forbiddenCode:
        return ForbiddenError(
          message: _extractErrorMessage(responseData) ??
                   'Access denied. You don\'t have permission to access this resource.',
        );

      case ApiConstants.notFoundCode:
        return NotFoundError(
          message: _extractErrorMessage(responseData) ??
                   'The requested resource was not found.',
        );

      case 422: // Validation error
        final errors = _extractValidationErrors(responseData);
        return ValidationError(
          message: _extractErrorMessage(responseData) ??
                   'Validation failed. Please check your input.',
          errors: errors,
        );

      case ApiConstants.internalServerErrorCode:
      case ApiConstants.badGatewayCode:
      case ApiConstants.serviceUnavailableCode:
        return ServerError(
          statusCode: statusCode!,
          message: _extractErrorMessage(responseData) ??
                   'Server error occurred. Please try again later.',
        );

      default:
        return ServerError(
          statusCode: statusCode ?? 0,
          message: _extractErrorMessage(responseData) ??
                   'An unexpected server error occurred.',
        );
    }
  }

  NetworkFailure _handleConnectionError(DioException error) {
    // Check for specific connection error types
    final originalError = error.error;

    if (originalError is SocketException) {
      return _handleSocketException(originalError);
    }

    if (originalError is HttpException) {
      return NetworkConnectionError(
        message: 'HTTP error: ${originalError.message}',
      );
    }

    return const NetworkConnectionError(
      message: 'Connection failed. Please check your internet connection and try again.',
    );
  }

  NetworkFailure _handleSocketException(SocketException socketException) {
    final message = socketException.message.toLowerCase();

    if (message.contains('network is unreachable') ||
        message.contains('no route to host')) {
      return const NetworkConnectionError(
        message: 'Network is unreachable. Please check your internet connection.',
      );
    }

    if (message.contains('connection refused') ||
        message.contains('connection failed')) {
      return const NetworkConnectionError(
        message: 'Unable to connect to server. Please try again later.',
      );
    }

    if (message.contains('host lookup failed') ||
        message.contains('nodename nor servname provided')) {
      return const NetworkConnectionError(
        message: 'Server not found. Please check your connection and try again.',
      );
    }

    return NetworkConnectionError(
      message: 'Connection error: ${socketException.message}',
    );
  }

  NetworkFailure _handleUnknownError(DioException error) {
    final originalError = error.error;

    if (originalError is FormatException) {
      return const UnknownError(
        message: 'Invalid response format received from server.',
      );
    }

    if (originalError is TypeError) {
      return const UnknownError(
        message: 'Data parsing error occurred.',
      );
    }

    return UnknownError(
      message: originalError?.toString() ?? 'An unexpected error occurred.',
    );
  }

  String _getTimeoutMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Request took too long to send.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Server took too long to respond.';
      default:
        return 'Request timeout. Please try again.';
    }
  }

  String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    try {
      // Handle different response formats
      if (responseData is Map<String, dynamic>) {
        // Try common error message fields
        final messageFields = ['message', 'error', 'detail', 'error_description'];

        for (final field in messageFields) {
          if (responseData.containsKey(field) && responseData[field] != null) {
            return responseData[field].toString();
          }
        }

        // Try to extract from nested error object
        if (responseData.containsKey('error') && responseData['error'] is Map) {
          final errorObj = responseData['error'] as Map<String, dynamic>;
          for (final field in messageFields) {
            if (errorObj.containsKey(field) && errorObj[field] != null) {
              return errorObj[field].toString();
            }
          }
        }

        // Try to extract from errors array
        if (responseData.containsKey('errors') && responseData['errors'] is List) {
          final errors = responseData['errors'] as List;
          if (errors.isNotEmpty) {
            final firstError = errors.first;
            if (firstError is Map<String, dynamic> && firstError.containsKey('message')) {
              return firstError['message'].toString();
            } else if (firstError is String) {
              return firstError;
            }
          }
        }
      }

      // If it's a string, return it directly
      if (responseData is String) {
        return responseData;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  List<ApiError> _extractValidationErrors(dynamic responseData) {
    final errors = <ApiError>[];

    if (responseData == null) return errors;

    try {
      if (responseData is Map<String, dynamic>) {
        // Handle Laravel-style validation errors
        if (responseData.containsKey('errors') && responseData['errors'] is Map) {
          final errorsMap = responseData['errors'] as Map<String, dynamic>;

          errorsMap.forEach((field, messages) {
            if (messages is List) {
              for (final message in messages) {
                errors.add(ApiError(
                  code: 'validation_error',
                  message: message.toString(),
                  field: field,
                ));
              }
            } else if (messages is String) {
              errors.add(ApiError(
                code: 'validation_error',
                message: messages,
                field: field,
              ));
            }
          });
        }

        // Handle array of error objects
        if (responseData.containsKey('errors') && responseData['errors'] is List) {
          final errorsList = responseData['errors'] as List;

          for (final error in errorsList) {
            if (error is Map<String, dynamic>) {
              errors.add(ApiError(
                code: error['code']?.toString() ?? 'validation_error',
                message: error['message']?.toString() ?? 'Validation error',
                field: error['field']?.toString(),
                details: error['details'] as Map<String, dynamic>?,
              ));
            } else if (error is String) {
              errors.add(ApiError(
                code: 'validation_error',
                message: error,
              ));
            }
          }
        }
      }
    } catch (e) {
      // If parsing fails, add a generic validation error
      errors.add(const ApiError(
        code: 'validation_error',
        message: 'Validation failed',
      ));
    }

    return errors;
  }
}

/// Extension to get NetworkFailure from DioException
extension DioExceptionExtension on DioException {
  NetworkFailure get networkFailure {
    if (error is NetworkFailure) {
      return error as NetworkFailure;
    }

    // Fallback mapping if not processed by interceptor
    return const UnknownError(
      message: 'An unexpected error occurred',
    );
  }
}

/// Helper extension to check error types
extension NetworkFailureExtension on NetworkFailure {
  bool get isNetworkError => when(
    serverError: (_, __, ___) => false,
    networkError: (_) => true,
    timeoutError: (_) => true,
    unauthorizedError: (_) => false,
    forbiddenError: (_) => false,
    notFoundError: (_) => false,
    validationError: (_, __) => false,
    unknownError: (_) => false,
  );

  bool get isServerError => when(
    serverError: (_, __, ___) => true,
    networkError: (_) => false,
    timeoutError: (_) => false,
    unauthorizedError: (_) => false,
    forbiddenError: (_) => false,
    notFoundError: (_) => false,
    validationError: (_, __) => false,
    unknownError: (_) => false,
  );

  bool get isAuthError => when(
    serverError: (_, __, ___) => false,
    networkError: (_) => false,
    timeoutError: (_) => false,
    unauthorizedError: (_) => true,
    forbiddenError: (_) => true,
    notFoundError: (_) => false,
    validationError: (_, __) => false,
    unknownError: (_) => false,
  );
}