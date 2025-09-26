import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  static const String userKey = 'CACHED_USER';
  static const String tokenKey = 'AUTH_TOKEN';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await secureStorage.write(key: userKey, value: userJson);
    } catch (e) {
      throw CacheException('Failed to cache user');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await secureStorage.read(key: userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: userKey);
      await secureStorage.delete(key: tokenKey);
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await secureStorage.write(key: tokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to cache token');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return await secureStorage.read(key: tokenKey);
    } catch (e) {
      throw CacheException('Failed to get cached token');
    }
  }
}