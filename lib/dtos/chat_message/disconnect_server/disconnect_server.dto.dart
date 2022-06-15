import 'package:json_annotation/json_annotation.dart';

part 'disconnect_server.dto.g.dart';

@JsonSerializable()
class DisconnectServerDto {
  @JsonKey(defaultValue: '')
  final String authorization;

  DisconnectServerDto({
    required this.authorization,
  });

  factory DisconnectServerDto.fromJson(Map<String, dynamic> json) =>
      _$DisconnectServerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DisconnectServerDtoToJson(this);
}
