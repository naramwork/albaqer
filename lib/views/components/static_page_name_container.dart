import 'package:albaqer/app/themes/color_const.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StaticPageNameContainer extends StatelessWidget {
  final double maxHeight;
  final Radius bottomBorderRad;
  final String pageTitle;
  final String backgroundImageUrl;
  final BoxFit? boxFit;
  final Alignment imageAlignment;
  const StaticPageNameContainer(
      {Key? key,
      required this.maxHeight,
      required this.bottomBorderRad,
      required this.pageTitle,
      required this.backgroundImageUrl,
      this.boxFit = BoxFit.cover,
      required this.imageAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: bottomBorderRad,
        ),
      ),
      child: Container(
        height: maxHeight,
        decoration: BoxDecoration(
          color: const Color(0xff80aaff),
          borderRadius: BorderRadius.vertical(
            bottom: bottomBorderRad,
          ),
          image: DecorationImage(
              alignment: imageAlignment,
              image: AssetImage(backgroundImageUrl),
              fit: boxFit),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 3.h),
          height: maxHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: bottomBorderRad,
              ),
              color: ColorConst.darkTransparent),
          alignment: Alignment.bottomCenter,
          child: Text(
            pageTitle,
            style: TextStyle(
                fontFamily: 'Almarai',
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
