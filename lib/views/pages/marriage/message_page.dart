import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/marriage_controller.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/marriage/marriage_app_bar.dart';
import 'package:albaqer/views/components/marriage/marriage_name_header.dart';
import 'package:albaqer/views/pages/marriage/marriage_requests_page.dart';
import 'package:albaqer/views/pages/marriage/message_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessagePage extends StatefulWidget {
  static String routeName = '/message_page';
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isLoading = true;

  @override
  void initState() {
    context
        .read<MarriageController>()
        .getMessages()
        .then((value) => isLoading = false);
    context.read<MarriageController>().getMarriageRequests();
    super.initState();
  }

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
                      onTap: () {},
                      title: 'الرسائل',
                      isActive: true,
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: MarriageHeadCard(
                      isActive: false,
                      title: 'طلبات الزواج',
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            MarriageRequestPage.routeName);
                      },
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
                  'الرسائل',
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
              const Expanded(child: MessageList())
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
