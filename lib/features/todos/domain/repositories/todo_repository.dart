import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, void>> refreshTodos();
}
