import 'package:json_annotation/json_annotation.dart';

part 'save_token.dto.g.dart';

@JsonSerializable()
class SaveTokenDto {
  final String token;

  SaveTokenDto({
    required this.token,
  });

  factory SaveTokenDto.fromJson(Map<String, dynamic> json) =>
      _$SaveTokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SaveTokenDtoToJson(this);
}
