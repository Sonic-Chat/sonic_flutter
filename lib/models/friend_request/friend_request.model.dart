import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';

part 'friend_request.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class FriendRequest {
  @JsonKey(defaultValue: '')
  @HiveField(0)
  final String id;

  @JsonKey(defaultValue: FriendStatus.REQUESTED)
  @HiveField(1)
  final FriendStatus status;

  @JsonKey(defaultValue: '')
  @HiveField(2)
  final String requestedById;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @JsonKey(defaultValue: [])
  @HiveField(5)
  final List<Account> accounts;

  FriendRequest({
    required this.id,
    required this.status,
    required this.requestedById,
    required this.createdAt,
    required this.updatedAt,
    required this.accounts,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}
