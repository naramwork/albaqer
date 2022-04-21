import 'package:hive/hive.dart';

part 'prayer_notification.g.dart';

@HiveType(typeId: 1)
class PrayerNotification {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String salahName;

  @HiveField(2)
  final String salahTime;

  @HiveField(3)
  final String day;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String channelKey;

  PrayerNotification({
    required this.id,
    required this.salahName,
    required this.salahTime,
    required this.day,
    required this.date,
    required this.channelKey,
  });
}
