import 'package:adhan_dart/adhan_dart.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/translate.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/views/main_layout.dart';
import 'package:albaqer/views/pages/accept_user_page.dart';
import 'package:albaqer/views/pages/edit_user_page.dart';
import 'package:albaqer/views/pages/marriage/marriage_page.dart';
import 'package:albaqer/views/pages/register/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

void gotToMarriagePage(BuildContext context) {
  User? user = context.read<UserController>().user;
  if (user == null) {
    Navigator.of(context).pushNamed(LoginPage.routeName);
  } else if (user.isBlock) {
    Navigator.of(context).pushNamed(AcceptUserPage.routeName);
  } else {
    Navigator.of(context).pushNamed(MarriagePage.routeName);
  }
}

void gotToEditUserPage(BuildContext context) {
  User? user = context.read<UserController>().user;
  if (user == null) {
    Navigator.of(context).pushNamed(LoginPage.routeName);
  } else {
    Navigator.of(context).pushNamed(EditUserPage.routeName);
  }
}

int createUniqueId(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch.remainder(100000);
}

calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

void selectPage(int index, BuildContext context) {
  Navigator.of(context).pushNamed(MainLayout.routeName, arguments: index);
}

List<String> getSurrahsNames() {
  List<String> surahsNams = [];
  for (int i = 1; i <= 114; i++) {
    surahsNams.add(getSuranArabicName(i));
  }

  return surahsNams;
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
