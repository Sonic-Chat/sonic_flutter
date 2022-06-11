import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';

part 'fetch_friend_requests.dto.g.dart';

@JsonSerializable()
class FetchFriendRequestsDto {
  final FriendStatus? status;

  FetchFriendRequestsDto({
    required this.status,
  });

  factory FetchFriendRequestsDto.fromJson(Map<String, dynamic> json) =>
      _$FetchFriendRequestsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchFriendRequestsDtoToJson(this);
}
