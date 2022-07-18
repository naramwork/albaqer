import 'dart:convert';

import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/hijri_date.dart';
import 'package:albaqer/models/holiday.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_array.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/helper_files/app_const.dart';
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

  initMonthHoliday(DateTime dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    date = dateTime;
    int currentMonth = date.month;
    int currentYear = date.year;
    headerTitle(dateTime);
    monthHoliday.clear();
    print(
        "http://api.aladhan.com/v1/gToHCalendar/$currentMonth/$currentYear?adjustment=${prefs.getInt(kChangeHijriDate) ?? 0}");
    var url = Uri.parse(
        "http://api.aladhan.com/v1/gToHCalendar/$currentMonth/$currentYear?adjustment=${prefs.getInt(kChangeHijriDate) ?? 0}");

    try {
      final response = await http.get(url);
      List<HijriDate> hijriMonthsList = [];
      final jsonExtractedList = json.decode(response.body);
      final holidaysData = jsonExtractedList['data'] as List<dynamic>;

      for (var holidayObject in holidaysData) {
        hijriMonthsList.add(
          HijriDate(
              int.parse(holidayObject['hijri']['day']),
              holidayObject['hijri']['month']['number'],
              int.parse(holidayObject['hijri']['year']),
              holidayObject['gregorian']['date']),
        );
      }
      for (var hijriMonth in hijriMonthsList) {
        Holiday? holiday = widget.holidays.firstWhereOrNull(
          (element) => (element.day == hijriMonth.day &&
              element.month == hijriMonth.month),
        );
        if (holiday != null) {
          DateTime gDate = DateFormat("DD-MM-yyyy").parse(hijriMonth.gDate);
          String monthString = DateFormat.MMM('ar-LB').format(gDate);
          String year = DateFormat.y().format(gDate);
          String day = DateFormat.d().format(gDate);
          String gDateString = day + " " + monthString + ' ' + year;
          holiday.gDate = gDateString;
          monthHoliday.add(holiday);
        }
      }

      setState(() {});
    } catch (error) {
      print(error);

      return false;
    }
  }
}
