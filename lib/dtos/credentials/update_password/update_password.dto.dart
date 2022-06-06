import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/dtos/credentials/update_credentials.dto.dart';

part 'update_password.dto.g.dart';

@JsonSerializable()
class UpdatePasswordDto extends UpdateCredentialsDto {
  @JsonKey(defaultValue: "")
  final String oldPassword;

  @JsonKey(defaultValue: "")
  final String newPassword;

  UpdatePasswordDto({
    required this.oldPassword,
    required this.newPassword,
  });

  factory UpdatePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordDtoToJson(this);
}
