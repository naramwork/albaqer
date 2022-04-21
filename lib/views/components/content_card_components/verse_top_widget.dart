import 'package:albaqer/app/helper_files/translate.dart';
import 'package:albaqer/app/themes/color_const.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerseTopWidget extends StatelessWidget {
  final String surah;
  final String part;
  final String searchVerse;

  const VerseTopWidget(
      {Key? key,
      required this.surah,
      required this.part,
      this.searchVerse = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: ColorConst.topCardWidgetGradient,
      ),
      child: part.isEmpty
          ? Text(
              surah,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            )
          : Text(
              '${getSuranArabicName(int.parse(surah))} : $part',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
    );
  }
}
