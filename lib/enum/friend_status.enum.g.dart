// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_status.enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendStatusAdapter extends TypeAdapter<FriendStatus> {
  @override
  final int typeId = 4;

  @override
  FriendStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FriendStatus.REQUESTED;
      case 1:
        return FriendStatus.ACCEPTED;
      case 2:
        return FriendStatus.IGNORED;
      default:
        return FriendStatus.REQUESTED;
    }
  }

  @override
  void write(BinaryWriter writer, FriendStatus obj) {
    switch (obj) {
      case FriendStatus.REQUESTED:
        writer.writeByte(0);
        break;
      case FriendStatus.ACCEPTED:
        writer.writeByte(1);
        break;
      case FriendStatus.IGNORED:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
