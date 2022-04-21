import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/marriage/marriage_app_bar.dart';
import 'package:albaqer/views/components/marriage/marriage_name_header.dart';
import 'package:albaqer/views/pages/marriage/message_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'marriage_requests_list.dart';

class MarriageRequestPage extends StatelessWidget {
  static String routeName = '/marriage_request_page';
  const MarriageRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarriageAppBar(
        appBar: AppBar(),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 5.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MarriageHeadCard(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(MessagePage.routeName);
                      },
                      title: 'الرسائل',
                      isActive: false,
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: MarriageHeadCard(
                      title: 'طلبات الزواج',
                      onTap: () {},
                      isActive: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                padding: EdgeInsets.only(right: 4.w),
                alignment: Alignment.centerRight,
                child: Text(
                  'طلبات الزواج',
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              const Expanded(child: MarriageRequestList())
            ],
          )),
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
}
