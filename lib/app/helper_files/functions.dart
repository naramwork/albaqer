import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/translate.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:albaqer/views/main_layout.dart';
import 'package:albaqer/views/pages/reminder/reminder_page.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

void gotToMarriagePage(BuildContext context) {
  Navigator.pushNamed(context, ReminderPage.routeName);
}

int createUniqueId(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch.remainder(100000);
}

void selectPage(int index, BuildContext context) {
  Navigator.of(context).pushNamed(MainLayout.routeName, arguments: index);
}

Future checkAndAddNotifications(BuildContext context) async {
  await Hive.openBox<PrayerNotification>(kNotificationBoxName);
  context.read<PrayerTimeController>().setWeeklyPrayerTime();
  return;
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString =
      parse(document.body?.text).documentElement?.text ?? '';

  return parsedString;
}

String getArabicDay(int order) {
  String day = '';
  switch (order) {
    case 1:
      day = 'الإثنين';
      break;
    case 2:
      day = 'الثلاثاء';
      break;
    case 3:
      day = 'الإربعاء';
      break;
    case 4:
      day = 'الخميس';
      break;
    case 5:
      day = 'الجمعة';
      break;
    case 6:
      day = 'السبت';
      break;
    case 7:
      day = 'الأحد';
      break;
  }
  return day;
}
