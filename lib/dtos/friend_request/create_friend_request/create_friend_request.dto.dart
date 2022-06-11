import 'package:json_annotation/json_annotation.dart';

part 'create_friend_request.dto.g.dart';

@JsonSerializable()
class CreateFriendRequestDto {
  final String userId;

  CreateFriendRequestDto({
    required this.userId,
  });

  factory CreateFriendRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateFriendRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFriendRequestDtoToJson(this);
}
