import 'package:json_annotation/json_annotation.dart';

part 'delete_message.dto.g.dart';

@JsonSerializable()
class DeleteMessageDto {
  final String authorization;
  final String messageId;

  DeleteMessageDto({
    required this.authorization,
    required this.messageId,
  });

  factory DeleteMessageDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMessageDtoToJson(this);
}
