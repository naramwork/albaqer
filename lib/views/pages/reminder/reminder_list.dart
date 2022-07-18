import 'package:albaqer/views/pages/reminder/edit-reminder_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/color_mode.dart';
import '../../../models/reminder.dart';

class ReminderList extends StatelessWidget {
  final Box<Reminder> remindersBox;

  const ReminderList({Key? key, required this.remindersBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: remindersBox.listenable(),
      builder: (context, Box box, _) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, i) {
            Reminder reminder = box.values.toList().reversed.elementAt(i);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: context.watch<ColorMode>().isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        reminder.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    const Divider(
                      color: Colors.lightBlue,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-d | H:mm').format(reminder.date),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Row(
                          children: [
                            Material(
                              color: context.watch<ColorMode>().isDarkMode
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              child: Container(
                                color: Colors.transparent,
                                child: IconButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return EditReminderDialog(
                                            remindersBox: remindersBox,
                                            reminder: reminder,
                                            index: box.length - i - 1,
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Colors.blue.shade400),
                                ),
                              ),
                            ),
                            Material(
                              color: context.watch<ColorMode>().isDarkMode
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              child: Container(
                                color: Colors.transparent,
                                child: IconButton(
                                  onPressed: () async {
                                    remindersBox.deleteAt(box.length - i - 1);

                                    await AwesomeNotifications()
                                        .cancelSchedule(reminder.id);
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return EditReminderDialog(
                                    //         remindersBox: remindersBox,
                                    //         reminder: reminder,
                                    //         index: box.length - i - 1,
                                    //       );
                                    //     });
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Colors.red.shade900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
