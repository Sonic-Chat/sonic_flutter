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
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.TEXT,
    );

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'type': _$MessageTypeEnumMap[instance.type],
      'message': instance.message,
      'chatId': instance.chatId,
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGE',
  MessageType.IMAGE_TEXT: 'IMAGE_TEXT',
};
