// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendRequestAdapter extends TypeAdapter<FriendRequest> {
  @override
  final int typeId = 3;

  @override
  FriendRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendRequest(
      id: fields[0] as String,
      status: fields[1] as FriendStatus,
      requestedById: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      accounts: (fields[5] as List).cast<Account>(),
    );
  }

  @override
  void write(BinaryWriter writer, FriendRequest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.requestedById)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.accounts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      id: json['id'] as String? ?? '',
      status: $enumDecodeNullable(_$FriendStatusEnumMap, json['status']) ??
          FriendStatus.REQUESTED,
      requestedById: json['requestedById'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$FriendStatusEnumMap[instance.status],
      'requestedById': instance.requestedById,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'accounts': instance.accounts,
    };

const _$FriendStatusEnumMap = {
  FriendStatus.REQUESTED: 'REQUESTED',
  FriendStatus.ACCEPTED: 'ACCEPTED',
  FriendStatus.IGNORED: 'IGNORED',
};
