// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_account.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAccount _$RegisterAccountFromJson(Map<String, dynamic> json) =>
    RegisterAccount(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );

Map<String, dynamic> _$RegisterAccountToJson(RegisterAccount instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'username': instance.username,
    };
