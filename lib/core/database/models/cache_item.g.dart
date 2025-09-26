// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheItemAdapter extends TypeAdapter<CacheItem> {
  @override
  final int typeId = 1;

  @override
  CacheItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheItem(
      key: fields[0] as String,
      data: fields[1] as dynamic,
      createdAt: fields[2] as DateTime,
      expiresAt: fields[3] as DateTime,
      dataType: fields[4] as String,
      metadata: (fields[5] as Map?)?.cast<String, dynamic>(),
      version: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CacheItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.expiresAt)
      ..writeByte(4)
      ..write(obj.dataType)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
