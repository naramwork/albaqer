import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/models/dua.dart';
import 'package:albaqer/models/hadith.dart';
import 'package:albaqer/models/verse.dart';
import 'package:flutter/material.dart';

NotificationChannel setNewContentChannel(
        {required String name, required String key}) =>
    NotificationChannel(
      channelKey: key,
      channelName: name,
      channelDescription: 'المحتوى اليومي',
      ledColor: Colors.white,
      defaultColor: Colors.blue,
      importance: NotificationImportance.High,
      playSound: true,
      channelGroupKey: kContentChannelGroupKey,
    );

void generateWeekVersesNotification(List<Verse> verses) async {
  generateWeekContentNotification(
      contents: verses,
      title: 'الآية اليومية',
      channelKey: kVersesChannleKey,
      hour: 8,
      minute: 30);
}

void generateWeekDuaNotification(List<Dua> duas) async {
  generateWeekContentNotification(
      contents: duas,
      title: 'الدعاء اليومي',
      channelKey: kDuasChannleKey,
      hour: 6,
      minute: 30);
}

void generateWeekHadithNotification(List<Hadith> hadiths) async {
  generateWeekContentNotification(
      contents: hadiths,
      title: 'الحديث الشريف',
      channelKey: kHadithChannleKey,
      hour: 11,
      minute: 30);
}

void generateWeekContentNotification(
    {required List contents,
    required String title,
    required String channelKey,
    required int hour,
    required int minute}) async {
  // bool isExists = await checkIfOlreadyExists(channelKey);
  // if (isExists) return;
  var rng = Random();
  int date = 0;
  AwesomeNotifications().cancelNotificationsByChannelKey(channelKey);
  for (var content in contents) {
    int id =
        createUniqueId(DateTime.parse(content.updatedAt)) + rng.nextInt(1000);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: channelKey,
          title: title,
          body: content.content,
          backgroundColor: const Color(0xFF184B6C),
          color: Colors.white,
          category: NotificationCategory.Message),
      schedule: NotificationCalendar(
          month: DateTime.now().add(Duration(days: date)).month,
          day: DateTime.now().add(Duration(days: date)).day,
          hour: hour,
          minute: minute),
    );
    date++;
  }
}
