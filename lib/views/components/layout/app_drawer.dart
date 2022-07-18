import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/views/pages/app_info/about_us_page.dart';
import 'package:albaqer/views/pages/app_info/call_us_page.dart';
import 'package:albaqer/views/pages/holiday/holiday_page.dart';
import 'package:albaqer/views/pages/reminder/reminder_page.dart';

import 'package:albaqer/views/pages/settings_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function? onTap;
  const AppDrawer({Key? key, this.selectedIndex = 0, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.w,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
        child: Drawer(
          elevation: 6,
          child: Container(
            color: context.watch<ColorMode>().isDarkMode
                ? const Color.fromARGB(255, 0, 10, 22)
                : Colors.white,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Center(
                  child: Image(
                    image: const AssetImage('assets/images/no_bg_logo.png'),
                    width: 30.w,
                    height: 20.h,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.5,
                  indent: 5.w,
                  endIndent: 5.w,
                ),
                SizedBox(
                  height: 1.h,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      MenuListITem(
                        itemIndex: 0,
                        selectedIndex: selectedIndex,
                        outlineIcon: Icons.home_outlined,
                        fillIcon: Icons.home,
                        label: 'الرئيسية',
                        onTap: () {
                          Navigator.pop(context);
                          onTap!(0, context);
                        },
                      ), // 0

                      MenuListITem(
                        itemIndex: 1,
                        selectedIndex: selectedIndex,
                        outlineIcon: Icons.play_arrow_outlined,
                        fillIcon: Icons.play_arrow,
                        label: 'آيات قرآنية',
                        onTap: () {
                          Navigator.pop(context);
                          onTap!(1, context);
                        },
                      ), // 2
                      MenuListITemWithImage(
                        itemIndex: 2,
                        selectedIndex: selectedIndex,
                        outlineIcon: 'assets/images/mosque_outlined.png',
                        fillIcon: 'assets/images/mosque_icon.png',
                        label: 'الحديث الشريف',
                        onTap: () {
                          Navigator.pop(context);
                          onTap!(2, context);
                        },
                      ), // 3

                      MenuListITemWithImage(
                        itemIndex: 3,
                        selectedIndex: selectedIndex,
                        outlineIcon: 'assets/images/praying_outlined.png',
                        fillIcon: 'assets/images/praying.png',
                        label: 'مواعيد الصلاة',
                        onTap: () {
                          Navigator.pop(context);
                          onTap!(3, context);
                        },
                      ), // 4
                      MenuListITemWithImage(
                        itemIndex: 4,
                        selectedIndex: selectedIndex,
                        outlineIcon: 'assets/images/holiday_ouline.png',
                        fillIcon: 'assets/images/holiday.png',
                        label: 'المناسبات',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, HolidayPage.routeName);
                        },
                      ),
                      MenuListITemWithImage(
                        itemIndex: 5,
                        selectedIndex: selectedIndex,
                        outlineIcon: 'assets/images/reminder_outline.png',
                        fillIcon: 'assets/images/reminder.png',
                        label: 'اجندة مواعيد واعمال',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ReminderPage.routeName);
                        },
                      ), // 4
                      MenuListITem(
                        itemIndex: 11,
                        selectedIndex: selectedIndex,
                        outlineIcon: Icons.settings_outlined,
                        fillIcon: Icons.settings,
                        label: 'الإعدادت',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SettingsPage.routeName);
                        },
                      ),
                      // 5
                      // MenuListITem(
                      //     itemIndex: 13,
                      //     selectedIndex: selectedIndex,
                      //     outlineIcon: Icons.error_outline,
                      //     fillIcon: Icons.error,
                      //     label: 'ابلاغ إساءة',
                      //     onTap: () {
                      //       User? user = context.read<UserController>().user;
                      //       if (user == null) {
                      //         Navigator.of(context)
                      //             .pushNamed(LoginPage.routeName);
                      //       } else {
                      //         showModalBottomSheet(
                      //             shape: const RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.vertical(
                      //                   top: Radius.circular(30)),
                      //             ),
                      //             context: context,
                      //             builder: (context) {
                      //               return SendMessageAdminModal(
                      //                 currentUser: user,
                      //               );
                      //             });
                      //       }
                      //     }),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.5,
                        indent: 5.w,
                        endIndent: 5.w,
                      ),

                      MenuListITem(
                        itemIndex: 13,
                        selectedIndex: selectedIndex,
                        outlineIcon: Icons.error_outline,
                        fillIcon: Icons.error,
                        label: 'حول التطبيق',
                        onTap: () {
                          Navigator.pushNamed(context, AboutUsPage.routeName);
                        },
                      ),
                      // 6// 6
                      MenuListITem(
                        itemIndex: 15,
                        selectedIndex: selectedIndex,
                        outlineIcon: Icons.call_outlined,
                        fillIcon: Icons.call,
                        label: 'اتصل بنا',
                        onTap: () {
                          Navigator.pushNamed(context, CallUsPage.routeName);
                        },
                      ),

                      SizedBox(
                        height: 5.h,
                      ), // 7
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuListITem extends StatelessWidget {
  const MenuListITem({
    Key? key,
    required this.selectedIndex,
    required this.itemIndex,
    required this.onTap,
    required this.label,
    required this.outlineIcon,
    required this.fillIcon,
  }) : super(key: key);

  final int itemIndex;
  final int selectedIndex;
  final Function onTap;
  final String label;
  final IconData outlineIcon;
  final IconData fillIcon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () {
          onTap();
        },
        leading: Icon(
          selectedIndex == itemIndex ? fillIcon : outlineIcon,
          color: selectedIndex == itemIndex
              ? ColorConst.lightBlue
              : Colors.grey.shade400,
        ),
        title: Text(
          label,
          style: selectedIndex == itemIndex
              ? theme.textTheme.headline2!.copyWith(color: ColorConst.lightBlue)
              : theme.textTheme.headline2,
        ),
      ),
    );
  }
}

class MenuListITemWithImage extends StatelessWidget {
  const MenuListITemWithImage({
    Key? key,
    required this.selectedIndex,
    required this.itemIndex,
    required this.onTap,
    required this.label,
    required this.outlineIcon,
    required this.fillIcon,
  }) : super(key: key);

  final int itemIndex;
  final int selectedIndex;
  final Function onTap;
  final String label;
  final String outlineIcon;
  final String fillIcon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () {
          onTap();
        },
        leading: ImageIcon(
          AssetImage(selectedIndex == itemIndex ? fillIcon : outlineIcon),
          color: selectedIndex == itemIndex
              ? ColorConst.lightBlue
              : Colors.grey.shade500,
        ),
        title: Text(
          label,
          style: selectedIndex == itemIndex
              ? theme.textTheme.headline2!.copyWith(color: ColorConst.lightBlue)
              : theme.textTheme.headline2,
        ),
      ),
    );
  }
}
