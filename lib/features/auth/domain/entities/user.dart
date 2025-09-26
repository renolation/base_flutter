import 'package:equatable/equatable.dart';

/// User entity representing authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String token;
  final DateTime? tokenExpiry;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.token,
    this.tokenExpiry,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, token, tokenExpiry];

  bool get isTokenValid {
    if (tokenExpiry == null) return true;
    return tokenExpiry!.isAfter(DateTime.now());
  }
}