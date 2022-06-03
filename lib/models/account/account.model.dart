import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Account {

  @HiveField(0, defaultValue: "")
  @JsonKey(defaultValue: "")
  final String id;

  @HiveField(1, defaultValue: "")
  @JsonKey(defaultValue: "")
  final String imageUrl;

  @HiveField(2, defaultValue: "")
  @JsonKey(defaultValue: "")
  final String fullName;

  @HiveField(3, defaultValue: "")
  @JsonKey(defaultValue: "")
  final String status;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  Account({
    required this.id,
    required this.imageUrl,
    required this.fullName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
