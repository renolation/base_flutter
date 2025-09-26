import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<UserModel> refreshToken(String token);

  Future<UserModel> updateProfile({
    required String name,
    String? avatarUrl,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> resetPassword({
    required String email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Using JSONPlaceholder as a mock API
      // In real app, this would be your actual auth endpoint
      final response = await dioClient.dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Mock validation - accept any email/password for demo
      // In real app, the server would validate credentials
      if (email.isEmpty || password.isEmpty) {
        throw const ServerException('Invalid credentials');
      }

      // Mock response for demonstration
      // In real app, parse actual API response
      final mockUser = {
        'id': '1',
        'email': email,
        'name': email.split('@').first,
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'tokenExpiry': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      return UserModel.fromJson(mockUser);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Invalid credentials');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('User not found');
      } else {
        throw ServerException(e.message ?? 'Login failed');
      }
    } catch (e) {
      if (e.toString().contains('Invalid credentials')) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Mock API call
      final response = await dioClient.dio.post(
        'https://jsonplaceholder.typicode.com/users',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      // Mock response
      final mockUser = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': email,
        'name': name,
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'tokenExpiry': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      return UserModel.fromJson(mockUser);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const ServerException('Email already exists');
      } else {
        throw ServerException(e.message ?? 'Registration failed');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Mock API call
      await dioClient.dio.post('https://jsonplaceholder.typicode.com/posts');
      // In real app, you might call a logout endpoint to invalidate token
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> refreshToken(String token) async {
    try {
      // Mock API call
      final response = await dioClient.dio.post(
        'https://jsonplaceholder.typicode.com/users',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // Mock response
      final mockUser = {
        'id': '1',
        'email': 'user@example.com',
        'name': 'User',
        'token': 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}',
        'tokenExpiry': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      return UserModel.fromJson(mockUser);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? avatarUrl,
  }) async {
    try {
      // Mock API call
      final response = await dioClient.dio.put(
        'https://jsonplaceholder.typicode.com/users/1',
        data: {
          'name': name,
          'avatarUrl': avatarUrl,
        },
      );

      // Mock response
      final mockUser = {
        'id': '1',
        'email': 'user@example.com',
        'name': name,
        'avatarUrl': avatarUrl,
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'tokenExpiry': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      return UserModel.fromJson(mockUser);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Mock API call
      await dioClient.dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      // Mock API call
      await dioClient.dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {
          'email': email,
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}