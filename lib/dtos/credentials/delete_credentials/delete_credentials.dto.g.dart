// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_credentials.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCredentialsDto _$DeleteCredentialsDtoFromJson(
        Map<String, dynamic> json) =>
    DeleteCredentialsDto(
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$DeleteCredentialsDtoToJson(
        DeleteCredentialsDto instance) =>
    <String, dynamic>{
      'password': instance.password,
    };
