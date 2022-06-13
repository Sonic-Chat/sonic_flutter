import 'package:json_annotation/json_annotation.dart';

part 'delete_friend_request.dto.g.dart';

@JsonSerializable()
class DeleteFriendRequestDto {
  final String id;

  DeleteFriendRequestDto({
    required this.id,
  });

  factory DeleteFriendRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteFriendRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteFriendRequestDtoToJson(this);
}
