import 'package:flutter/material.dart';

class ColorMode extends ChangeNotifier {
  late bool _isDarkMode;
  late Color _textInputHintColor;
  late Color _textInputIconColor;
  late Color _dotColor;
  late Color _dotActiveColor;

  bool get isDarkMode => _isDarkMode;
  Color get textInputHintColor => _textInputHintColor;
  Color get textInputIconColor => _textInputIconColor;
  Color get dotColor => _dotColor;
  Color get dotActiveColor => _dotActiveColor;

  ColorMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    changeColorMode(isDarkMode);
  }

  void changeColorMode(bool dark) {
    _isDarkMode = dark;
    _textInputHintColor = _isDarkMode
        ? const Color.fromRGBO(200, 230, 241, 0.6)
        : Colors.grey.shade400;
    _textInputIconColor = _isDarkMode
        ? const Color.fromRGBO(200, 230, 241, 0.6)
        : const Color.fromARGB(255, 0, 100, 150);
    _dotColor = _isDarkMode
        ? const Color.fromRGBO(200, 230, 241, 1)
        : const Color.fromRGBO(200, 230, 241, 1);
    _dotActiveColor = _isDarkMode
        ? const Color.fromRGBO(4, 50, 82, 0.8)
        : const Color.fromRGBO(4, 50, 82, 0.8);
    notifyListeners();
  }

//
}
