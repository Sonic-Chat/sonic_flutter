import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';

part 'send_message.dto.g.dart';

@JsonSerializable()
class SendMessageDto {
  final String authorization;
  final MessageType type;
  final String message;
  final String chatId;

  SendMessageDto({
    required this.authorization,
    required this.message,
    required this.chatId,
    this.type = MessageType.TEXT,
  });

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);
}
