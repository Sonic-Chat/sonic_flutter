// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_group_chat_with_image.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateGroupChatWithImageDto _$UpdateGroupChatWithImageDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateGroupChatWithImageDto(
      chatId: json['chatId'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$UpdateGroupChatWithImageDtoToJson(
        UpdateGroupChatWithImageDto instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'participants': instance.participants,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };
