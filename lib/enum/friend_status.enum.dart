import 'package:hive/hive.dart';

part 'friend_status.enum.g.dart';

@HiveType(typeId: 4)
enum FriendStatus {

  @HiveField(0)
  REQUESTED,

  @HiveField(1)
  ACCEPTED,

  @HiveField(2)
  IGNORED,

  @HiveField(4)
  REQUESTED_TO_YOU,
}
