import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/holiday.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../components/marriage_app_bar.dart';
import 'holiday_list_container.dart';

class HolidayPage extends StatelessWidget {
  static String routeName = '/holiday_page';

  const HolidayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ColorMode>().isDarkMode
          ? ColorConst.darkCardColor
          : Colors.grey.shade100,
      appBar: MarriageAppBar(
        title: 'مناسبات الشهر',
        appBar: AppBar(),
      ),
      body: FutureBuilder<List<Holiday>>(
          future: getHolidays(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(
                  'لا يوجد اتصال',
                  style: TextStyle(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                );
              } else if (snapshot.hasData) {
                return HolidayListContainer(
                  holidays: snapshot.data!,
                );
              } else {
                return const Text('لا يوجد');
              }
            } else {
              return Text('حالة الإتصال: ${snapshot.connectionState}');
            }
          }),
    );
  }

  Future<List<Holiday>> getHolidays() async {
    var url = Uri.parse(kHoliday);
    List<Holiday> holidays = [];
    try {
      final response = await http.get(url);

      final jsonExtractedList = json.decode(response.body);

      for (var holidayJson in jsonExtractedList) {
        holidays.add(
          Holiday(
              gDate: "",
              day: holidayJson["day"],
              month: holidayJson["month"],
              content: holidayJson["content"]),
        );
      }

      return holidays;
    } catch (error) {
      return holidays;
    }
  }
}
