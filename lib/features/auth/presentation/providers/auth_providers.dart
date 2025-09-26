import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/providers/network_providers.dart';
import '../../../../shared/presentation/providers/app_providers.dart' hide secureStorageProvider;
import '../../../../shared/domain/usecases/usecase.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

part 'auth_providers.g.dart';

// Data sources
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSourceImpl(dioClient: dioClient);
}

@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(secureStorage: secureStorage);
}

// Repository
@riverpod
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
}

// Use cases
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

// Auth state notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Check for cached user on startup
    _checkAuthStatus();
    return const AuthState.initial();
  }

  Future<void> _checkAuthStatus() async {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    final result = await getCurrentUser(const NoParams());

    result.fold(
      (failure) => state = AuthState.unauthenticated(failure.message),
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final loginUseCase = ref.read(loginUseCaseProvider);
    final params = LoginParams(email: email, password: password);
    final result = await loginUseCase(params);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase(const NoParams());

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  void clearError() {
    if (state is AuthStateError) {
      state = const AuthState.unauthenticated();
    }
  }
}

// Current user provider
@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
}

// Is authenticated provider
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
}