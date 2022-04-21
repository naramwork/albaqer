// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 6;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      email: fields[2] as String,
      name: fields[3] as String,
      phoneNumber: fields[4] as String,
      fullName: fields[5] as String,
      gender: fields[6] as String,
      nationality: fields[7] as String,
      city: fields[8] as String,
      country: fields[9] as String,
      religion: fields[10] as String,
      physique: fields[11] as String,
      skinColour: fields[12] as String,
      prayer: fields[13] as String,
      religiosity: fields[14] as String,
      beard: fields[15] as String,
      smoking: fields[16] as String,
      financialStatus: fields[17] as String,
      employment: fields[18] as String,
      income: fields[19] as String,
      healthStatus: fields[20] as String,
      specifications: fields[21] as String,
      aboutYou: fields[22] as String,
      job: fields[23] as String,
      birthDate: fields[24] as DateTime,
      civilIdNo: fields[25] as String,
      imageUrl: fields[26] as String,
      childrenNumber: fields[27] as int,
      height: fields[28] as double,
      weight: fields[29] as double,
      isBlock: fields[30] as bool,
      token: fields[32] as String,
      socialStatus: fields[33] as String,
      educational: fields[34] as String,
      fcm: (fields[31] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.fullName)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.nationality)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.country)
      ..writeByte(10)
      ..write(obj.religion)
      ..writeByte(11)
      ..write(obj.physique)
      ..writeByte(12)
      ..write(obj.skinColour)
      ..writeByte(13)
      ..write(obj.prayer)
      ..writeByte(14)
      ..write(obj.religiosity)
      ..writeByte(15)
      ..write(obj.beard)
      ..writeByte(16)
      ..write(obj.smoking)
      ..writeByte(17)
      ..write(obj.financialStatus)
      ..writeByte(18)
      ..write(obj.employment)
      ..writeByte(19)
      ..write(obj.income)
      ..writeByte(20)
      ..write(obj.healthStatus)
      ..writeByte(21)
      ..write(obj.specifications)
      ..writeByte(22)
      ..write(obj.aboutYou)
      ..writeByte(23)
      ..write(obj.job)
      ..writeByte(24)
      ..write(obj.birthDate)
      ..writeByte(25)
      ..write(obj.civilIdNo)
      ..writeByte(26)
      ..write(obj.imageUrl)
      ..writeByte(27)
      ..write(obj.childrenNumber)
      ..writeByte(28)
      ..write(obj.height)
      ..writeByte(29)
      ..write(obj.weight)
      ..writeByte(30)
      ..write(obj.isBlock)
      ..writeByte(31)
      ..write(obj.fcm)
      ..writeByte(32)
      ..write(obj.token)
      ..writeByte(33)
      ..write(obj.socialStatus)
      ..writeByte(34)
      ..write(obj.educational);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
