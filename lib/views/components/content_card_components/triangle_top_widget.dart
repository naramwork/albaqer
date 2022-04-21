import 'dart:math';

import 'package:albaqer/app/themes/color_const.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CardTriangleTopWidget extends StatelessWidget {
  final String title;
  const CardTriangleTopWidget({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: 10.w,
      child: Transform.rotate(
        angle: pi / 4,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: ColorConst.topCardWidgetGradient,
          ),
          child: Transform.rotate(
            angle: -pi / 4,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
