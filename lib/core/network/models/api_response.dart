/// Simple API response wrapper that standardizes all API responses
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;
  final Map<String, dynamic>? meta;
  final int? statusCode;
  final String? timestamp;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
    this.statusCode,
    this.timestamp,
  });

  /// Factory constructor for successful responses
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      meta: meta,
      statusCode: 200,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  /// Factory constructor for error responses
  factory ApiResponse.error({
    required String message,
    List<String>? errors,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
      meta: meta,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  /// Create from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
      errors: (json['errors'] as List<dynamic>?)?.cast<String>(),
      meta: json['meta'] as Map<String, dynamic>?,
      statusCode: json['status_code'] as int?,
      timestamp: json['timestamp'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson([dynamic Function(T)? toJsonT]) {
    return {
      'success': success,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      if (errors != null) 'errors': errors,
      if (meta != null) 'meta': meta,
      if (statusCode != null) 'status_code': statusCode,
      if (timestamp != null) 'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data)';
  }
}

/// Pagination metadata for paginated API responses
class PaginationMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      hasNextPage: json['has_next_page'] ?? false,
      hasPreviousPage: json['has_previous_page'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };
  }
}

/// Paginated API response wrapper
class PaginatedApiResponse<T> {
  final bool success;
  final String message;
  final List<T> data;
  final PaginationMeta pagination;
  final List<String>? errors;
  final int? statusCode;
  final String? timestamp;

  const PaginatedApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
    this.errors,
    this.statusCode,
    this.timestamp,
  });

  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList() ?? [],
      pagination: PaginationMeta.fromJson(json['pagination'] ?? {}),
      errors: (json['errors'] as List<dynamic>?)?.cast<String>(),
      statusCode: json['status_code'] as int?,
      timestamp: json['timestamp'] as String?,
    );
  }
}

/// API error details for more specific error handling
class ApiError {
  final String code;
  final String message;
  final String? field;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.code,
    required this.message,
    this.field,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      field: json['field'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      if (field != null) 'field': field,
      if (details != null) 'details': details,
    };
  }

  @override
  String toString() => 'ApiError(code: $code, message: $message, field: $field)';
}

/// Network response wrapper that includes both success and error cases
abstract class NetworkResponse<T> {
  const NetworkResponse();
}

class NetworkSuccess<T> extends NetworkResponse<T> {
  final T data;

  const NetworkSuccess(this.data);

  @override
  String toString() => 'NetworkSuccess(data: $data)';
}

class NetworkError<T> extends NetworkResponse<T> {
  final NetworkFailure failure;

  const NetworkError(this.failure);

  @override
  String toString() => 'NetworkError(failure: $failure)';
}

/// Network failure types
abstract class NetworkFailure {
  final String message;

  const NetworkFailure({required this.message});

  /// Pattern matching helper
  T when<T>({
    required T Function(int statusCode, String message, List<ApiError>? errors) serverError,
    required T Function(String message) networkError,
    required T Function(String message) timeoutError,
    required T Function(String message) unauthorizedError,
    required T Function(String message) forbiddenError,
    required T Function(String message) notFoundError,
    required T Function(String message, List<ApiError> errors) validationError,
    required T Function(String message) unknownError,
  }) {
    if (this is ServerError) {
      final error = this as ServerError;
      return serverError(error.statusCode, error.message, error.errors);
    } else if (this is NetworkConnectionError) {
      return networkError(message);
    } else if (this is TimeoutError) {
      return timeoutError(message);
    } else if (this is UnauthorizedError) {
      return unauthorizedError(message);
    } else if (this is ForbiddenError) {
      return forbiddenError(message);
    } else if (this is NotFoundError) {
      return notFoundError(message);
    } else if (this is ValidationError) {
      final error = this as ValidationError;
      return validationError(error.message, error.errors);
    } else {
      return unknownError(message);
    }
  }

  @override
  String toString() => 'NetworkFailure(message: $message)';
}

class ServerError extends NetworkFailure {
  final int statusCode;
  final List<ApiError>? errors;

  const ServerError({
    required this.statusCode,
    required String message,
    this.errors,
  }) : super(message: message);

  @override
  String toString() => 'ServerError(statusCode: $statusCode, message: $message)';
}

class NetworkConnectionError extends NetworkFailure {
  const NetworkConnectionError({required String message}) : super(message: message);

  @override
  String toString() => 'NetworkConnectionError(message: $message)';
}

class TimeoutError extends NetworkFailure {
  const TimeoutError({required String message}) : super(message: message);

  @override
  String toString() => 'TimeoutError(message: $message)';
}

class UnauthorizedError extends NetworkFailure {
  const UnauthorizedError({required String message}) : super(message: message);

  @override
  String toString() => 'UnauthorizedError(message: $message)';
}

class ForbiddenError extends NetworkFailure {
  const ForbiddenError({required String message}) : super(message: message);

  @override
  String toString() => 'ForbiddenError(message: $message)';
}

class NotFoundError extends NetworkFailure {
  const NotFoundError({required String message}) : super(message: message);

  @override
  String toString() => 'NotFoundError(message: $message)';
}

class ValidationError extends NetworkFailure {
  final List<ApiError> errors;

  const ValidationError({
    required String message,
    required this.errors,
  }) : super(message: message);

  @override
  String toString() => 'ValidationError(message: $message, errors: $errors)';
}

class UnknownError extends NetworkFailure {
  const UnknownError({required String message}) : super(message: message);

  @override
  String toString() => 'UnknownError(message: $message)';
}