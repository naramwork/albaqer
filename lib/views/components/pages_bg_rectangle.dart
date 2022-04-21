import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PagesBgRectangle extends StatelessWidget {
  const PagesBgRectangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(0),
        child: Container(
          width: 85.w,
          height: double.infinity,
          color: context.watch<ColorMode>().isDarkMode
              ? const Color(0xff111C2E)
              : Colors.white,
        ),
      ),
    );
  }
}
