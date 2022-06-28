// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_chat.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGroupChatDto _$CreateGroupChatDtoFromJson(Map<String, dynamic> json) =>
    CreateGroupChatDto(
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateGroupChatDtoToJson(CreateGroupChatDto instance) =>
    <String, dynamic>{
      'participants': instance.participants,
      'name': instance.name,
    };
