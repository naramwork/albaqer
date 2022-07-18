import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/name_header_card.dart';
import 'package:albaqer/views/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = 'settings_page';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void selectPage(int index, BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed(MainLayout.routeName, arguments: index);
  }

  late SharedPreferences prefs;
  bool isSwitched = true;
  @override
  void initState() {
    setSwitchValue();

    super.initState();
  }

  void setSwitchValue() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool(isPrayerNotificationActiveKey) ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            const NameHeaderCard(title: 'الإعدادات'),
            SizedBox(
              height: 4.h,
            ),
            SettingCardContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    'التنبيه بمواعيد الصلاة',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black),
                    maxLines: 1,
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      prefs.setBool(isPrayerNotificationActiveKey, value);
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Card(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(40)),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(40)),
                      color: context.watch<ColorMode>().isDarkMode
                          ? const Color(0xFF184B6C)
                          : Colors.grey.shade100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'تفعيل الوضع الليلي',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black),
                        maxLines: 1,
                      ),
                      Switch(
                        value: context.watch<ColorMode>().isDarkMode,
                        onChanged: (value) {
                          changeTheme(context);
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),

            SizedBox(
              height: 2.h,
            ),
            // SettingCardContainer(
            //     child: Material(
            //   color: Colors.transparent,
            //   child: InkWell(
            //     onTap: () {
            //       User? user = context.read<UserController>().user;
            //       if (user == null) {
            //         Navigator.of(context).pushNamed(LoginPage.routeName);
            //       } else {
            //         showModalBottomSheet(
            //             shape: const RoundedRectangleBorder(
            //               borderRadius:
            //                   BorderRadius.vertical(top: Radius.circular(30)),
            //             ),
            //             context: context,
            //             builder: (context) {
            //               return SendMessageAdminModal(
            //                 currentUser: user,
            //               );
            //             });
            //       }
            //     },
            //     child: Container(
            //       alignment: Alignment.center,
            //       padding: EdgeInsets.symmetric(vertical: 2.h),
            //       child: AutoSizeText(
            //         'ابلاغ إساءة',
            //         style: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 16,
            //             color: context.watch<ColorMode>().isDarkMode
            //                 ? Colors.white
            //                 : Colors.black),
            //         maxLines: 1,
            //       ),
            //     ),
            //   ),
            // ))
          ],
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

  void changeTheme(BuildContext context) async {
    bool isDarkMode = context.read<ColorMode>().isDarkMode;
    if (isDarkMode) {
      AdaptiveTheme.of(context).setLight();
    } else {
      AdaptiveTheme.of(context).setDark();
    }
    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    context
        .read<ColorMode>()
        .changeColorMode(savedThemeMode == AdaptiveThemeMode.dark);
  }
}

class SettingCardContainer extends StatelessWidget {
  final Widget child;
  const SettingCardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(40)),
                color: context.watch<ColorMode>().isDarkMode
                    ? const Color(0xFF184B6C)
                    : Colors.grey.shade100),
            child: child),
      ),
    );
  }
}
