import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/network_providers.dart';
import '../../data/datasources/todo_remote_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

part 'todo_providers.g.dart';

/// Todo Remote DataSource Provider
@riverpod
TodoRemoteDataSource todoRemoteDataSource(TodoRemoteDataSourceRef ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TodoRemoteDataSourceImpl(dioClient: dioClient);
}

/// Todo Repository Provider
@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  final remoteDataSource = ref.watch(todoRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return TodoRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
}

/// Todos State Provider - Fetches and manages todos list
@riverpod
class Todos extends _$Todos {
  @override
  Future<List<Todo>> build() async {
    // Auto-fetch todos when provider is first accessed
    return _fetchTodos();
  }

  Future<List<Todo>> _fetchTodos() async {
    final repository = ref.read(todoRepositoryProvider);
    final result = await repository.getTodos();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (todos) => todos,
    );
  }

  /// Refresh todos from API
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTodos());
  }

  /// Toggle todo completion status (local only for now)
  void toggleTodo(int id) {
    state.whenData((todos) {
      final updatedTodos = todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList();

      state = AsyncValue.data(updatedTodos);
    });
  }
}

/// Filtered Todos Provider - Filter todos by search query
@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref, String searchQuery) {
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.when(
    data: (todos) {
      if (searchQuery.isEmpty) {
        return todos;
      }
      return todos.where((todo) {
        return todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Completed Todos Count Provider
@riverpod
int completedTodosCount(CompletedTodosCountRef ref) {
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.when(
    data: (todos) => todos.where((todo) => todo.completed).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Pending Todos Count Provider
@riverpod
int pendingTodosCount(PendingTodosCountRef ref) {
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.when(
    data: (todos) => todos.where((todo) => !todo.completed).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
