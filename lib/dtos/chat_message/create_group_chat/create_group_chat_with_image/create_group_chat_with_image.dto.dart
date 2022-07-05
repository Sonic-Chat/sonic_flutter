import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_flutter/dtos/chat_message/create_group_chat/create_group_chat.dto.dart';

part 'create_group_chat_with_image.dto.g.dart';

@JsonSerializable()
class CreateGroupChatWithImageDto extends CreateGroupChatDto {
  final String imageUrl;

  CreateGroupChatWithImageDto({
    required List<String> participants,
    required String name,
    required this.imageUrl,
  }) : super(
          participants: participants,
          name: name,
        );

  factory CreateGroupChatWithImageDto.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupChatWithImageDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateGroupChatWithImageDtoToJson(this);
}
