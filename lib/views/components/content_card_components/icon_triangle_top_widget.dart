import 'dart:math';

import 'package:albaqer/app/themes/color_const.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IconTriangleTopWidget extends StatelessWidget {
  final ImageIcon icon;
  const IconTriangleTopWidget({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -3.6.h,
      right: 10.w,
      child: Transform.rotate(
        angle: pi / 4,
        child: Container(
          width: 7.h,
          height: 7.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: ColorConst.topCardWidgetGradient,
          ),
          child: Transform.rotate(
              angle: -pi / 4,
              child: Center(
                child: icon,
              )),
        ),
      ),
    );
  }
}
