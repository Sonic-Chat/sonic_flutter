import 'package:hive/hive.dart';

part 'chat_type.enum.g.dart';

@HiveType(typeId: 9)
enum ChatType {
  @HiveField(0)
  SINGLE,
  @HiveField(1)
  GROUP,
}
