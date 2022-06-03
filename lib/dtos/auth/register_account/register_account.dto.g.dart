// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_account.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAccountDto _$RegisterAccountDtoFromJson(Map<String, dynamic> json) =>
    RegisterAccountDto(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      username: json['username'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );

Map<String, dynamic> _$RegisterAccountDtoToJson(RegisterAccountDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'username': instance.username,
      'imageUrl': instance.imageUrl,
    };
