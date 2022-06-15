// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageDto _$SendMessageDtoFromJson(Map<String, dynamic> json) =>
    SendMessageDto(
      authorization: json['authorization'] as String,
      message: json['message'] as String,
      chatId: json['chatId'] as String,
    );

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'message': instance.message,
      'chatId': instance.chatId,
    };
