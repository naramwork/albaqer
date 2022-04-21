import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationToggleButton extends StatefulWidget {
  final String salahName;
  const NotificationToggleButton({Key? key, required this.salahName})
      : super(key: key);

  @override
  _NotificationToggleButtonState createState() =>
      _NotificationToggleButtonState();
}

class _NotificationToggleButtonState extends State<NotificationToggleButton> {
  bool isActive = true;

  @override
  void initState() {
    getNotificationStatus(widget.salahName).then((value) => setState(() {
          isActive = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        cancelPrayer(widget.salahName);
        setState(() {
          isActive = !isActive;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? Icons.notifications_off : Icons.notifications_active,
            color: ColorConst.lightBlue,
          ),
          SizedBox(
            height: 1.h,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isActive ? 'إلغاء التنبيه' : 'تفعيل التنبيه',
              style: TextStyle(
                  color: ColorConst.lightBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 8),
            ),
          )
        ],
      ),
    );
  }

  Future<void> cancelPrayer(salahName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (salahName) {
      case 'صلاة الفجر':
        AwesomeNotifications()
            .cancelNotificationsByChannelKey(kFajerChannleKey);
        bool value = await getNotificationStatus(salahName);
        prefs.setBool(isFajerNotificationActiveKey, !value);
        break;
      case 'صلاة الظهر':
        AwesomeNotifications()
            .cancelNotificationsByChannelKey(kduharChannleKey);

        bool value = await getNotificationStatus(salahName);
        prefs.setBool(isDuharNotificationActiveKey, !value);

        break;
      case 'صلاة العصر':
        AwesomeNotifications().cancelNotificationsByChannelKey(kAsrChannleKey);

        bool value = await getNotificationStatus(salahName);
        prefs.setBool(isAsrNotificationActiveKey, !value);
        break;
      case 'صلاة المغرب':
        AwesomeNotifications()
            .cancelNotificationsByChannelKey(kMaghrbChannleKey);

        bool value = await getNotificationStatus(salahName);
        prefs.setBool(isMagrbNotificationActiveKey, !value);
        break;
      case 'صلاة العشاء':
        AwesomeNotifications().cancelNotificationsByChannelKey(kishaChannleKey);
        bool value = await getNotificationStatus(salahName);
        prefs.setBool(isIshaNotificationActiveKey, !value);
        break;
    }
  }

  Future<bool> getNotificationStatus(salahName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (salahName) {
      case 'صلاة الفجر':
        return prefs.getBool(isFajerNotificationActiveKey) ?? true;

      case 'صلاة الظهر':
        return prefs.getBool(isDuharNotificationActiveKey) ?? true;

      case 'صلاة العصر':
        return prefs.getBool(isAsrNotificationActiveKey) ?? true;

      case 'صلاة المغرب':
        return prefs.getBool(isMagrbNotificationActiveKey) ?? true;

      case 'صلاة العشاء':
        return prefs.getBool(isIshaNotificationActiveKey) ?? true;
    }
    return true;
  }
}
