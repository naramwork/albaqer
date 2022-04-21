import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VersesCardWidget extends StatelessWidget {
  final Widget topWidget;
  final Widget botWidget;
  final double hieght;

  const VersesCardWidget({
    Key? key,
    required this.topWidget,
    required this.botWidget,
    required this.hieght,
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
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: context.watch<ColorMode>().isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Icon(
                      //         Icons.more_vert,
                      //         color: ColorConst.extraLightBlue,
                      //       ),
                      //       Icon(
                      //         Icons.bookmark,
                      //         color: ColorConst.extraLightBlue,
                      //       ),
                      //       Icon(
                      //         Icons.favorite,
                      //         color: ColorConst.extraLightBlue,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: hieght,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: context.watch<ColorMode>().isDarkMode
                                ? ColorConst.darkCardColor
                                : Theme.of(context).primaryColor,
                          ),
                          child: botWidget,
                        ),
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
