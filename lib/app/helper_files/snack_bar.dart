import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showSnackBar(String text, BuildContext context) {
  SnackBar snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
