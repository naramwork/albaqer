import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/models/fcm_notfication.dart';
import 'package:albaqer/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';

var rng = Random();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(FcmNotificationAdapter());

  Box fcmBox = await Hive.openBox<FcmNotification>(kFcmBoxName);

  await fcmBox.add(FcmNotification(
    title: message.notification!.title ?? '',
    body: message.notification!.body ?? '',
    date: DateTime.now(),
  ));

  //createNotification(message);
}

void createNotification(RemoteMessage message) async {
  int id = rng.nextInt(1000);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: kFcmChannleKey,
          title: message.notification!.title,
          body: message.notification!.body,
          backgroundColor: const Color(0xFF184B6C),
          color: Colors.white,
          category: NotificationCategory.Message));
}

class NotificationController {
  static final NotificationController _notification =
      NotificationController._internal();
  late FirebaseMessaging messaging;

  factory NotificationController() => _notification;
  NotificationController._internal() {
    initializeFcm();
  }

  void initializeFcm() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    storeToken(token);

    messaging.onTokenRefresh.listen((data) {
      storeToken(token);
    });

    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    subscribeAndListen();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void subscribeAndListen() {
    messaging.subscribeToTopic("generalTest1");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        //storeNotification(message.notification!);
      }

      createNotification(message);
    });
  }

  // void storeNotification(RemoteNotification notification) async {
  //   Box fcmBox = Hive.box<FcmNotification>(kFcmBoxName);

  //   await fcmBox.add(FcmNotification(
  //     title: notification.title ?? '',
  //     body: notification.body ?? '',
  //     date: DateTime.now(),
  //   ));
  // }

  void storeToken(String? token) async {
    if (token == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Box userBox = Hive.box<User>(kUserBoxName);
    if (userBox.values.isNotEmpty) {
      User user = userBox.values.first as User;
      List<String> oldToken = user.fcm;

      if (oldToken.contains(token)) return;
      bool isSaved = await updateUserFcmToken(token, userBox.values.first);

      if (isSaved) prefs.setString(kStorTokenKey, token);
    } else {
      prefs.setString(kStorTokenKey, token);
    }
  }

  Future updateUserFcmToken(String token, User user) async {
    var url = Uri.parse(kUpdateUserFcmUrl);
    final updateResponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'email': user.email,
          'fire_base_token': token,
        }));

    if (updateResponse.body == "1") {
      return true;
    } else {
      return false;
    }
  }
}
