import 'package:flutter/material.dart';

class CardTopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final BoxDecoration boxDecoration;

  const CardTopContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.child,
    required this.boxDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -(height / 2 - 5),
      right: 50,
      child: Container(
        width: width,
        height: height,
        decoration: boxDecoration,
        child: child,
      ),
    );
  }
}
