import 'package:hive/hive.dart';
part 'reminder.g.dart';

@HiveType(typeId: 9)
class Reminder {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;
  @HiveField(2)
  int id;
  Reminder({
    required this.title,
    required this.date,
    required this.id,
  });
}
