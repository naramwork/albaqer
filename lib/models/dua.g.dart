// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DuaAdapter extends TypeAdapter<Dua> {
  @override
  final int typeId = 4;

  @override
  Dua read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dua(
      content: fields[0] as String,
      order: fields[1] as int,
      updatedAt: fields[2] as String,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Dua obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DuaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
