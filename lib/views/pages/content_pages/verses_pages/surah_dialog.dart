import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/verse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SurahDialog extends StatelessWidget {
  final Verse verse;
  const SurahDialog({Key? key, required this.verse}) : super(key: key);

  TextStyle getTextStyle(BuildContext context, {double? font, double? hieght}) {
    return TextStyle(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        fontFamily: 'Almarai',
        fontSize: font,
        height: hieght);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.w),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.watch<ColorMode>().isDarkMode
              ? ColorConst.darkCardColor
              : Colors.white,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '﴿ ${verse.surah} ﴾',
                  style: getTextStyle(context),
                ),
                Text(
                  '﴿ ${verse.part} ﴾',
                  style: getTextStyle(context),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: Text(
                '﴿ ${verse.surah} ﴾',
                style: getTextStyle(context),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                        style: getTextStyle(context, font: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SelectableText(verse.content,
                          style: getTextStyle(context, hieght: 1.8, font: 16),
                          textAlign: TextAlign.start),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'إغلاق',
                    style: getTextStyle(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
