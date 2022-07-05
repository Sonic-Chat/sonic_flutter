// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_group_chat.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateGroupChatDto _$UpdateGroupChatDtoFromJson(Map<String, dynamic> json) =>
    UpdateGroupChatDto(
      chatId: json['chatId'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$UpdateGroupChatDtoToJson(UpdateGroupChatDto instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'participants': instance.participants,
      'name': instance.name,
    };
