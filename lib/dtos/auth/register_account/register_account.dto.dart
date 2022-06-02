import 'package:json_annotation/json_annotation.dart';

part 'register_account.dto.g.dart';

@JsonSerializable()
class RegisterAccountDto {
  @JsonKey(defaultValue: "")
  final String email;

  @JsonKey(defaultValue: "")
  final String password;

  @JsonKey(defaultValue: "")
  final String fullName;

  @JsonKey(defaultValue: "")
  final String username;

  RegisterAccountDto({
    required this.email,
    required this.password,
    required this.fullName,
    required this.username,
  });

  factory RegisterAccountDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountDtoToJson(this);
}
