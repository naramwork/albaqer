import 'package:albaqer/views/main_layout.dart';
import 'package:albaqer/views/pages/accept_user_page.dart';
import 'package:albaqer/views/pages/app_info/about_us_page.dart';
import 'package:albaqer/views/pages/app_info/call_us_page.dart';
import 'package:albaqer/views/pages/app_info/marriage_explain_page.dart';
import 'package:albaqer/views/pages/content_pages/duas_page.dart';
import 'package:albaqer/views/pages/content_pages/hadith_online_page.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/previous_verses_page.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/verses_page.dart';
import 'package:albaqer/views/pages/edit_user_page.dart';
import 'package:albaqer/views/pages/holiday/holiday_page.dart';
import 'package:albaqer/views/pages/marriage/marriage_page.dart';
import 'package:albaqer/views/pages/marriage/marriage_requests_page.dart';
import 'package:albaqer/views/pages/marriage/message_page.dart';
import 'package:albaqer/views/pages/marriage/partner_info_page.dart';
import 'package:albaqer/views/pages/no_internet_page.dart';
import 'package:albaqer/views/pages/notification_page.dart';
import 'package:albaqer/views/pages/onboarding/onborarding_page.dart';
import 'package:albaqer/views/pages/quran/quran_result_page.dart';
import 'package:albaqer/views/pages/quran/quran_search_page.dart';
import 'package:albaqer/views/pages/register/login_page.dart';
import 'package:albaqer/views/pages/register/sign_up_page.dart';
import 'package:albaqer/views/pages/reminder/reminder_page.dart';
import 'package:albaqer/views/pages/settings_page.dart';
import 'package:albaqer/views/pages/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routeList(int? isViewed) {
  return {
    SplashScreen.routeName: (context) =>
        isViewed != 0 ? const OnBoardingPage() : const SplashScreen(),
    MainLayout.routeName: (context) => const MainLayout(),
    SignUpPage.routeName: (context) => const SignUpPage(),
    LoginPage.routeName: (context) => const LoginPage(),
    VersesPage.routeName: (context) => const VersesPage(),
    DuasPage.routeName: (context) => const DuasPage(),
    HadithOnlinePage.routeName: (context) => const HadithOnlinePage(),
    SettingsPage.routeName: (context) => const SettingsPage(),
    MarriagePage.routeName: (context) => const MarriagePage(),
    PartnerInfoPage.routeName: (context) => const PartnerInfoPage(),
    NoInternetPage.routeName: (context) => const NoInternetPage(),
    MessagePage.routeName: (context) => const MessagePage(),
    EditUserPage.routeName: (context) => const EditUserPage(),
    AcceptUserPage.routeName: (context) => const AcceptUserPage(),
    AboutUsPage.routeName: (context) => const AboutUsPage(),
    NotificationPage.routeName: (context) => const NotificationPage(),
    CallUsPage.routeName: (context) => const CallUsPage(),
    HolidayPage.routeName: (context) => const HolidayPage(),
    MarriageExplainPage.routeName: (context) => const MarriageExplainPage(),
    MarriageRequestPage.routeName: (context) => const MarriageRequestPage(),
    QuranSearchPage.routeName: (context) => const QuranSearchPage(),
    QuranResultPage.routeName: (context) => const QuranResultPage(),
    ReminderPage.routeName: (context) => const ReminderPage(),
    PreviousVersesPage.routeName: (context) => const PreviousVersesPage(),
  };
}
