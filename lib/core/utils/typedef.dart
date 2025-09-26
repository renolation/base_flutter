import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

/// Common type definitions used throughout the application

/// Result type for operations that can fail
typedef Result<T> = Either<Failure, T>;

/// Async result type
typedef AsyncResult<T> = Future<Result<T>>;

/// Data map type for JSON serialization
typedef DataMap = Map<String, dynamic>;

/// Data list type for JSON serialization
typedef DataList = List<DataMap>;