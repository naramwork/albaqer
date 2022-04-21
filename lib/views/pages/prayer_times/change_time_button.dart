import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:duration_picker/duration_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeTimeButton extends StatefulWidget {
  final String salahName;
  final String prayerEnglishName;

  const ChangeTimeButton({
    Key? key,
    required this.salahName,
    required this.prayerEnglishName,
  }) : super(key: key);

  @override
  _ChangeTimeButtonState createState() => _ChangeTimeButtonState();
}

class _ChangeTimeButtonState extends State<ChangeTimeButton> {
  bool isActive = true;
  SharedPreferences? prefs;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Dialog dialog = Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.w, 5.w, 5.w, 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "تعديل التوقيت",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "يمكنك القيام بتعديل توقيت ${widget.salahName}",
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Text("+", style: TextStyle(fontSize: 18)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.lightBlue)))),
                      onPressed: () {
                        storeTime(1, context);
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
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.lightBlue)))),
                      onPressed: () {
                        storeTime(-1, context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (prefs != null) {
                          prefs!.setInt(widget.prayerEnglishName, 0);
                        }
                        context.read<PrayerTimeController>().changePrayerTime();

                        Navigator.pop(context);
                      },
                      child: Text('الإفتراضي'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('إغلاق'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
        showDialog(context: context, builder: (context) => dialog);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            color: ColorConst.lightBlue,
          ),
          SizedBox(
            height: 1.h,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isActive ? 'تعديل الوقت' : 'تفعيل التنبيه',
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

  storeTime(int i, BuildContext context) async {
    var resultingDuration = await showDurationPicker(
      context: context,
      initialTime: const Duration(minutes: 30),
    );
    int minute = (i) * (resultingDuration?.inMinutes ?? 0);
    if (prefs != null) {
      prefs!.setInt(widget.prayerEnglishName, minute);
    }
    context.read<PrayerTimeController>().changePrayerTime();
    Navigator.pop(context);
  }
}
