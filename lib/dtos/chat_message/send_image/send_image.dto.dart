import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';

part 'send_image.dto.g.dart';

@JsonSerializable()
class SendImageDto {
  final String authorization;
  final MessageType type = MessageType.IMAGE;
  final String firebaseId;
  final String imageUrl;
  final String chatId;

  SendImageDto({
    required this.authorization,
    required this.firebaseId,
    required this.imageUrl,
    required this.chatId,
  });

  factory SendImageDto.fromJson(Map<String, dynamic> json) =>
      _$SendImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendImageDtoToJson(this);
}
