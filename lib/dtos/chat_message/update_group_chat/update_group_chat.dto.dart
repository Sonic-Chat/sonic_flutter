import 'package:json_annotation/json_annotation.dart';

part 'update_group_chat.dto.g.dart';

@JsonSerializable()
class UpdateGroupChatDto {
  final String chatId;
  final List<String> participants;
  final String name;

  UpdateGroupChatDto({
    required this.chatId,
    required this.participants,
    required this.name,
  });

  factory UpdateGroupChatDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGroupChatDtoToJson(this);
}
