import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';

part 'chat.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class Chat {

  @JsonKey(defaultValue: '')
  @HiveField(0, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: [])
  @HiveField(1, defaultValue: [])
  final List<Message> messages;

  @JsonKey(defaultValue: [])
  @HiveField(2, defaultValue: [])
  final List<Account> participants;

  @JsonKey(defaultValue: [])
  @HiveField(3, defaultValue: [])
  final List<Account> delivered;

  @JsonKey(defaultValue: [])
  @HiveField(4, defaultValue: [])
  final List<Account> seen;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.messages,
    required this.participants,
    required this.delivered,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) =>
      _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
