import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrayerTimeCard extends StatelessWidget {
  final String salahName;
  final String dateName;
  final String imageUrl;
  final Color filterColer;
  final Color color;
  const PrayerTimeCard(
      {Key? key,
      required this.salahName,
      required this.dateName,
      required this.imageUrl,
      required this.filterColer,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 45.w,
      padding: EdgeInsets.fromLTRB(2.w, 3.h, 2.w, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: color,
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(filterColer, BlendMode.dstIn),
          image: AssetImage(imageUrl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Text(
              salahName,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromRGBO(255, 255, 255, 0.6),
            ),
            child: const Text(
              'موعد الاذان',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 30.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  dateName,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
