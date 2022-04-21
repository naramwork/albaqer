import 'package:albaqer/app/themes/color_const.dart';
import 'package:flutter/material.dart';

class BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final int index;
  final Function selectPage;

  const BottomNavIcon(
      {required this.icon,
      required this.active,
      required this.index,
      required this.selectPage,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectPage(index, context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            active
                ? GradientIcon(
                    icon,
                    28.0,
                    LinearGradient(
                      colors: ColorConst.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  )
                : Icon(
                    icon,
                    size: 28.0,
                    color: Theme.of(context).bottomAppBarColor,
                  ),
            const SizedBox(
              height: 5,
            ),
            active
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment
                            .bottomRight, // 10% of the width, so there are ten blinds.
                        colors: ColorConst.gradientColors, // red to yellow
                        // repeats the gradient over the canvas
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 6,
                    height: 6,
                  ),
          ],
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon(this.icon, this.size, this.gradient, {Key? key})
      : super(key: key);

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
