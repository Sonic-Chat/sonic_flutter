// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_message.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteMessageDto _$DeleteMessageDtoFromJson(Map<String, dynamic> json) =>
    DeleteMessageDto(
      authorization: json['authorization'] as String,
      messageId: json['messageId'] as String,
    );

Map<String, dynamic> _$DeleteMessageDtoToJson(DeleteMessageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'messageId': instance.messageId,
    };
