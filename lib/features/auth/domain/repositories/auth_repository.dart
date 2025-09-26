import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Auth repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Refresh token
  Future<Either<Failure, User>> refreshToken();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? avatarUrl,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// Reset password
  Future<Either<Failure, void>> resetPassword({
    required String email,
  });
}