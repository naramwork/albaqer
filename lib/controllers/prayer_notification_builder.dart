import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:flutter/material.dart';

Future<void> createPrayerNotification(
    PrayerNotification prayerNotification) async {
  // AwesomeNotifications()
  //     .listScheduledNotifications()
  //     .then((value) => log(value.toString()));

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: prayerNotification.id,
        channelKey: prayerNotification.channelKey,
        title: 'صلاة',
        body: 'حان الأن موعد ${prayerNotification.salahName}',
        backgroundColor: const Color(0xFF184B6C),
        color: Colors.white,
        category: NotificationCategory.Message),
    schedule:
        NotificationCalendar.fromDate(date: prayerNotification.date.toLocal()),
  );
}

int createUniqueId(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch.remainder(100000);
}

void generateWeekPrayerNotification(
    List<PrayerNotification> prayerNotifications) async {
  for (var notification in prayerNotifications) {
    if (notification.date.isAfter(DateTime.now())) {
      createPrayerNotification(notification);
    }
  }
}

NotificationChannel setNewPrayerChannel(
        {required String name, required String key}) =>
    NotificationChannel(
        channelKey: key,
        channelName: name,
        channelDescription: 'التذكير بمواعيد الصلاة',
        ledColor: Colors.white,
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
        playSound: true,
        soundSource: 'resource://raw/res_allah_notification',
        channelGroupKey: 'prayer_times_group');
