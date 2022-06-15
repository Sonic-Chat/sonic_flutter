import 'package:json_annotation/json_annotation.dart';

part 'update_message.dto.g.dart';

@JsonSerializable()
class UpdateMessageDto {
  final String authorization;
  final String message;
  final String messageId;

  UpdateMessageDto({
    required this.authorization,
    required this.message,
    required this.messageId,
  });

  factory UpdateMessageDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMessageDtoToJson(this);
}
