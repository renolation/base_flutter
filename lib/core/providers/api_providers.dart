import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';
import 'network_providers.dart';

/// Provider for ExampleApiService
final exampleApiServiceProvider = Provider<ExampleApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ExampleApiService(dioClient);
});

/// Provider for AuthApiService
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthApiService(dioClient);
});

/// Provider to check authentication status
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authApiServiceProvider);
  return await authService.isAuthenticated();
});

/// Example provider for user profile data
final userProfileProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final apiService = ref.watch(exampleApiServiceProvider);
  return await apiService.getUserProfile(userId);
});

/// Example provider for posts list with pagination
final postsProvider = FutureProvider.family<List<Map<String, dynamic>>, ({int page, int limit})>((ref, params) async {
  final apiService = ref.watch(exampleApiServiceProvider);
  return await apiService.getPosts(page: params.page, limit: params.limit);
});