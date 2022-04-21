import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/holiday.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class HolidayListItemWidget extends StatelessWidget {
  final Holiday holiday;
  final String month;
  const HolidayListItemWidget(
      {Key? key, required this.holiday, required this.month})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Text(
                  '${holiday.day} $month',
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  holiday.gDate,
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              holiday.content,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: context.watch<ColorMode>().isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 1.h,
            ),
            Divider(
              color: Colors.lightBlue,
            ),
            SizedBox(
              height: 1.h,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      child: Container(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text:
                                        '${holiday.day} $month | ${holiday.content}'))
                                .then((value) {
                              showSnackBar('تم النسخ', context);
                            });
                          },
                          icon: Icon(
                            Icons.content_copy_outlined,
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Material(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      child: Container(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            Share.share(
                              '${holiday.day} $month | ${holiday.content}',
                            );
                          },
                          icon: Icon(
                            Icons.share_outlined,
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
