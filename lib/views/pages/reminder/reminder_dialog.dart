import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../app/helper_files/app_const.dart';
import '../../../app/helper_files/snack_bar.dart';
import '../../../app/themes/color_const.dart';
import '../../../controllers/color_mode.dart';
import '../../../models/reminder.dart';
import '../../components/rounded_button_widget.dart';

class ReminderDialog extends StatelessWidget {
  final myController = TextEditingController();
  final DateTime date;
  final Box remindersBox;
  ReminderDialog({Key? key, required this.date, required this.remindersBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date1 = date;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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
              'اجندة مواعيد واعمال',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: context.watch<ColorMode>().isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notification_add_outlined,
                    size: 30,
                    color: Color(0xff538CB2),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: myController,
                      autocorrect: false,
                      showCursor: false,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'العنوان',
                        hintMaxLines: 2,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: (() async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    date1 = DateTime(date1.year, date1.month, date1.day,
                        picked?.hour ?? 0, picked?.minute ?? 0);
                  }),
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    'اختيار الوقت',
                    style: TextStyle(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Color(0xff538CB2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            RoundedButtonWidget(
                label: const Text('موافق'),
                width: 40.w,
                onpressed: () {
                  var rng = Random();

                  int id = rng.nextInt(10000);
                  /*
                    to sort all reminder by date
                  */
                  // int index = remindersBox.values
                  //     .toList()
                  //     .indexWhere((element) => element.id == id);
                  // while (index >= 0) {
                  //   id = rng.nextInt(10000);
                  //   index = remindersBox.values
                  //       .toList()
                  //       .indexWhere((element) => element.id == id);
                  // }
                  createReminder(date1, context, id);
                })
          ],
        ),
      ),
    );
  }

  void createReminder(DateTime date1, BuildContext context, int id) async {
    String value = myController.text;
    bool isSuccess = await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: reminderChannelKey,
          title: 'تذكير',
          body: value,
          backgroundColor: const Color(0xFF184B6C),
          color: Colors.white,
          category: NotificationCategory.Message),
      schedule: NotificationCalendar.fromDate(date: date1.toLocal()),
    );
    remindersBox.add(Reminder(title: value, date: date1, id: id));
    Navigator.pop(context);

    if (isSuccess) {
      showSnackBar('تمت إضافة التذكير بنجاح', context);
    } else {
      showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا', context);
    }
  }
}
