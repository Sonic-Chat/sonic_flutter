import 'package:json_annotation/json_annotation.dart';

part 'sync_message.dto.g.dart';

@JsonSerializable()
class SyncMessageDto {
  @JsonKey(defaultValue: '')
  final String authorization;

  SyncMessageDto({
    required this.authorization,
  });

  factory SyncMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SyncMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SyncMessageDtoToJson(this);
}
