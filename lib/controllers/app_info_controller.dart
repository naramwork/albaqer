import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppInfoController extends ChangeNotifier {
  String _appAd = '';

  String get appAd => _appAd;

  Future<String> getAppAd() async {
    var url = Uri.parse(kAppAdUrl);
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    });

    if (response.body.isEmpty) '';
    final jsonExtractedList = json.decode(response.body);
    if (jsonExtractedList.containsKey("content")) {
      _appAd = jsonExtractedList['content'];
      notifyListeners();
      return jsonExtractedList['content'];
    }

    return '';
  }
}
