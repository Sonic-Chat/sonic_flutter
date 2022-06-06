import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/dtos/account/update_account/update_account.dto.dart';

part 'update_account_with_image_uri.dto.g.dart';

@JsonSerializable()
class UpdateAccountWithImageUriDto extends UpdateAccountDto {
  @override
  @JsonKey(defaultValue: "")
  final String imageUrl;

  UpdateAccountWithImageUriDto({
    required String fullName,
    required this.imageUrl,
    required String status,
  }) : super(
          fullName: fullName,
          status: status,
        );

  factory UpdateAccountWithImageUriDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccountWithImageUriDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAccountWithImageUriDtoToJson(this);
}
