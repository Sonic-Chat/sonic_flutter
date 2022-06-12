import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';

part 'update_friend_request.dto.g.dart';

@JsonSerializable()
class UpdateFriendRequestDto {
  final String id;
  final FriendStatus status;

  UpdateFriendRequestDto({
    required this.id,
    required this.status,
  });

  factory UpdateFriendRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateFriendRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFriendRequestDtoToJson(this);
}
