// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_image.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendImageDto _$SendImageDtoFromJson(Map<String, dynamic> json) => SendImageDto(
      authorization: json['authorization'] as String,
      firebaseId: json['firebaseId'] as String,
      imageUrl: json['imageUrl'] as String,
      chatId: json['chatId'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.IMAGE,
    );

Map<String, dynamic> _$SendImageDtoToJson(SendImageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'type': _$MessageTypeEnumMap[instance.type],
      'firebaseId': instance.firebaseId,
      'imageUrl': instance.imageUrl,
      'chatId': instance.chatId,
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGE',
  MessageType.IMAGE_TEXT: 'IMAGE_TEXT',
};
