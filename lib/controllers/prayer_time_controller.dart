import 'dart:math';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/controllers/prayer_notification_builder.dart';
import 'package:albaqer/models/arabic_date.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeController with ChangeNotifier {
  late ArabicDate _arabicDate;
  late PrayerTimes _prayerTimes;
  bool _locationError = false;
  bool _canOpenApp = false;
  Position? location;

  String _locationName = 'غير محدد';

  ArabicDate get arabicDate => _arabicDate;
  PrayerTimes get prayerTimes => _prayerTimes;

  String get locationName => _locationName;
  bool get locationError => _locationError;
  bool get canOpenApp => _canOpenApp;

  Future initPrayerTime({int second = 6}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    initializeDateFormatting("ar_DZ", null).then((_) {
      HijriCalendar.setLocal("ar");
      HijriCalendar _today = HijriCalendar.fromDate(
        DateTime.now().add(Duration(days: prefs.getInt(kChangeHijriDate) ?? 0)),
      );

      setPrayerVars(_today);
    });

    _prayerTimes = await getPrayerTime(second: second);

    _canOpenApp = true;
    notifyListeners();

    return _locationError;
  }

  String getNearestAzanTime() {
    String timeRemaining = '';

    DateTime now = DateTime.now();

    DateTime? azanTime =
        _prayerTimes.timeForPrayer(skipPrayer(_prayerTimes.nextPrayer()));
    if (azanTime == null) return '';
    var timeDifference = azanTime.difference(now);

    int minutes = timeDifference.inMinutes;
    int hours = timeDifference.inHours;

    if (hours > 0) {
      switch (hours) {
        case 1:
          timeRemaining = 'ساعة';
          break;
        case 2:
          timeRemaining = 'ساعتين';
          break;
        default:
          timeRemaining = '$hours ساعات ';
      }
    } else {
      if (minutes < 10) {
        switch (minutes) {
          case 1:
            timeRemaining = 'دقيقة';
            break;
          case 2:
            timeRemaining = 'دقيقتين';
            break;
          default:
            timeRemaining = '$minutes دقائق ';
        }
      } else {
        timeRemaining = '$minutes دقيقة ';
      }
    }
    String azanName = getArabicAzanName(skipPrayer(_prayerTimes.nextPrayer()));
    if (azanName.isEmpty || timeRemaining.isEmpty) return '';
    return 'تبقى $timeRemaining لآذان $azanName';
  }

  String getArabicAzanName(String prayer) {
    if (prayer == Prayer.Fajr) {
      return 'الفجر';
    } else if (prayer == Prayer.Sunrise) {
      return 'شروق الشمس';
    } else if (prayer == Prayer.Dhuhr) {
      return 'الظهر';
    } else if (prayer == Prayer.Asr) {
      return 'العصر';
    } else if (prayer == Prayer.Maghrib) {
      return 'المغرب';
    } else if (prayer == Prayer.Isha) {
      return 'العشاء';
    } else if (prayer == Prayer.IshaBefore) {
      return 'العشاء';
    } else if (prayer == Prayer.FajrAfter) {
      return 'الفجر';
    } else {
      return '';
    }
  }

  String skipPrayer(String nextPrye) {
    if (nextPrye == Prayer.Sunrise) {
      return Prayer.Dhuhr;
    } else if (nextPrye == Prayer.IshaBefore) {
      return Prayer.Isha;
    }
    return nextPrye;
  }

  String nextAzanTime() {
    String time = '';
    DateTime? azanTime;
    if (_prayerTimes.nextPrayer() == Prayer.Sunrise) {
      azanTime = _prayerTimes.timeForPrayer(Prayer.Dhuhr);
    } else {
      azanTime = _prayerTimes.timeForPrayer(_prayerTimes.nextPrayer());
    }
    time = DateFormat.jm('ar_Dz').format(azanTime!.toLocal()).toString();
    return 'موعد الآذان $time';
  }

  void setPrayerVars(HijriCalendar hijriDate) {
    String monthName = hijriDate.getLongMonthName();
    String day = hijriDate.hDay.toString();
    String dayName = hijriDate.getDayName();
    String year = hijriDate.hYear.toString();

    _arabicDate = ArabicDate(
        monthName: monthName,
        dayName: dayName,
        day: day,
        year: year,
        gregorianDate: DateFormat.yMMMd('ar_DZ').format(DateTime.now()));
    notifyListeners();
  }

  getLocation({int second = 6}) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.3');
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location services are disabled.2');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        throw Exception('Location services are disabled.1');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: second));
      _locationError = false;

      return position;
    } catch (e) {
      _locationError = true;
      notifyListeners();

      return Position(
          longitude: 47.4979476,
          latitude: 29.2733964,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0);
    }
  }

  Future<PrayerTimes> getPrayerTime({int second = 6}) async {
    location = await getLocation(second: second);
    try {
      geo
          .placemarkFromCoordinates(location!.latitude, location!.longitude,
              localeIdentifier: 'ar_SA')
          .then((placemarks) {
        if (!locationError) {
          String? city = placemarks.first.locality;
          if (placemarks.first.locality == null) {
            city = placemarks.first.administrativeArea;
          } else if (placemarks.first.locality != null &&
              placemarks.first.locality!.isEmpty) {
            city = placemarks.first.administrativeArea;
          }
          _locationName = '$city - ${placemarks.first.country}';
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
    }
    DateTime date = DateTime.now();

    Coordinates coordinates =
        Coordinates(location!.latitude, location!.longitude);
    CalculationParameters params = await getPrayerCalculationParam();

    PrayerTimes prayerTimes = PrayerTimes(coordinates, date, params);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //add userPrefs To TimePrayer
    if (prefs.getBool(kIsShi3iKey) ?? false) {
      prayerTimes.maghrib =
          prayerTimes.maghrib!.add(const Duration(minutes: 15));
      prayerTimes.fajr = prayerTimes.fajr!.add(const Duration(minutes: 11));
    }
    prayerTimes.fajr = prayerTimes.fajr!
        .add(Duration(minutes: prefs.getInt(Prayer.Fajr) ?? 0));
    prayerTimes.dhuhr = prayerTimes.dhuhr!
        .add(Duration(minutes: prefs.getInt(Prayer.Dhuhr) ?? 0));
    prayerTimes.asr =
        prayerTimes.asr!.add(Duration(minutes: prefs.getInt(Prayer.Asr) ?? 0));
    prayerTimes.maghrib = prayerTimes.maghrib!
        .add(Duration(minutes: prefs.getInt(Prayer.Maghrib) ?? 0));
    prayerTimes.isha = prayerTimes.isha!
        .add(Duration(minutes: prefs.getInt(Prayer.Isha) ?? 0));
    return Future.value(prayerTimes);
  }

  changePrayerTime() async {
    setWeeklyPrayerTime();
    _prayerTimes = await getPrayerTime(second: 6);
    notifyListeners();
  }

  Future setPrayerCalculationParam(bool isShafi, bool isShi3i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(kIsShafiKey, isShafi);
    prefs.setBool(kIsShi3iKey, isShi3i);
    _prayerTimes = await getPrayerTime();

    setWeeklyPrayerTime();
    notifyListeners();
    return;
  }

  Future<CalculationParameters> getPrayerCalculationParam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CalculationParameters params = CalculationMethod.MuslimWorldLeague();
    bool isShafi = prefs.getBool(kIsShafiKey) ?? true;

    params.madhab = isShafi ? Madhab.Shafi : Madhab.Hanafi;

    return params;
  }

  void setWeeklyPrayerTime() async {
    // check if the user cancel all prayer notification from settings page

    await AwesomeNotifications().cancelNotificationsByChannelKey('fajer_time');
    await AwesomeNotifications().cancelNotificationsByChannelKey('duhar_time');
    await AwesomeNotifications().cancelNotificationsByChannelKey('asr_time');
    await AwesomeNotifications().cancelNotificationsByChannelKey('magrb_time');
    await AwesomeNotifications().cancelNotificationsByChannelKey('isha_time');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isActive = prefs.getBool(isPrayerNotificationActiveKey) ?? true;
    if (!isActive) return;

    Box prayerNotificationBox =
        Hive.box<PrayerNotification>(kNotificationBoxName);

    prayerNotificationBox.clear();

    List<PrayerNotification> weeklyPrayer = [];
    location ??= await getLocation();
    Coordinates coordinates =
        Coordinates(location!.latitude, location!.longitude);

    for (int i = 0; i <= 1; i++) {
      DateTime day = DateTime.now().add(Duration(days: i));
      CalculationParameters params = await getPrayerCalculationParam();
      PrayerTimes prayerTime = PrayerTimes(coordinates, day, params);

      if (prefs.getBool(isFajerNotificationActiveKey) ?? true) {
        weeklyPrayer.add(
          buildNotificationModel(
              'صلاة الفجر',
              prayerTime.fajr!
                  .add(Duration(minutes: prefs.getInt(Prayer.Fajr) ?? 0)),
              'fajer_time'),
        );
      }
      if (prefs.getBool(isDuharNotificationActiveKey) ?? true) {
        weeklyPrayer.add(buildNotificationModel(
            'صلاة الظهر',
            prayerTime.dhuhr!
                .add(Duration(minutes: prefs.getInt(Prayer.Dhuhr) ?? 0)),
            'duhar_time'));
      }
      if (prefs.getBool(isAsrNotificationActiveKey) ?? true) {
        weeklyPrayer.add(buildNotificationModel(
            'صلاة العصر',
            prayerTime.asr!
                .add(Duration(minutes: prefs.getInt(Prayer.Asr) ?? 0)),
            'asr_time'));
      }
      if (prefs.getBool(isMagrbNotificationActiveKey) ?? true) {
        DateTime salahTime = prayerTime.maghrib!;
        if (prefs.getBool(kIsShi3iKey) ?? false) {
          salahTime = prayerTime.maghrib!.add(
            Duration(
              minutes: 15 + (prefs.getInt(Prayer.Maghrib) ?? 0),
            ),
          );
        }

        weeklyPrayer.add(
            buildNotificationModel('صلاة المغرب', salahTime, 'magrb_time'));
      }
      if (prefs.getBool(isIshaNotificationActiveKey) ?? true) {
        weeklyPrayer.add(buildNotificationModel(
            'صلاة العشاء',
            prayerTime.isha!
                .add(Duration(minutes: prefs.getInt(Prayer.Isha) ?? 0)),
            'isha_time'));
      }
    }
    prayerNotificationBox.addAll(weeklyPrayer);
    generateWeekPrayerNotification(weeklyPrayer);
  }

  PrayerNotification buildNotificationModel(
      String name, DateTime prayerTime, String key) {
    var rng = Random();

    return PrayerNotification(
        id: createUniqueId(prayerTime) + rng.nextInt(1000),
        salahName: name,
        salahTime: convertTimeToString(prayerTime),
        day: DateFormat.EEEE('ar_Dz').format(prayerTime),
        date: prayerTime,
        channelKey: key);
  }

  String convertTimeToString(DateTime? dateTime) {
    return DateFormat.jms('ar_Dz').format(dateTime!.toLocal()).toString();
  }
}
