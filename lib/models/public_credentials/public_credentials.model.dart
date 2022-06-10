import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/models/account/account.model.dart';

part 'public_credentials.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class PublicCredentials {
  @JsonKey(defaultValue: '')
  @HiveField(0)
  final String id;

  @JsonKey(defaultValue: '')
  @HiveField(1)
  final String username;

  @HiveField(2)
  final Account account;

  PublicCredentials({
    required this.id,
    required this.username,
    required this.account,
  });

  factory PublicCredentials.fromJson(Map<String, dynamic> json) =>
      _$PublicCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicCredentialsToJson(this);
}
