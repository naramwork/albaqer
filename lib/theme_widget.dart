import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeWidget extends StatefulWidget {
  final AdaptiveThemeBuilder builder;
  final AdaptiveThemeMode? savedThemeMode;
  const ThemeWidget({
    Key? key,
    required this.builder,
    this.savedThemeMode,
  }) : super(key: key);

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    bottomAppBarColor: Colors.black54,
    canvasColor: Colors.white,
    fontFamily: 'Tajawal',
    textTheme: const TextTheme(
      headline2: TextStyle(
          //menu Item text style
          color: Colors.grey,
          fontSize: 15),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF184B6C),
    primaryColorDark: const Color(0xFF043453),
    bottomAppBarColor: Colors.white,
    unselectedWidgetColor: Colors.white60,
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 10, 22),
    fontFamily: 'Tajawal',
    textTheme: const TextTheme(
      headline2: TextStyle(
          //menu Item text style
          color: Colors.grey,
          fontSize: 15),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: widget.builder,
    );
  }
}
