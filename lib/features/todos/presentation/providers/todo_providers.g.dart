// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoRemoteDataSourceHash() =>
    r'10f103aa6cd7de9c9829c3554f317065c7115575';

/// Todo Remote DataSource Provider
///
/// Copied from [todoRemoteDataSource].
@ProviderFor(todoRemoteDataSource)
final todoRemoteDataSourceProvider =
    AutoDisposeProvider<TodoRemoteDataSource>.internal(
  todoRemoteDataSource,
  name: r'todoRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodoRemoteDataSourceRef = AutoDisposeProviderRef<TodoRemoteDataSource>;
String _$todoRepositoryHash() => r'6830b5ede91b11ac04d0a9430cb84a0f2a8d0905';

/// Todo Repository Provider
///
/// Copied from [todoRepository].
@ProviderFor(todoRepository)
final todoRepositoryProvider = AutoDisposeProvider<TodoRepository>.internal(
  todoRepository,
  name: r'todoRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodoRepositoryRef = AutoDisposeProviderRef<TodoRepository>;
String _$filteredTodosHash() => r'b814fe45ea117a5f71e9a223c39c2cfb5fcff61a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Filtered Todos Provider - Filter todos by search query
///
/// Copied from [filteredTodos].
@ProviderFor(filteredTodos)
const filteredTodosProvider = FilteredTodosFamily();

/// Filtered Todos Provider - Filter todos by search query
///
/// Copied from [filteredTodos].
class FilteredTodosFamily extends Family<List<Todo>> {
  /// Filtered Todos Provider - Filter todos by search query
  ///
  /// Copied from [filteredTodos].
  const FilteredTodosFamily();

  /// Filtered Todos Provider - Filter todos by search query
  ///
  /// Copied from [filteredTodos].
  FilteredTodosProvider call(
    String searchQuery,
  ) {
    return FilteredTodosProvider(
      searchQuery,
    );
  }

  @override
  FilteredTodosProvider getProviderOverride(
    covariant FilteredTodosProvider provider,
  ) {
    return call(
      provider.searchQuery,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredTodosProvider';
}

/// Filtered Todos Provider - Filter todos by search query
///
/// Copied from [filteredTodos].
class FilteredTodosProvider extends AutoDisposeProvider<List<Todo>> {
  /// Filtered Todos Provider - Filter todos by search query
  ///
  /// Copied from [filteredTodos].
  FilteredTodosProvider(
    String searchQuery,
  ) : this._internal(
          (ref) => filteredTodos(
            ref as FilteredTodosRef,
            searchQuery,
          ),
          from: filteredTodosProvider,
          name: r'filteredTodosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredTodosHash,
          dependencies: FilteredTodosFamily._dependencies,
          allTransitiveDependencies:
              FilteredTodosFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  FilteredTodosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String searchQuery;

  @override
  Override overrideWith(
    List<Todo> Function(FilteredTodosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredTodosProvider._internal(
        (ref) => create(ref as FilteredTodosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Todo>> createElement() {
    return _FilteredTodosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTodosProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredTodosRef on AutoDisposeProviderRef<List<Todo>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _FilteredTodosProviderElement
    extends AutoDisposeProviderElement<List<Todo>> with FilteredTodosRef {
  _FilteredTodosProviderElement(super.provider);

  @override
  String get searchQuery => (origin as FilteredTodosProvider).searchQuery;
}

String _$completedTodosCountHash() =>
    r'9905f3fbd8c17b4cd4edde44d34b36e7b4d1f582';

/// Completed Todos Count Provider
///
/// Copied from [completedTodosCount].
@ProviderFor(completedTodosCount)
final completedTodosCountProvider = AutoDisposeProvider<int>.internal(
  completedTodosCount,
  name: r'completedTodosCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedTodosCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedTodosCountRef = AutoDisposeProviderRef<int>;
String _$pendingTodosCountHash() => r'f302d2335102b191a27f5ad628d01f9d1cffea05';

/// Pending Todos Count Provider
///
/// Copied from [pendingTodosCount].
@ProviderFor(pendingTodosCount)
final pendingTodosCountProvider = AutoDisposeProvider<int>.internal(
  pendingTodosCount,
  name: r'pendingTodosCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingTodosCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingTodosCountRef = AutoDisposeProviderRef<int>;
String _$todosHash() => r'2ce152307a44fa5d6173831856732cfe2d082c36';

/// Todos State Provider - Fetches and manages todos list
///
/// Copied from [Todos].
@ProviderFor(Todos)
final todosProvider =
    AutoDisposeAsyncNotifierProvider<Todos, List<Todo>>.internal(
  Todos.new,
  name: r'todosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Todos = AutoDisposeAsyncNotifier<List<Todo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
