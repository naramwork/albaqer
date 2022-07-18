import 'package:albaqer/app/helper_files/app_const.dart';

import 'package:albaqer/models/hadith.dart';
import 'package:albaqer/models/surah.dart';
import 'package:albaqer/models/verse.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VersesController extends ChangeNotifier {
  late List<Verse> _verses;
  final List<Surah> _fullQuran = [];

  List<Verse> get verses => _verses;
  List<Surah> get fullQuran => _fullQuran;

  Future<void> fetchVerses(
      int pageNumber, PagingController<int, Verse> _pagingController) async {
    List<Verse> newVerseList = [];
    var url = Uri.parse('$kGetVersesUrl$pageNumber');
    try {
      final response = await http.get(url);
      final jsonExtractedList = json.decode(response.body);
      //final previousJsonList = jsonExtractedList['previous'];
      final verseListData =
          jsonExtractedList['verses']['data'] as List<dynamic>;
      final lastPage = jsonExtractedList['verses']['last_page'];
      for (var verseData in verseListData) {
        final verse = Verse.fromJson(verseData);
        newVerseList.add(verse);
      }
      if (lastPage == pageNumber) {
        // 3
        _pagingController.appendLastPage(newVerseList);
      } else {
        final nextPageKey = pageNumber + 1;
        _pagingController.appendPage(newVerseList, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> fetchPreviousVerses(
      int pageNumber, PagingController<int, Verse> _pagingController) async {
    List<Verse> newVerseList = [];
    var url = Uri.parse('$kGetPreviousVersesUrl$pageNumber');
    try {
      final response = await http.get(url);
      final jsonExtractedList = json.decode(response.body);
      //final previousJsonList = jsonExtractedList['previous'];
      final verseListData = jsonExtractedList['data'] as List<dynamic>;
      final lastPage = jsonExtractedList['last_page'];
      for (var verseData in verseListData) {
        final verse = Verse.fromJson(verseData);
        newVerseList.add(verse);
      }
      if (lastPage == pageNumber) {
        // 3
        _pagingController.appendLastPage(newVerseList);
      } else {
        final nextPageKey = pageNumber + 1;
        _pagingController.appendPage(newVerseList, nextPageKey);
      }
    } catch (error) {
      print('fetchPosts: $error');
    }
  }

  Future<void> fetchPreviousHadith(
      int pageNumber, PagingController<int, Hadith> _pagingController) async {
    List<Hadith> newVerseList = [];
    var url = Uri.parse('$kGetPreviousHadithUrl$pageNumber');
    try {
      final response = await http.get(url);
      final jsonExtractedList = json.decode(response.body);
      //final previousJsonList = jsonExtractedList['previous'];
      final hadithListData = jsonExtractedList['data'] as List<dynamic>;
      final lastPage = jsonExtractedList['last_page'];
      for (var verseData in hadithListData) {
        final hadith = Hadith.fromJson(verseData);
        newVerseList.add(hadith);
      }
      if (lastPage == pageNumber) {
        // 3
        _pagingController.appendLastPage(newVerseList);
      } else {
        final nextPageKey = pageNumber + 1;
        _pagingController.appendPage(newVerseList, nextPageKey);
      }
    } catch (error) {
      print('fetchPosts: $error');
    }
  }

  Future<void> fetchHadith(
      int pageNumber, PagingController<int, Hadith> _pagingController) async {
    List<Hadith> newHadithList = [];
    var url = Uri.parse('$kGetHadithUrl$pageNumber');
    try {
      final response = await http.get(url);
      final jsonExtractedList = json.decode(response.body);
      //final previousJsonList = jsonExtractedList['previous'];
      final hadithListData =
          jsonExtractedList['hadith']['data'] as List<dynamic>;
      final lastPage = jsonExtractedList['hadith']['last_page'];
      for (var hadithData in hadithListData) {
        final hadith = Hadith.fromJson(hadithData);
        newHadithList.add(hadith);
      }
      if (lastPage == pageNumber) {
        // 3
        _pagingController.appendLastPage(newHadithList);
      } else {
        final nextPageKey = pageNumber + 1;
        _pagingController.appendPage(newHadithList, nextPageKey);
      }
    } catch (error) {
      print('fetchPosts: $error');
    }
  }
}
