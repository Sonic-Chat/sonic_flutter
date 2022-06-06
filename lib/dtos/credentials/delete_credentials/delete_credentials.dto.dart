import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/dtos/credentials/update_credentials.dto.dart';

part 'delete_credentials.dto.g.dart';

@JsonSerializable()
class DeleteCredentialsDto implements UpdateCredentialsDto {\

  @JsonKey(defaultValue: "")
  final String password;

  DeleteCredentialsDto({
    required this.password,
  });

  factory DeleteCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteCredentialsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteCredentialsDtoToJson(this);
}
