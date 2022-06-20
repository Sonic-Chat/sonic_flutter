// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 7;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] == null ? '' : fields[0] as String,
      type: fields[1] == null ? MessageType.TEXT : fields[1] as MessageType,
      message: fields[2] as String?,
      sentBy: fields[3] as Account,
      image: fields[4] as Image?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.sentBy)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String? ?? '',
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.TEXT,
      message: json['message'] as String?,
      sentBy: Account.fromJson(json['sentBy'] as Map<String, dynamic>),
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$MessageTypeEnumMap[instance.type],
      'message': instance.message,
      'sentBy': instance.sentBy,
      'image': instance.image,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGE',
  MessageType.IMAGE_TEXT: 'IMAGE_TEXT',
};
