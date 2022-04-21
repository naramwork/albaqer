import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:albaqer/models/app_info.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CallUsPage extends StatelessWidget {
  static String routeName = '/call_us_page';
  const CallUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Center(
          child: Card(
            elevation: 4,
            color: context.watch<ColorMode>().isDarkMode
                ? ColorConst.darkCardColor
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: FutureBuilder<List<AppInfo>>(
                future: getCallus(),
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
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 3.h,
                              ),
                              Image.asset(
                                'assets/images/logo.png',
                                width: 30.w,
                                height: 30.w,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              ..._buildListOfWidget(snapshot.data!, context),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildSocialRow(snapshot.data!),
                              ),
                              SizedBox(
                                height: 3.h,
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
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

  List<Widget> _buildSocialRow(List<AppInfo> appInfos) {
    List<Widget> widgets = [];
    for (AppInfo appInfo in appInfos) {
      switch (appInfo.title) {
        case 'facebook':
          if (appInfo.content != '') {
            widgets.add(_buildSocialListTile(
                content: appInfo.content,
                iconData: 'assets/images/facebook.png'));
          }
          break;
        case 'twitter':
          if (appInfo.content != '') {
            widgets.add(_buildSocialListTile(
                content: appInfo.content,
                iconData: 'assets/images/twitter.png'));
          }
          break;
        case 'youtube':
          if (appInfo.content != '') {
            widgets.add(_buildSocialListTile(
                content: appInfo.content,
                iconData: 'assets/images/youtube.png'));
          }
          break;
        case 'instagram':
          if (appInfo.content != '') {
            widgets.add(_buildSocialListTile(
                content: appInfo.content,
                iconData: 'assets/images/instagram.png'));
          }

          break;
      }
    }
    return widgets;
  }

  List<Widget> _buildListOfWidget(
      List<AppInfo> appInfos, BuildContext context) {
    List<Widget> widgets = [];

    for (AppInfo appInfo in appInfos) {
      switch (appInfo.title) {
        case 'email':
          widgets.add(
            _buildListTile(
              content: appInfo.content,
              context: context,
              iconData: Icons.email,
              onTap: () {
                _sendEmail(appInfo.content);
              },
            ),
          );
          break;

        case 'phone':
          widgets.add(
            _buildListTile(
              content: appInfo.content,
              iconData: Icons.phone,
              context: context,
              onTap: () {
                _makePhoneCall(appInfo.content);
              },
            ),
          );
          break;

        case 'address':
          widgets.add(_buildAddressTile(
            content: appInfo.content,
            iconData: Icons.location_on,
            context: context,
          ));
          break;
      }
    }
    return widgets;
  }

  Widget _buildSocialListTile(
          {required String content, required String iconData}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _launchURL(content);
            },
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Image.asset(
                iconData,
                width: 9.w,
                height: 9.w,
              ),
            ),
          ),
        ),
      );

  Widget _buildListTile(
          {required String content,
          required Function() onTap,
          required IconData iconData,
          required BuildContext context}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: ColorConst.lightBlue,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                content,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
        ),
      );

  Widget _buildAddressTile(
      {required String content,
      required IconData iconData,
      required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: ColorConst.lightBlue,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            content,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                color: context.watch<ColorMode>().isDarkMode
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          )
        ],
      ),
    );
  }

  Future<List<AppInfo>> getCallus() async {
    List<AppInfo> callUsList = [];
    var url = Uri.parse(kCallUsUrl);
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    });
    if (response.body.isEmpty) return callUsList;
    final jsonExtractedList = json.decode(response.body);
    if (jsonExtractedList is List) {
      for (var jsonData in jsonExtractedList) {
        callUsList.add(
          AppInfo(title: jsonData['name'], content: jsonData['content']),
        );
      }
    } else {
      callUsList.add(
        AppInfo(
            title: jsonExtractedList['name'],
            content: jsonExtractedList['contetn']),
      );
    }
    return callUsList;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(launchUri.toString());
  }

  void _launchURL(String url) async {
    await launch(url);
  }
}
