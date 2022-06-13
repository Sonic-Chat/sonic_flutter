import 'package:json_annotation/json_annotation.dart';

part 'fetch_friend_request.dto.g.dart';

@JsonSerializable()
class FetchFriendRequestDto {
  final String accountId;

  FetchFriendRequestDto({
    required this.accountId,
  });

  factory FetchFriendRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FetchFriendRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchFriendRequestDtoToJson(this);
}
