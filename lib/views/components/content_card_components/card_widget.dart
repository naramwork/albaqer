import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CardWidget extends StatelessWidget {
  final Widget topWidget;
  final Widget botWidget;
  final double hieght;
  final String? title;

  const CardWidget({
    Key? key,
    required this.topWidget,
    required this.botWidget,
    required this.hieght,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: context.watch<ColorMode>().isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      10, title == null ? 15 : hieght, 10, 10),
                  child: Column(
                    children: [
                      title != null
                          ? Text(
                              'دعاء يوم $title',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                                fontFamily: 'Amiri',
                                color: context.watch<ColorMode>().isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: hieght,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: context.watch<ColorMode>().isDarkMode
                              ? ColorConst.darkCardColor
                              : Theme.of(context).primaryColor,
                        ),
                        child: botWidget,
                      )
                    ],
                  ),
                ),
              ),
            ),
            topWidget,
          ],
        ),
      ),
    );
  }
}
