import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/models/reminder.dart';
import 'package:albaqer/views/pages/reminder/reminder_dialog.dart';
import 'package:albaqer/views/pages/reminder/reminder_list.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../app/themes/color_const.dart';
import '../../../controllers/color_mode.dart';
import '../../components/marriage_app_bar.dart';

class ReminderPage extends StatefulWidget {
  static String routeName = '/reminder_page';

  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Reminder> reminders = [];
  Box<Reminder>? remindersBox;
  @override
  initState() {
    initReminder();
    super.initState();
  }

  initReminder() async {
    remindersBox = Hive.box<Reminder>(kReminderBoxName);
    reminders = remindersBox!.values.toList();
    for (var reminder in reminders) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: reminder.id,
            channelKey: reminderChannelKey,
            title: 'تذكير',
            body: reminder.title,
            backgroundColor: const Color(0xFF184B6C),
            color: Colors.white,
            category: NotificationCategory.Message),
        schedule: NotificationCalendar.fromDate(date: reminder.date.toLocal()),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ColorMode>().isDarkMode
          ? ColorConst.darkCardColor
          : Colors.grey.shade100,
      appBar: MarriageAppBar(
        title: 'اجندة مواعيد واعمال',
        appBar: AppBar(),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 2.h, 10, 0),
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                headerStyle: const DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  specialDatesDecoration: BoxDecoration(
                      color: Colors.blueGrey,
                      border:
                          Border.all(color: const Color(0xFF2B732F), width: 1),
                      shape: BoxShape.circle),
                  textStyle: const TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  specialDatesTextStyle: const TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                    specialDates: reminders.map((e) => e.date).toList(),
                    viewHeaderStyle: const DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                          fontFamily: 'Tajawal',
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    showTrailingAndLeadingDates: false),
                selectionMode: DateRangePickerSelectionMode.single,
                toggleDaySelection: true,
                showNavigationArrow: true,
                onSelectionChanged:
                    (DateRangePickerSelectionChangedArgs value) {
                  checkAndOpenDialog(value, remindersBox!);
                },
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          remindersBox != null
              ? Expanded(child: ReminderList(remindersBox: remindersBox!))
              : Container()
        ],
      ),
    );
  }

  Future checkAndOpenDialog(
      DateRangePickerSelectionChangedArgs date, Box remindersBox) async {
    return showDialog(
        context: context,
        builder: (context) {
          DateTime date1 = date.value;

          return ReminderDialog(
            date: date1,
            remindersBox: remindersBox,
          );
        });
  }
}
