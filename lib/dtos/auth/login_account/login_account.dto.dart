import 'package:json_annotation/json_annotation.dart';

part 'login_account.dto.g.dart';

@JsonSerializable()
class LoginAccountDto {
  @JsonKey(defaultValue: "")
  final String username;

  @JsonKey(defaultValue: "")
  final String password;

  LoginAccountDto({
    required this.username,
    required this.password,
  });

  factory LoginAccountDto.fromJson(Map<String, dynamic> json) =>
      _$LoginAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginAccountDtoToJson(this);
}
