// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_image.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageImageDto _$SendMessageImageDtoFromJson(Map<String, dynamic> json) =>
    SendMessageImageDto(
      authorization: json['authorization'] as String,
      message: json['message'] as String,
      chatId: json['chatId'] as String,
      firebaseId: json['firebaseId'] as String,
      imageUrl: json['imageUrl'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.IMAGE_TEXT,
    );

Map<String, dynamic> _$SendMessageImageDtoToJson(
        SendMessageImageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'type': _$MessageTypeEnumMap[instance.type],
      'message': instance.message,
      'firebaseId': instance.firebaseId,
      'imageUrl': instance.imageUrl,
      'chatId': instance.chatId,
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGE',
  MessageType.IMAGE_TEXT: 'IMAGE_TEXT',
};
