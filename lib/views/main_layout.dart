import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/views/components/layout/app_drawer.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/pages/content_pages/all_content_page.dart';
import 'package:albaqer/views/pages/home_page.dart';
import 'package:albaqer/views/pages/no_internet_page.dart';
import 'package:albaqer/views/pages/notification_page.dart';

import 'package:albaqer/views/pages/quran/quran_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'pages/prayer_times/prayer_times_page.dart';

class MainLayout extends StatefulWidget {
  static const routeName = '/main';

  final int? index;
  const MainLayout({Key? key, this.index}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const QuranPage(),
    const AllContentPage(),
    const PrayerTimesPage(),
  ];

  void selectPage(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    final route = ModalRoute.of(context);
    if (route != null) {
      final args = route.settings.arguments;
      if (args != null) {
        _selectedIndex = args as int;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool value = await showDialog(
            context: context, builder: (ctx) => showAlertDialog(context));

        return Future.value(value);
      },
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(right: 3.w),
                width: 40.w,
                child: IconButton(
                  icon: ImageIcon(
                    const AssetImage('assets/images/menu.png'),
                    color: Theme.of(context).bottomAppBarColor,
                    size: 5.w,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).bottomAppBarColor,
                  size: 5.w,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, NotificationPage.routeName);
                },
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        drawer: AppDrawer(
          selectedIndex: _selectedIndex,
          onTap: selectPage,
        ),
        body: (_selectedIndex == -1)
            ? const NoInternetPage()
            : IndexedStack(
                index: widget.index ?? _selectedIndex,
                children: _pages,
              ),
        floatingActionButton: FAP(
          onPressed: () {
            gotToMarriagePage(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomAppBar(
          selectedIndex: _selectedIndex,
          selectPage: selectPage,
        ),
      ),
    );
  }

  AlertDialog showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    return AlertDialog(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "إلى اللقاء",
        style: TextStyle(
            color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      content: const Text(
        "هل تريد مغادرة التطبيق ؟",
        style: TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w400),
      ),
      actions: [
        TextButton(
          child: const Text("إلغاء",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text("متابعة",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        )
      ],
    );
  }
}
