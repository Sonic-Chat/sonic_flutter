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
    );

Map<String, dynamic> _$SendMessageImageDtoToJson(
        SendMessageImageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'message': instance.message,
      'firebaseId': instance.firebaseId,
      'imageUrl': instance.imageUrl,
      'chatId': instance.chatId,
    };
