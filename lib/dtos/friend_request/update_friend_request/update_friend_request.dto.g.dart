// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_friend_request.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFriendRequestDto _$UpdateFriendRequestDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateFriendRequestDto(
      id: json['id'] as String,
      status: $enumDecode(_$FriendStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UpdateFriendRequestDtoToJson(
        UpdateFriendRequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$FriendStatusEnumMap[instance.status],
    };

const _$FriendStatusEnumMap = {
  FriendStatus.REQUESTED: 'REQUESTED',
  FriendStatus.ACCEPTED: 'ACCEPTED',
  FriendStatus.IGNORED: 'IGNORED',
};
