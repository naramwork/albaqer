import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/models/arabic_date.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/themes/color_const.dart';
import '../../../controllers/color_mode.dart';

class ChangeDateWidget extends StatelessWidget {
  final ArabicDate arabicDate;
  const ChangeDateWidget({
    Key? key,
    required this.arabicDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date =
        '${arabicDate.day} ${arabicDate.monthName} - ${arabicDate.year} ه ';
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.watch<ColorMode>().isDarkMode
              ? ColorConst.darkCardColor
              : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تعديل التاريخ',
              style: TextStyle(
                  color: context.watch<ColorMode>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            SizedBox(
              height: 1.h,
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              date,
              style: TextStyle(
                  color: context.watch<ColorMode>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text("+", style: TextStyle(fontSize: 18)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  const BorderSide(color: Colors.lightBlue)))),
                  onPressed: () {
                    changeDate(1, context);
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                TextButton(
                  child: const Text("-", style: TextStyle(fontSize: 18)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  const BorderSide(color: Colors.lightBlue)))),
                  onPressed: () {
                    changeDate(-1, context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 1.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('موافق'),
              ),
            )
          ],
        ),
      ),
    );
  }

  changeDate(int day, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int defaultDays = prefs.getInt(kChangeHijriDate) ?? 0;
    int newDays = day + defaultDays;
    prefs.setInt(kChangeHijriDate, newDays);
    context.read<PrayerTimeController>().setPrayerVars(
          HijriCalendar.fromDate(
            DateTime.now().add(Duration(days: newDays)),
          ),
        );
  }
}
