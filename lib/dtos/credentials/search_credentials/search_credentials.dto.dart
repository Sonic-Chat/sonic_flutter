import 'package:json_annotation/json_annotation.dart';

part 'search_credentials.dto.g.dart';

@JsonSerializable()
class SearchCredentialsDto {
  @JsonKey(defaultValue: "")
  final String search;

  SearchCredentialsDto({
    required this.search,
  });

  factory SearchCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$SearchCredentialsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchCredentialsDtoToJson(this);
}
