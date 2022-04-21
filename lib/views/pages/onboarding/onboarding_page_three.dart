import 'dart:io';

import 'package:albaqer/controllers/update_content_controler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/prayer_time_controller.dart';
import '../../main_layout.dart';
import '../no_internet_page.dart';

class OnBoardingPageThree extends StatelessWidget {
  final Function next;
  const OnBoardingPageThree({Key? key, required this.next}) : super(key: key);

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
                'assets/images/onBoardingThree.svg',
                fit: BoxFit.fill,
                width: 60.w,
              ),
              SizedBox(
                height: 4.h,
              ),
              const Text(
                'تلاوة آيات قرأنية',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DecoType',
                    fontWeight: FontWeight.w400,
                    fontSize: 35),
              ),
              SizedBox(
                height: 4.h,
              ),
              isActiveWidget(context)
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/onBoardingTop.svg',
              fit: BoxFit.fill,
              width: 80.w,
            ),
            const Spacer(),
            SizedBox(
              height: 2.h,
              width: double.infinity,
            ),
            context.watch<UpdateContentController>().isActive &&
                    context.watch<PrayerTimeController>().canOpenApp
                ? Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      iconSize: 9.h,
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Color.fromRGBO(200, 230, 241, 1),
                      ),
                      onPressed: () {
                        openApp(context);
                      },
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: JumpingDotsProgressIndicator(
                      fontSize: 30,
                      color: Colors.white,
                    )),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ]),
    );
  }

  openApp(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    bool isOnline = await checkConnection();

    if (connectivityResult == ConnectivityResult.none || !isOnline) {
      Navigator.pushReplacementNamed(context, NoInternetPage.routeName);
    } else {
      Navigator.pushReplacementNamed(context, MainLayout.routeName);
    }
  }

  Future<bool> checkConnection() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }

    return Future.value(isOnline);
  }

  Widget isActiveWidget(BuildContext context) {
    return context.watch<UpdateContentController>().isActive
        ? Container()
        : Column(
            children: [
              const Text(
                'يتم تحميل البيانات .... الرجاء الانتظار',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DecoType',
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              SizedBox(
                height: 4.h,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          );
  }
}
