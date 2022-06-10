import 'package:json_annotation/json_annotation.dart';

part 'fetch_credentials.dto.g.dart';

@JsonSerializable()
class FetchCredentialsDto {
  @JsonKey(defaultValue: "")
  final String accountId;

  FetchCredentialsDto({
    required this.accountId,
  });

  factory FetchCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$FetchCredentialsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchCredentialsDtoToJson(this);
}
