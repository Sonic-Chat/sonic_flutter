// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_seen.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkSeenDto _$MarkSeenDtoFromJson(Map<String, dynamic> json) => MarkSeenDto(
      authorization: json['authorization'] as String,
      chatId: json['chatId'] as String,
    );

Map<String, dynamic> _$MarkSeenDtoToJson(MarkSeenDto instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
      'chatId': instance.chatId,
    };
