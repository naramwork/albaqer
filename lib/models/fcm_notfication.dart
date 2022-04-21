import 'package:hive/hive.dart';

part 'fcm_notfication.g.dart';

@HiveType(typeId: 7)
class FcmNotification {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final DateTime date;

  FcmNotification(
      {required this.title, required this.body, required this.date});
}
