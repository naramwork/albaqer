import 'dart:io';

import 'package:albaqer/app/helper_files/functions.dart';

import 'package:albaqer/controllers/color_mode.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/controllers/update_content_controler.dart';

import 'package:geolocator/geolocator.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:albaqer/views/main_layout.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../app/helper_files/app_const.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    redirectBaseOnInternetConnection();
  }

  void redirectBaseOnInternetConnection() async {
    // cancel daily content notifications
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey(kVersesChannleKey);

    await AwesomeNotifications()
        .cancelNotificationsByChannelKey(kDuasChannleKey);
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey(kHadithChannleKey);
    await AwesomeNotifications().cancelAll();

    // var connectivityResult = await (Connectivity().checkConnectivity());
    // bool isOnline = await checkConnection();
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      const snackBar = SnackBar(
          content: Text(
              'الرجاء تفعيل ال GBS و تحديث موقعك للحصول على مواعيد الصلاة بدقة'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    context.read<UpdateContentController>().checkForUpdates();

    context.read<PrayerTimeController>().initPrayerTime().then((value) {
      checkAndAddNotifications(context).then((value) {
        Navigator.pushReplacementNamed(context, MainLayout.routeName);
      });
    });
  }

  Future<bool> checkConnection() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }

    return Future.value(isOnline);
  }

// return true when there is no connection
  Future<bool> checkForIntern() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    bool isOnline = await checkConnection();
    if (connectivityResult == ConnectivityResult.none || !isOnline) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/no_bg_logo.png',
              width: 60.w,
              height: 60.w,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'جاري التحميل',
                style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: 60.w,
              alignment: Alignment.bottomCenter,
              child: const LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
