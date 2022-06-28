import 'package:json_annotation/json_annotation.dart';

part 'create_group_chat.dto.g.dart';

@JsonSerializable()
class CreateGroupChatDto {
  final List<String> participants;
  final String name;

  CreateGroupChatDto({
    required this.participants,
    required this.name,
  });

  factory CreateGroupChatDto.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGroupChatDtoToJson(this);
}
