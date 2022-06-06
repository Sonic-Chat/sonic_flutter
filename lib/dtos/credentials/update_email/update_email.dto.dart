import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/dtos/credentials/update_credentials.dto.dart';

part 'update_email.dto.g.dart';

@JsonSerializable()
class UpdateEmailDto extends UpdateCredentialsDto {
  @JsonKey(defaultValue: "")
  final String email;

  @JsonKey(defaultValue: "")
  final String password;

  UpdateEmailDto({
    required this.email,
    required this.password,
  });

  factory UpdateEmailDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateEmailDtoToJson(this);
}
