// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      token: json['token'] as String,
      tokenExpiry: json['tokenExpiry'] == null
          ? null
          : DateTime.parse(json['tokenExpiry'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'token': instance.token,
      'tokenExpiry': instance.tokenExpiry?.toIso8601String(),
    };
