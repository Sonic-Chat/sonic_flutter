// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_friend_requests.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchFriendRequestsDto _$FetchFriendRequestsDtoFromJson(
        Map<String, dynamic> json) =>
    FetchFriendRequestsDto(
      status: $enumDecodeNullable(_$FriendStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$FetchFriendRequestsDtoToJson(
        FetchFriendRequestsDto instance) =>
    <String, dynamic>{
      'status': _$FriendStatusEnumMap[instance.status],
    };

const _$FriendStatusEnumMap = {
  FriendStatus.REQUESTED: 'REQUESTED',
  FriendStatus.ACCEPTED: 'ACCEPTED',
  FriendStatus.IGNORED: 'IGNORED',
  FriendStatus.REQUESTED_TO_YOU: 'REQUESTED_TO_YOU',
};
