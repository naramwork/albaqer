import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MarriageHeadCard extends StatelessWidget {
  final String title;
  final Function? onTap;
  final bool isActive;
  const MarriageHeadCard(
      {Key? key, required this.title, this.onTap, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 7.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              isActive ? const Color(0xff0C56B0) : Colors.grey,
              isActive ? const Color(0xff1362C2) : Colors.grey,
              isActive ? const Color(0xff1B6ED3) : Colors.grey,
            ],
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
