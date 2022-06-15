// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_message.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMessageDto _$UpdateMessageDtoFromJson(Map<String, dynamic> json) =>
    UpdateMessageDto(
      authorization: json['authorization'] as String,
      message: json['message'] as String,
      messageId: json['messageId'] as String,
    );

Map<String, dynamic> _$UpdateMessageDtoToJson(UpdateMessageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'message': instance.message,
      'messageId': instance.messageId,
    };
