// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_friend_request.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchFriendRequestDto _$FetchFriendRequestDtoFromJson(
        Map<String, dynamic> json) =>
    FetchFriendRequestDto(
      status: $enumDecodeNullable(_$FriendStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$FetchFriendRequestDtoToJson(
        FetchFriendRequestDto instance) =>
    <String, dynamic>{
      'status': _$FriendStatusEnumMap[instance.status],
    };

const _$FriendStatusEnumMap = {
  FriendStatus.REQUESTED: 'REQUESTED',
  FriendStatus.ACCEPTED: 'ACCEPTED',
  FriendStatus.IGNORED: 'IGNORED',
};
