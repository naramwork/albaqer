import 'package:flutter/material.dart';

class ColorConst {
  // static Color secondaryColor = Color.fromRGBO(4, 40, 82, 0.8);
  // static Color lightBlue = Colors.blue.shade300;
  static Color extraLightBlue = Colors.blue.shade200;
  // static Color darkTransparent = Color.fromRGBO(60, 105, 180, 0.7);
  static Color darkTransparent = const Color(0xff538CB2).withOpacity(0.7);

  static Color lightCylan = const Color(0xff84FFFF);
  //
  // static Color dotColor = isDarkMode
  //     ? Color.fromRGBO(200, 230, 241, 1)
  //     : Color.fromRGBO(200, 230, 241, 1);
  // //
  // static Color dotActiveColor = isDarkMode
  //     ? Color.fromRGBO(4, 50, 82, 0.8)
  //     : Color.fromRGBO(4, 50, 82, 0.8);
  // //
  // static Color textInputIconColor = isDarkMode
  //     ? Color.fromRGBO(200, 230, 241, 0.6)
  //     : Color.fromARGB(255, 0, 100, 150);
  // static Color textInputHintColor =
  //     isDarkMode ? Color.fromRGBO(200, 230, 241, 0.6) : Colors.grey.shade300;

  static Color lightBlue = Colors.blue.shade300;
  static List<Color> gradientColors = [
    Colors.blue.shade600,
    Colors.blue.shade500,
    Colors.blue.shade300,
    Colors.blue.shade100,
  ];
  //
  // static List<Color> buttonGradientColors = [
  //   Colors.blue.shade500,
  //   Colors.blue.shade400,
  //   Colors.blue.shade300,
  //   Colors.blue.shade300,
  //   Colors.blue.shade400,
  //   Colors.blue.shade500,
  // ];

  static Color darkCardColor = const Color(0xff111C2E);

  static LinearGradient topCardWidgetGradient = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xff7EADCC),
      Color(0xff538CB2),
      Color(0xff538CB2),
    ],
  );
}
