// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpdateContentAdapter extends TypeAdapter<UpdateContent> {
  @override
  final int typeId = 3;

  @override
  UpdateContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateContent(
      startAt: fields[0] as int,
      type: fields[1] as String,
      lastUpdate: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startAt)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
