import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:albaqer/models/reminder.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/controllers/app_info_controller.dart';
import 'package:albaqer/controllers/edit_user_controller.dart';
import 'package:albaqer/controllers/marriage_controller.dart';
import 'package:albaqer/controllers/prayer_notification_builder.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/controllers/update_content_controler.dart';
import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/controllers/verses_controller.dart';
import 'package:albaqer/models/dua.dart';
import 'package:albaqer/models/fcm_notfication.dart';
import 'package:albaqer/models/hadith.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:albaqer/models/update_content.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/models/verse.dart';
import 'package:albaqer/theme_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/helper_files/route_list.dart';
import 'controllers/content_notification_builder.dart';
import 'controllers/notification_controller.dart';
import 'models/new_verse.dart';

int? isviewed;
void main() async {
  await initHive();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/logo',
      [
        setNewPrayerChannel(name: 'صلاة الفجر', key: 'fajer_time'),
        setNewPrayerChannel(name: 'صلاة الظهر', key: 'duhar_time'),
        setNewPrayerChannel(name: 'صلاة العصر', key: 'asr_time'),
        setNewPrayerChannel(name: 'صلاة المغرب', key: 'magrb_time'),
        setNewPrayerChannel(name: 'صلاة العشاء', key: 'isha_time'),
        setNewContentChannel(name: 'الآية اليومية', key: kVersesChannleKey),
        setNewContentChannel(name: 'الدعاء اليومي', key: kDuasChannleKey),
        setNewContentChannel(
          name: 'الحديث الشريف',
          key: kHadithChannleKey,
        ),
        NotificationChannel(
            channelKey: kFcmChannleKey,
            channelName: 'اشعارات عامة',
            channelDescription: 'الإشعارات المرسلة من فريق الإدارة',
            ledColor: Colors.white,
            defaultColor: Colors.blue,
            importance: NotificationImportance.High,
            playSound: true),
        NotificationChannel(
            channelKey: reminderChannelKey,
            channelName: 'تذكير',
            channelDescription: 'اشعارات التذكير',
            ledColor: Colors.white,
            defaultColor: Colors.blue,
            importance: NotificationImportance.High,
            playSound: true)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: kPrayerChannelGroupKey,
            channelGroupName: 'مواعيد الصلاة'),
        NotificationChannelGroup(
            channelGroupkey: kContentChannelGroupKey,
            channelGroupName: 'الإشعارات اليومية')
      ]);

  WidgetsFlutterBinding.ensureInitialized();
  NotificationController();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt(kIsFirstTimeKey);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(
    savedThemeMode: savedThemeMode,
  ));
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PrayerNotificationAdapter());
  Hive.registerAdapter(UpdateContentAdapter());
  Hive.registerAdapter(VerseAdapter());
  Hive.registerAdapter(DuaAdapter());
  Hive.registerAdapter(FcmNotificationAdapter());
  Hive.registerAdapter(HadithAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NewVerseAdapter());
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<NewVerse>(kNewVerseBoxName);
  await Hive.openBox<UpdateContent>(kUpdateContentBoxName);
  await Hive.openBox<Verse>(kVerseBoxName);
  await Hive.openBox<FcmNotification>(kFcmBoxName);
  await Hive.openBox<Dua>(kDuaBoxName);
  await Hive.openBox<Hadith>(kHadithBoxName);
  await Hive.openBox<User>(kUserBoxName);
  await Hive.openBox<Reminder>(kReminderBoxName);
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PrayerTimeController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => VersesController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UpdateContentController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MarriageController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EditUserController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AppInfoController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ColorMode(savedThemeMode == AdaptiveThemeMode.dark),
        ),
      ],
      child: ThemeWidget(
        savedThemeMode: savedThemeMode,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar', 'DZ'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'DZ'),
          ],
          theme: theme,
          darkTheme: darkTheme,
          routes: routeList(isviewed),
          builder: (context, child) {
            return ResponsiveSizer(
              builder: (buildContext, orientation, screenType) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: child ?? Container(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
