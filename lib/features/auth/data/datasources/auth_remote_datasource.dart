import 'package:base_flutter/core/utils/utils.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/services/api_service.dart';
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

class AuthRemoteDataSourceImpl extends BaseApiService implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required DioClient dioClient}) : super(dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return executeRequest(
      () => dioClient.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      ),
      (data) {
        final responseData = data as DataMap;

        // If the backend returns user data in a 'user' field
        if (responseData.containsKey('user')) {
          final userData = DataMap.from(responseData['user']);
          // Add token if it's returned separately
          if (responseData.containsKey('token')) {
            userData['token'] = responseData['token'];
          }
          if (responseData.containsKey('tokenExpiry')) {
            userData['tokenExpiry'] = responseData['tokenExpiry'];
          }
          return UserModel.fromJson(userData);
        }
        // If the backend returns everything in the root
        else {
          return UserModel.fromJson(responseData);
        }
      },
    );
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return executeRequest(
      () => dioClient.post(
        ApiConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      ),
      (data) {
        final responseData = data as Map<String, dynamic>;

        // If the backend returns user data in a 'user' field
        if (responseData.containsKey('user')) {
          final userData = Map<String, dynamic>.from(responseData['user']);
          // Add token if it's returned separately
          if (responseData.containsKey('token')) {
            userData['token'] = responseData['token'];
          }
          if (responseData.containsKey('tokenExpiry')) {
            userData['tokenExpiry'] = responseData['tokenExpiry'];
          }
          return UserModel.fromJson(userData);
        }
        // If the backend returns everything in the root
        else {
          return UserModel.fromJson(responseData);
        }
      },
    );
  }

  @override
  Future<void> logout() async {
    await executeRequest(
      () => dioClient.post(ApiConstants.logoutEndpoint),
      (_) {}, // No return value needed for logout
    );
  }

  @override
  Future<UserModel> refreshToken(String token) async {
    return executeRequest(
      () => dioClient.post(
        ApiConstants.refreshEndpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
      (data) {
        final responseData = data as Map<String, dynamic>;

        // If the backend returns user data in a 'user' field
        if (responseData.containsKey('user')) {
          final userData = Map<String, dynamic>.from(responseData['user']);
          // Add new token if it's returned separately
          if (responseData.containsKey('token')) {
            userData['token'] = responseData['token'];
          }
          if (responseData.containsKey('tokenExpiry')) {
            userData['tokenExpiry'] = responseData['tokenExpiry'];
          }
          return UserModel.fromJson(userData);
        }
        // If the backend returns everything in the root
        else {
          return UserModel.fromJson(responseData);
        }
      },
    );
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? avatarUrl,
  }) async {
    // For now, keeping this as mock since profile endpoints are not specified
    // When you have the actual endpoint, update this to use executeRequest
    return executeRequest(
      () => dioClient.put(
        '/user/profile', // Replace with actual endpoint when available
        data: {
          'name': name,
          'avatarUrl': avatarUrl,
        },
      ),
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await executeRequest(
      () => dioClient.post(
        '/auth/change-password', // Replace with actual endpoint when available
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      ),
      (_) {}, // No return value needed
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    await executeRequest(
      () => dioClient.post(
        '/auth/reset-password', // Replace with actual endpoint when available
        data: {
          'email': email,
        },
      ),
      (_) {}, // No return value needed
    );
  }
}