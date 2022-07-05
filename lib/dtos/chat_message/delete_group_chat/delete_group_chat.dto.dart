import 'package:json_annotation/json_annotation.dart';

part 'delete_group_chat.dto.g.dart';

@JsonSerializable()
class DeleteGroupChatDto {
  final String chatId;

  DeleteGroupChatDto({
    required this.chatId,
  });

  factory DeleteGroupChatDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteGroupChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteGroupChatDtoToJson(this);
}
