import 'package:json_annotation/json_annotation.dart';

part 'register_account.dto.g.dart';

@JsonSerializable()
class RegisterAccount {
  @JsonKey(defaultValue: "")
  final String email;

  @JsonKey(defaultValue: "")
  final String password;

  @JsonKey(defaultValue: "")
  final String fullName;

  @JsonKey(defaultValue: "")
  final String username;

  RegisterAccount({
    required this.email,
    required this.password,
    required this.fullName,
    required this.username,
  });

  factory RegisterAccount.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountToJson(this);
}
