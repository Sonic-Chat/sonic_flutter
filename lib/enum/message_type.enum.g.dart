// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_type.enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 5;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.TEXT;
      case 1:
        return MessageType.IMAGE;
      case 2:
        return MessageType.IMAGE_TEXT;
      default:
        return MessageType.TEXT;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.TEXT:
        writer.writeByte(0);
        break;
      case MessageType.IMAGE:
        writer.writeByte(1);
        break;
      case MessageType.IMAGE_TEXT:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
