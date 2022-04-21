// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_verse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewVerseAdapter extends TypeAdapter<NewVerse> {
  @override
  final int typeId = 8;

  @override
  NewVerse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewVerse(
      surahNumber: fields[0] as int,
      verseNumber: fields[4] as int,
      juzNumber: fields[5] as int,
      content: fields[1] as String,
      part: fields[2] as String,
      surah: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NewVerse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.surahNumber)
      ..writeByte(4)
      ..write(obj.verseNumber)
      ..writeByte(5)
      ..write(obj.juzNumber)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.part)
      ..writeByte(3)
      ..write(obj.surah);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewVerseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
