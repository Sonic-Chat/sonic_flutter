// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_account.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAccountDto _$UpdateAccountDtoFromJson(Map<String, dynamic> json) =>
    UpdateAccountDto(
      fullName: json['fullName'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$UpdateAccountDtoToJson(UpdateAccountDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'status': instance.status,
    };
