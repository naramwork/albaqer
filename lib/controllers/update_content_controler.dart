import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/controllers/content_notification_builder.dart';
import 'package:albaqer/models/dua.dart';
import 'package:albaqer/models/hadith.dart';
import 'package:albaqer/models/update_content.dart';
import 'package:albaqer/models/verse.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class UpdateContentController extends ChangeNotifier {
  Verse? _verseOfTheDay;
  Dua? _duaOfTheDay;
  Hadith? _hadithOfTheDay;
  bool _isActive = false;
  String _holidays = '';

  late List<Verse> _verses;
  late List<Dua> _duas;
  late List<Hadith> _hadiths;

  List<Verse> get verses => _verses;
  List<Dua> get duas => _duas;
  List<Hadith> get hadith => _hadiths;
  bool get isActive => _isActive;
  String get holidays => _holidays;

  Verse? get verseOfTheDay => _verseOfTheDay;
  Dua? get duaOfTheDay => _duaOfTheDay;
  Hadith? get hadithOfTheDay => _hadithOfTheDay;

  Future<bool> getOfTheDayOffline() async {
    Box versesBox = Hive.box<Verse>(kVerseBoxName);
    Box duaBox = Hive.box<Dua>(kDuaBoxName);
    Box hadithBox = Hive.box<Hadith>(kHadithBoxName);

    List<Verse> versesList = versesBox.values.toList() as List<Verse>;
    List<Dua> duaList = duaBox.values.toList() as List<Dua>;
    List<Hadith> hadithList = hadithBox.values.toList() as List<Hadith>;
    setStartValues(
        versesList: versesList, hadithList: hadithList, duaList: duaList);
    if (_verseOfTheDay == null ||
        _hadithOfTheDay == null ||
        _duaOfTheDay == null) return Future.value(false);
    return Future.value(true);
  }

  Future<bool> checkForUpdates() async {
    var updateContentBox = Hive.box<UpdateContent>(kUpdateContentBoxName);
    Box versesBox = Hive.box<Verse>(kVerseBoxName);
    Box duaBox = Hive.box<Dua>(kDuaBoxName);
    Box hadithBox = Hive.box<Hadith>(kHadithBoxName);
    var url = Uri.parse(kGetUpdateUrl);

    try {
      final response = await http.get(url);

      final jsonExtractedList = json.decode(response.body);
      await firstTimeInit(
          body: jsonExtractedList,
          versesBox: versesBox,
          updateContentBox: updateContentBox,
          duaBox: duaBox,
          hadithBox: hadithBox);

      return true;
    } catch (error) {
      return false;
    }
  }

/* Add all Content data to the local data base when first time opened th app */
  Future<void> firstTimeInit({
    required var body,
    required Box versesBox,
    required Box updateContentBox,
    required Box duaBox,
    required Box hadithBox,
  }) async {
    List<Hadith> hadithList = [];
    List<Verse> versesList = [];
    List<Dua> duaList = [];

    //add UpdateContentInfo To Box
    final holidaysData = body['holiday'] as List<dynamic>;
    for (var holidayObject in holidaysData) {
      if (holidayObject['content'] != null) {
        _holidays += holidayObject['content'] + '\n';
      }
    }

    // add Verses To VersesBox
    if (versesBox.isOpen) {
      if (versesBox.isNotEmpty) {
        versesBox.clear();
      }
      final verseslistData = body['verses'] as List<dynamic>;
      for (var versesObject in verseslistData) {
        if (versesObject['content'] != null) {
          versesList.add(Verse.fromJson(versesObject));
        }
      }

      versesBox.addAll(versesList);
    }

    //add DuaContent To Box
    if (duaBox.isOpen) {
      if (duaBox.isNotEmpty) {
        duaBox.clear();
      }
      final listData = body['dua'] as List<dynamic>;
      for (var duaObject in listData) {
        if (duaObject['content'] != null) {
          duaList.add(Dua.fromJson(duaObject));
        }
      }
      duaBox.addAll(duaList);
    }

    //add HadithContent To Box
    if (hadithBox.isOpen) {
      if (hadithBox.isNotEmpty) {
        hadithBox.clear();
      }
      final listData = body['hadith'] as List<dynamic>;
      for (var hadithObject in listData) {
        if (hadithObject['content'] != null) {
          hadithList.add(Hadith.fromJson(hadithObject));
        }
      }
      hadithBox.addAll(hadithList);
    }

    setStartValues(
        versesList: versesList, hadithList: hadithList, duaList: duaList);
  }

  /* set the contentOfTheDay and Notifiy listener */
  void setStartValues(
      {required List<Verse> versesList,
      required List<Hadith> hadithList,
      required List<Dua> duaList}) {
    _duas = duaList;
    generateWeekVersesNotification(versesList.toList());

    _verseOfTheDay = versesList.first;
    _duas = duaList
            .where((element) =>
                element.order >= DateTime.now().weekday &&
                DateTime.now().weekday < 8)
            .toList() +
        duaList
            .where((element) => element.order < DateTime.now().weekday)
            .toList();

    generateWeekDuaNotification(duaList.take(3).toList());

    _duaOfTheDay =
        duaList.firstWhere((dua) => dua.order == DateTime.now().weekday);
    generateWeekHadithNotification(hadithList.toList());

    _hadithOfTheDay = hadithList.first;
    _isActive = true;
    notifyListeners();
  }
}
