import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    required String token,
    DateTime? tokenExpiry,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to domain entity
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
        token: token,
        tokenExpiry: tokenExpiry,
      );

  /// Create from domain entity
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        avatarUrl: user.avatarUrl,
        token: user.token,
        tokenExpiry: user.tokenExpiry,
      );
}