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

class MarriageExplainPage extends StatelessWidget {
  static String routeName = '/marriage_explain_page';
  const MarriageExplainPage({Key? key}) : super(key: key);

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
                future: getMarriageExplain(),
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
                            horizontal: 5.w, vertical: 3.h),
                        decoration: BoxDecoration(
                            color: context.watch<ColorMode>().isDarkMode
                                ? ColorConst.darkCardColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 30.w,
                                height: 30.w,
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
                              Text(
                                snapshot.data?.content ?? '',
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
                            ],
                          ),
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

  Future<AppInfo> getMarriageExplain() async {
    var url = Uri.parse(kMarriageExplainUrl);
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
