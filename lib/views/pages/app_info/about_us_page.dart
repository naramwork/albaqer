import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/app_info.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  static String routeName = '/about_us';
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Center(
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: FutureBuilder<AppInfo>(
                future: getAboutUs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text(
                        'لا يوجد اتصال',
                        style: TextStyle(
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      );
                    } else if (snapshot.hasData) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                            color: context.watch<ColorMode>().isDarkMode
                                ? ColorConst.darkCardColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 20.w,
                              height: 20.w,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              snapshot.data?.title ?? '',
                              style: TextStyle(
                                  color: context.watch<ColorMode>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Expanded(
                              child: SizedBox(
                                child: SingleChildScrollView(
                                  child: Text(
                                    snapshot.data?.content ?? '',
                                    style: TextStyle(
                                        color: context
                                                .watch<ColorMode>()
                                                .isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Divider(
                              color: context.watch<ColorMode>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _launchURL('https://dr-social.com/');
                                    },
                                    child: Image.asset(
                                      context.watch<ColorMode>().isDarkMode
                                          ? 'assets/images/dr_white.png'
                                          : 'assets/images/dr_black.png',
                                      width: 20.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    ':Produced by',
                                    style: TextStyle(
                                        color: context
                                                .watch<ColorMode>()
                                                .isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text('لا يوجد');
                    }
                  } else {
                    return Text('حالة الإتصال: ${snapshot.connectionState}');
                  }
                }),
          ),
        ),
      ),
      floatingActionButton: FAP(
        onPressed: () {
          gotToMarriagePage(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(
        selectedIndex: 0,
        selectPage: selectPage,
      ),
    );
  }

  void _launchURL(String url) async {
    await launch(url);
  }

  Future<AppInfo> getAboutUs() async {
    var url = Uri.parse(kAboutUsUrl);
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    });

    if (response.body.isEmpty) return AppInfo(title: '', content: '');
    final jsonExtractedList = json.decode(response.body);
    if (jsonExtractedList.containsKey("content")) {
      return AppInfo(
          title: jsonExtractedList['name'],
          content: jsonExtractedList['content']);
    }

    return AppInfo(title: '', content: '');
  }
}
