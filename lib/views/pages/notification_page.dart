import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/models/fcm_notfication.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/marriage/marriage_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = '/notification_page';
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MarriageAppBar(
        appBar: AppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: FutureBuilder<List<FcmNotification>>(
            future: getNotification(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                  return ListView.builder(
                      itemBuilder: (context, i) {
                        List<FcmNotification> fcm =
                            snapshot.data!.reversed.toList();
                        return NotificationCard(fcmNotification: fcm[i]);
                      },
                      itemCount: snapshot.data!.length);
                } else {
                  return const Text('لا يوجد');
                }
              } else {
                return Text('حالة الإتصال: ${snapshot.connectionState}');
              }
            }),
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

  Future<List<FcmNotification>> getNotification() async {
    var url = Uri.parse(kNotification);
    List<FcmNotification> notifications = [];
    try {
      final response = await http.get(url);

      final jsonExtractedList = json.decode(response.body);
      for (var notificationJson in jsonExtractedList) {
        notifications.add(
          FcmNotification(
              title: notificationJson['title'],
              body: notificationJson['body'],
              date: DateTime.parse(notificationJson['created_at'])),
        );
      }
      return notifications;
    } catch (error) {
      return notifications;
    }
  }
}

class NotificationCard extends StatelessWidget {
  final FcmNotification fcmNotification;
  const NotificationCard({Key? key, required this.fcmNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.watch<ColorMode>().isDarkMode
                ? ColorConst.darkCardColor
                : Colors.grey.shade50,
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  fcmNotification.title,
                  style: TextStyle(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                fcmNotification.body,
                style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 3.h,
              ),
              Divider(
                color: context.watch<ColorMode>().isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('y-M-d').format(fcmNotification.date),
                    style: TextStyle(
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Material(
                    color: context.watch<ColorMode>().isDarkMode
                        ? ColorConst.darkCardColor
                        : Colors.grey.shade50,
                    child: Container(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Share.share(
                            '${DateFormat('y-M-d').format(fcmNotification.date)}  | ${fcmNotification.body}',
                          );
                        },
                        icon: Icon(
                          Icons.share_outlined,
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


// ValueListenableBuilder<Box>(
//           valueListenable: Hive.box<FcmNotification>(kFcmBoxName).listenable(),
//           builder: (context, box, widget) {
//             return ListView.builder(
//               itemBuilder: (context, i) {
//                 FcmNotification fcmNotification = box.values.elementAt(i);

//                 return NotficaitonCard(
//                   fcmNotification: fcmNotification,
//                 );
//               },
//               itemCount: box.values.length,
//             );
//           },
//         ),