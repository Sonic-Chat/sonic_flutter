import 'package:json_annotation/json_annotation.dart';

part 'mark_delivered.dto.g.dart';

@JsonSerializable()
class MarkDeliveredDto {
  final String chatId;

  MarkDeliveredDto({
    required this.chatId,
  });

  factory MarkDeliveredDto.fromJson(Map<String, dynamic> json) =>
      _$MarkDeliveredDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MarkDeliveredDtoToJson(this);
}
