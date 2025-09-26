import '../../../core/utils/typedef.dart';

/// Base usecase class for implementing clean architecture use cases
abstract class UseCase<T, Params> {
  const UseCase();

  /// Execute the use case with given parameters
  AsyncResult<T> call(Params params);
}

/// Use case that doesn't require any parameters
abstract class UseCaseWithoutParams<T> {
  const UseCaseWithoutParams();

  /// Execute the use case without parameters
  AsyncResult<T> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}