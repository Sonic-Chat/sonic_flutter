// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_account.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAccountDto _$LoginAccountDtoFromJson(Map<String, dynamic> json) =>
    LoginAccountDto(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$LoginAccountDtoToJson(LoginAccountDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
