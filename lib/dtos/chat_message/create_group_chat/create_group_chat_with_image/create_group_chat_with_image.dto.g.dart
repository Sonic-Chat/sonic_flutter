// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_chat_with_image.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGroupChatWithImageDto _$CreateGroupChatWithImageDtoFromJson(
        Map<String, dynamic> json) =>
    CreateGroupChatWithImageDto(
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$CreateGroupChatWithImageDtoToJson(
        CreateGroupChatWithImageDto instance) =>
    <String, dynamic>{
      'participants': instance.participants,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };
