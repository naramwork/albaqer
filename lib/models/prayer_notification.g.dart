// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerNotificationAdapter extends TypeAdapter<PrayerNotification> {
  @override
  final int typeId = 1;

  @override
  PrayerNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerNotification(
      id: fields[0] as int,
      salahName: fields[1] as String,
      salahTime: fields[2] as String,
      day: fields[3] as String,
      date: fields[4] as DateTime,
      channelKey: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerNotification obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.salahName)
      ..writeByte(2)
      ..write(obj.salahTime)
      ..writeByte(3)
      ..write(obj.day)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.channelKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
