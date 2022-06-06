// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_email.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateEmailDto _$UpdateEmailDtoFromJson(Map<String, dynamic> json) =>
    UpdateEmailDto(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$UpdateEmailDtoToJson(UpdateEmailDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
