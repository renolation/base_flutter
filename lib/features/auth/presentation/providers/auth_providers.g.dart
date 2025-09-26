// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDataSourceHash() =>
    r'e1e2164defcfc3905e9fb8e75e346817a6e0bf73';

/// See also [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider =
    AutoDisposeProvider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRemoteDataSourceRef = AutoDisposeProviderRef<AuthRemoteDataSource>;
String _$authLocalDataSourceHash() =>
    r'dfab2fdd71de815f93c16ab9e234bd2d0885d2f4';

/// See also [authLocalDataSource].
@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider =
    AutoDisposeProvider<AuthLocalDataSource>.internal(
  authLocalDataSource,
  name: r'authLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthLocalDataSourceRef = AutoDisposeProviderRef<AuthLocalDataSource>;
String _$authRepositoryHash() => r'8ce22ed16336f42a50e8266fbafbdbd7db71d613';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$loginUseCaseHash() => r'cbfd4200f40c132516f20f942ae9d825a31e2515';

/// See also [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = AutoDisposeProvider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoginUseCaseRef = AutoDisposeProviderRef<LoginUseCase>;
String _$logoutUseCaseHash() => r'67224f00aebb158eab2aba2c4398e98150dd958c';

/// See also [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = AutoDisposeProvider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LogoutUseCaseRef = AutoDisposeProviderRef<LogoutUseCase>;
String _$getCurrentUserUseCaseHash() =>
    r'1e9d6222283b80c2b6fc6ed8c89f4130614c0a11';

/// See also [getCurrentUserUseCase].
@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider =
    AutoDisposeProvider<GetCurrentUserUseCase>.internal(
  getCurrentUserUseCase,
  name: r'getCurrentUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCurrentUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetCurrentUserUseCaseRef
    = AutoDisposeProviderRef<GetCurrentUserUseCase>;
String _$currentUserHash() => r'a5dbfda090aa4a2784b934352ff00cf3c751332b';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = AutoDisposeProviderRef<User?>;
String _$isAuthenticatedHash() => r'0f8559d2c47c9554b3c1b9643ed0c2bf1cb18727';

/// See also [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$authNotifierHash() => r'e97041b6776589adb6e6d424d2ebbb7bc837cb5b';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
