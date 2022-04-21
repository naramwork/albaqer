import 'package:albaqer/app/themes/color_const.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final double width;
  final Function onpressed;
  final double? borderRad;
  final String title;

  const NextButton({
    Key? key,
    required this.width,
    required this.onpressed,
    this.borderRad,
    this.title = 'التالي',
  }) : super(key: key);

  final BorderRadius borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomLeft: Radius.circular(30),
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: ColorConst.topCardWidgetGradient,
          borderRadius: borderRadius,
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
            ),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            minimumSize: MaterialStateProperty.all(Size(width, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
          ),
          onPressed: () {
            onpressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
