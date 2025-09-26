import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache user data and token
      await localDataSource.cacheUser(userModel);
      await localDataSource.cacheToken(userModel.token);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final userModel = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      // Cache user data and token
      await localDataSource.cacheUser(userModel);
      await localDataSource.cacheToken(userModel.token);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear local cache first
      await localDataSource.clearCache();

      // If online, notify server
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        // Check if token is still valid
        final user = cachedUser.toEntity();
        if (user.isTokenValid) {
          return Right(user);
        } else {
          // Token expired, try to refresh
          if (await networkInfo.isConnected) {
            return await refreshToken();
          }
        }
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final user = cachedUser.toEntity();
        return user.isTokenValid;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final token = await localDataSource.getCachedToken();
      if (token == null) {
        return const Left(AuthFailure('No token available'));
      }

      final userModel = await remoteDataSource.refreshToken(token);

      // Update cached user and token
      await localDataSource.cacheUser(userModel);
      await localDataSource.cacheToken(userModel.token);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      // If refresh fails, clear cache
      await localDataSource.clearCache();
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? avatarUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final userModel = await remoteDataSource.updateProfile(
        name: name,
        avatarUrl: avatarUrl,
      );

      // Update cached user
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.resetPassword(email: email);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}