import 'package:equatable/equatable.dart';

/// Base failure class for error handling in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Server failure
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(
    super.message, {
    this.statusCode,
    super.code,
  });

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Storage failure
class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code});
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}