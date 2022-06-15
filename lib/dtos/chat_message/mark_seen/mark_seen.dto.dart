import 'package:json_annotation/json_annotation.dart';

part 'mark_seen.dto.g.dart';

@JsonSerializable()
class MarkSeenDto {
  final String authorization;
  final String chatId;

  MarkSeenDto({
    required this.authorization,
    required this.chatId,
  });

  factory MarkSeenDto.fromJson(Map<String, dynamic> json) =>
      _$MarkSeenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MarkSeenDtoToJson(this);
}
