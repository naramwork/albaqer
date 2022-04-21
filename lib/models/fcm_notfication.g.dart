// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_notfication.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FcmNotificationAdapter extends TypeAdapter<FcmNotification> {
  @override
  final int typeId = 7;

  @override
  FcmNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FcmNotification(
      title: fields[0] as String,
      body: fields[1] as String,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FcmNotification obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FcmNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
