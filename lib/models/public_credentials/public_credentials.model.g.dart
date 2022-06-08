// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_credentials.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PublicCredentialsAdapter extends TypeAdapter<PublicCredentials> {
  @override
  final int typeId = 2;

  @override
  PublicCredentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PublicCredentials(
      id: fields[0] as String,
      username: fields[1] as String,
      account: fields[2] as Account,
    );
  }

  @override
  void write(BinaryWriter writer, PublicCredentials obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.account);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublicCredentialsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicCredentials _$PublicCredentialsFromJson(Map<String, dynamic> json) =>
    PublicCredentials(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicCredentialsToJson(PublicCredentials instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'account': instance.account,
    };
