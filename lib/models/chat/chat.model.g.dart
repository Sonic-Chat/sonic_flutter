// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 8;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      id: fields[0] == null ? '' : fields[0] as String,
      imageUrl: fields[7] == null ? '' : fields[7] as String,
      name: fields[8] == null ? '' : fields[8] as String,
      type: fields[9] == null ? ChatType.SINGLE : fields[9] as ChatType,
      messages: fields[1] == null ? [] : (fields[1] as List).cast<Message>(),
      participants:
          fields[2] == null ? [] : (fields[2] as List).cast<Account>(),
      delivered: fields[3] == null ? [] : (fields[3] as List).cast<Account>(),
      seen: fields[4] == null ? [] : (fields[4] as List).cast<Account>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.messages)
      ..writeByte(2)
      ..write(obj.participants)
      ..writeByte(3)
      ..write(obj.delivered)
      ..writeByte(4)
      ..write(obj.seen)
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
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: $enumDecodeNullable(_$ChatTypeEnumMap, json['type']) ??
          ChatType.SINGLE,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      delivered: (json['delivered'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      seen: (json['seen'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'type': _$ChatTypeEnumMap[instance.type],
      'messages': instance.messages,
      'participants': instance.participants,
      'delivered': instance.delivered,
      'seen': instance.seen,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ChatTypeEnumMap = {
  ChatType.SINGLE: 'SINGLE',
  ChatType.GROUP: 'GROUP',
};
