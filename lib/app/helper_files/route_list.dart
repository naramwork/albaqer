import 'package:albaqer/views/main_layout.dart';
import 'package:albaqer/views/pages/accept_user_page.dart';
import 'package:albaqer/views/pages/app_info/about_us_page.dart';
import 'package:albaqer/views/pages/app_info/call_us_page.dart';
import 'package:albaqer/views/pages/content_pages/duas_page.dart';
import 'package:albaqer/views/pages/content_pages/hadith_online_page.dart';
import 'package:albaqer/views/pages/content_pages/previous_hadith_page.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/previous_verses_page.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/verses_page.dart';
import 'package:albaqer/views/pages/holiday/holiday_page.dart';

import 'package:albaqer/views/pages/no_internet_page.dart';
import 'package:albaqer/views/pages/notification_page.dart';
import 'package:albaqer/views/pages/onboarding/onborarding_page.dart';
import 'package:albaqer/views/pages/quran/quran_result_page.dart';
import 'package:albaqer/views/pages/quran/quran_search_page.dart';

import 'package:albaqer/views/pages/reminder/reminder_page.dart';
import 'package:albaqer/views/pages/settings_page.dart';
import 'package:albaqer/views/pages/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routeList(int? isViewed) {
  return {
    SplashScreen.routeName: (context) =>
        isViewed != 0 ? const OnBoardingPage() : const SplashScreen(),
    MainLayout.routeName: (context) => const MainLayout(),
    VersesPage.routeName: (context) => const VersesPage(),
    DuasPage.routeName: (context) => const DuasPage(),
    HadithOnlinePage.routeName: (context) => const HadithOnlinePage(),
    SettingsPage.routeName: (context) => const SettingsPage(),
    NoInternetPage.routeName: (context) => const NoInternetPage(),
    AcceptUserPage.routeName: (context) => const AcceptUserPage(),
    AboutUsPage.routeName: (context) => const AboutUsPage(),
    NotificationPage.routeName: (context) => const NotificationPage(),
    CallUsPage.routeName: (context) => const CallUsPage(),
    HolidayPage.routeName: (context) => const HolidayPage(),
    QuranSearchPage.routeName: (context) => const QuranSearchPage(),
    QuranResultPage.routeName: (context) => const QuranResultPage(),
    ReminderPage.routeName: (context) => const ReminderPage(),
    PreviousVersesPage.routeName: (context) => const PreviousVersesPage(),
    PreviousHadithPage.routeName: (context) => const PreviousHadithPage(),
  };
}
