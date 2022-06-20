import 'package:hive/hive.dart';

part 'message_type.enum.g.dart';

@HiveType(typeId: 5)
enum MessageType {

  @HiveField(0)
  TEXT,

  @HiveField(1)
  IMAGE,

  @HiveField(2)
  IMAGE_TEXT,
}