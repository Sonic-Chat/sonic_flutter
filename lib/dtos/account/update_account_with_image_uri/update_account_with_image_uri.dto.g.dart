// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_account_with_image_uri.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAccountWithImageUriDto _$UpdateAccountWithImageUriDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateAccountWithImageUriDto(
      fullName: json['fullName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$UpdateAccountWithImageUriDtoToJson(
        UpdateAccountWithImageUriDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'status': instance.status,
      'imageUrl': instance.imageUrl,
    };
