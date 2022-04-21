import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:albaqer/app/helper_files/connection_status_singleton.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';

import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';

import 'package:albaqer/views/main_layout.dart';
import 'package:albaqer/views/pages/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class NoInternetPage extends StatefulWidget {
  static String routeName = 'no_internet_page';
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  void selectPage(int index, BuildContext context) {
    Navigator.of(context).pushNamed(MainLayout.routeName, arguments: index);
  }

  @override
  void dispose() {
    _connectivity.disposeStream();

    super.dispose();
  }

  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Center(
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: context.watch<ColorMode>().isDarkMode
                      ? ColorConst.darkCardColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    context.watch<ColorMode>().isDarkMode
                        ? 'assets/images/no_wifi_dark.svg'
                        : 'assets/images/no_wifi.svg',
                    fit: BoxFit.fill,
                    width: 80.w,
                    height: 80.w,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'لا يوجد اتصال',
                    style: TextStyle(
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedButtonWidget(
                      label: const Text('إعادة المحاولة'),
                      width: 30.w,
                      onpressed: () {
                        bool isOffline =
                            _source.keys.toList()[0] == ConnectivityResult.none;
                        if (isOffline) return;
                        Navigator.pushReplacementNamed(
                            context, SplashScreen.routeName);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FAP(
        onPressed: () {
          gotToMarriagePage(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: 0,
        selectPage: selectPage,
      ),
    );
  }
}
