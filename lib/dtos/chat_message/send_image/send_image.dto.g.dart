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
    );

Map<String, dynamic> _$SendImageDtoToJson(SendImageDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'firebaseId': instance.firebaseId,
      'imageUrl': instance.imageUrl,
      'chatId': instance.chatId,
    };
