import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NameHeaderCard extends StatelessWidget {
  final String title;
  final double? padding;
  final double? fontSize;
  final double? imageWidth;
  final bool hasClose;
  const NameHeaderCard(
      {Key? key,
      required this.title,
      this.padding,
      this.fontSize,
      this.imageWidth,
      this.hasClose = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 10.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xff0C56B0),
                Color(0xff1362C2),
                Color(0xff1B6ED3),
              ],
            )),
        child: Stack(
          children: [
            hasClose
                ? Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                : Container(),
            Container(
              height: 7.h,
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize ?? 18),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              child: SvgPicture.asset(
                'assets/images/lift.svg',
                fit: BoxFit.fill,
                width: imageWidth ?? 14.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
