import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';

part 'send_message_image.dto.g.dart';

@JsonSerializable()
class SendMessageImageDto {
  final String authorization;
  final MessageType type;
  final String message;
  final String firebaseId;
  final String imageUrl;
  final String chatId;

  SendMessageImageDto({
    required this.authorization,
    required this.message,
    required this.chatId,
    required this.firebaseId,
    required this.imageUrl,
    this.type = MessageType.IMAGE_TEXT,
  });

  factory SendMessageImageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageImageDtoToJson(this);
}
