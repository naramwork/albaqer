import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoardingPageTow extends StatelessWidget {
  final Function next;
  const OnBoardingPageTow({Key? key, required this.next}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFF1e5b88),
            Color(0xFF012b65),
          ])),
      child: Stack(children: [
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/onboardingTow.svg',
                fit: BoxFit.fill,
                width: 60.w,
              ),
              SizedBox(
                height: 4.h,
              ),
              const Text(
                'زواجك مبارك',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DecoType',
                    fontWeight: FontWeight.w400,
                    fontSize: 35),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: SvgPicture.asset(
            'assets/images/onBoardingBottom.svg',
            fit: BoxFit.fill,
            width: 100.w,
          ),
        ),
        Column(
          children: [
            SvgPicture.asset(
              'assets/images/onBoardingTop.svg',
              fit: BoxFit.fill,
              width: 80.w,
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                iconSize: 9.h,
                icon: const Icon(
                  Icons.arrow_left,
                  color: Color.fromRGBO(200, 230, 241, 1),
                ),
                onPressed: () {
                  next();
                },
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ]),
    );
  }
}
