import 'package:json_annotation/json_annotation.dart';

part 'update_account.dto.g.dart';

@JsonSerializable()
class UpdateAccountDto {
  @JsonKey(defaultValue: "")
  final String fullName;

  @JsonKey(defaultValue: "")
  final String status;

  UpdateAccountDto({
    required this.fullName,
    required this.status,
  });

  factory UpdateAccountDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAccountDtoToJson(this);
}
