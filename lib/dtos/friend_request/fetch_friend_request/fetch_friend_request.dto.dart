import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';

part 'fetch_friend_request.dto.g.dart';

@JsonSerializable()
class FetchFriendRequestDto {
  final FriendStatus? status;

  FetchFriendRequestDto({
    required this.status,
  });

  factory FetchFriendRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FetchFriendRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchFriendRequestDtoToJson(this);
}
