import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/dtos/chat_message/update_group_chat/update_group_chat.dto.dart';

part 'update_group_chat_with_image.dto.g.dart';

@JsonSerializable()
class UpdateGroupChatWithImageDto extends UpdateGroupChatDto {
  final String imageUrl;

  UpdateGroupChatWithImageDto({
    required String chatId,
    required List<String> participants,
    required String name,
    required this.imageUrl,
  }) : super(
          chatId: chatId,
          participants: participants,
          name: name,
        );

  factory UpdateGroupChatWithImageDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupChatWithImageDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateGroupChatWithImageDtoToJson(this);
}
