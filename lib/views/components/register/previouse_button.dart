import 'package:albaqer/app/themes/color_const.dart';
import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  final double width;
  final Function onpressed;
  final double? borderRad;

  const PreviousButton({
    Key? key,
    required this.width,
    required this.onpressed,
    this.borderRad,
  }) : super(key: key);

  final BorderRadius borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(10),
    bottomLeft: Radius.circular(10),
    topRight: Radius.circular(30),
    bottomRight: Radius.circular(30),
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
          child: const Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text('السابق'),
          ),
        ),
      ),
    );
  }
}
