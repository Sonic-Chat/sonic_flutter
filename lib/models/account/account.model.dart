import 'package:json_annotation/json_annotation.dart';

part 'account.model.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(defaultValue: "")
  final String id;

  @JsonKey(defaultValue: "")
  final String imageUrl;

  @JsonKey(defaultValue: "")
  final String fullName;

  @JsonKey(defaultValue: "")
  final String status;

  final DateTime createdAt;
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
