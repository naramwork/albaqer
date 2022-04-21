import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/holiday.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'holiday_list_item_widget.dart';

class HolidayListContainer extends StatefulWidget {
  final List<Holiday> holidays;
  const HolidayListContainer({Key? key, required this.holidays})
      : super(key: key);

  @override
  State<HolidayListContainer> createState() => _HolidayListContainerState();
}

class _HolidayListContainerState extends State<HolidayListContainer> {
  String currentDateString = "";
  DateTime date = DateTime.now();
  List<Holiday> monthHoliday = [];
  @override
  void initState() {
    super.initState();

    initMonthHoliday(date);
  }

  void headerTitle(DateTime dateTime) {
    String month = DateFormat.MMM('ar-LB').format(dateTime);
    String year = DateFormat.y().format(dateTime);
    currentDateString = month + ' ' + year;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    initMonthHoliday(
                        DateTime(date.year, date.month - 1, date.day));
                  },
                  icon: Icon(
                    Icons.navigate_before,
                    size: 9.w,
                    color: Colors.lightBlue,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      currentDateString,
                      style: TextStyle(
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    initMonthHoliday(
                        DateTime(date.year, date.month + 1, date.day));
                  },
                  icon: Icon(
                    Icons.navigate_next,
                    size: 9.w,
                    color: Colors.lightBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.lightBlue,
          indent: 3.w,
          endIndent: 3.w,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, i) => HolidayListItemWidget(
              holiday: monthHoliday[i],
              month: getMonthName(monthHoliday[i].month),
            ),
            itemCount: monthHoliday.length,
          ),
        ),
        SizedBox(height: 2.h)
      ],
    );
  }

  String getMonthName(int month) {
    return arMonthNames[month]!;
  }

  initMonthHoliday(DateTime dateTime) {
    date = dateTime;
    headerTitle(dateTime);
    var hDate = HijriCalendar();
    int currentYear = HijriCalendar.now().hYear;

    monthHoliday.clear();
    int currentMonth = dateTime.month;
    for (Holiday holiday in widget.holidays) {
      DateTime gDate =
          hDate.hijriToGregorian(currentYear, holiday.month, holiday.day);
      String monthString = DateFormat.MMM('ar-LB').format(gDate);
      String year = DateFormat.y().format(gDate);
      String day = DateFormat.d().format(gDate);
      String gDateString = day + " " + monthString + ' ' + year;
      int month = gDate.month;
      if (month == currentMonth) {
        holiday.gDate = gDateString;
        monthHoliday.add(holiday);
      }
    }
    setState(() {});
  }
}
