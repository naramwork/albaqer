import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SpinnerBottomWidget extends StatelessWidget {
  final String content;
  const SpinnerBottomWidget({
    Key? key,
    required this.content,
  }) : super(key: key);

  TextStyle style(BuildContext context) => TextStyle(
      color:
          context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      fontFamily: 'Amiri',
      height: 1.6);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
      child: content == ''
          ? JumpingDotsProgressIndicator(
              color: context.watch<ColorMode>().isDarkMode
                  ? Colors.white
                  : Colors.black,
              fontSize: 30.sp,
            )
          : Text(
              parseHtmlString(content.trim()),
              style: style(context),
              textAlign: TextAlign.center,
            ),
    );
  }
}
