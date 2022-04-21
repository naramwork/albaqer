import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/controllers/update_content_controler.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:albaqer/views/pages/onboarding/onboarding_page_one.dart';
import 'package:albaqer/views/pages/onboarding/onboarding_page_three.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_page_tow.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController controller = PageController(initialPage: 0);
  double currentPage = 0.0;

  @override
  void didChangeDependencies() {
    context.read<UpdateContentController>().checkForUpdates();
    context.read<PrayerTimeController>().initPrayerTime().then((value) {
      if (value == true) {
        const snackBar = SnackBar(
            content: Text(
                'حدث خطأ اثناء طلب الموقع ... سيتم استخدام موقع افتراضي يمكنك تغييره لاحقا'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      checkAndAddNotifications(context);
    });
    super.didChangeDependencies();
  }

  void nextPage() {
    controller.animateToPage(
      (currentPage + 1).toInt(),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    currentPage = currentPage + 1;
    setState(() {});
  }

  Future checkAndAddNotifications(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(kIsFirstTimeKey, 0);
    await Hive.openBox<PrayerNotification>(kNotificationBoxName);
    context.read<PrayerTimeController>().setWeeklyPrayerTime();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            reverse: true,
            children: [
              OnBoardingPageOne(
                next: nextPage,
              ),
              OnBoardingPageTow(
                next: nextPage,
              ),
              OnBoardingPageThree(
                next: nextPage,
              ),
            ],
          ),
          Positioned(
            bottom: 6.h,
            right: 0,
            left: 0,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: DotsIndicator(
                dotsCount: 3,
                position: currentPage,
                decorator: DotsDecorator(
                  size: Size(6.0.w, 1.h),
                  activeSize: Size(6.0.w, 10),
                  color: context.watch<ColorMode>().dotColor,
                  activeColor: context.watch<ColorMode>().dotActiveColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                        color: context.watch<ColorMode>().dotColor, width: 0.2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
