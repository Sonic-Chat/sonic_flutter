import 'package:json_annotation/json_annotation.dart';

part 'connect_server.dto.g.dart';

@JsonSerializable()
class ConnectServerDto {
  @JsonKey(defaultValue: '')
  final String authorization;

  ConnectServerDto({
    required this.authorization,
  });

  factory ConnectServerDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectServerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectServerDtoToJson(this);
}
