import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/message/image/image.model.dart';

part 'message.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class Message {
  @JsonKey(defaultValue: '')
  @HiveField(0, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: MessageType.TEXT)
  @HiveField(1, defaultValue: MessageType.TEXT)
  final MessageType type;

  @JsonKey(defaultValue: null)
  @HiveField(2, defaultValue: null)
  final String? message;

  @HiveField(3)
  final Account sentBy;

  @JsonKey(defaultValue: null)
  @HiveField(4, defaultValue: null)
  final Image? image;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.type,
    required this.message,
    required this.sentBy,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
