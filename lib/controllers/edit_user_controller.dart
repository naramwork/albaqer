import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/models/user.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class EditUserController extends ChangeNotifier {
  User? _currentUser;
  Widget? _widget;

  User? get currentUser => _currentUser;
  Widget? get widget => _widget;

  User? getLogedinUser() {
    Box userBox = Hive.box<User>(kUserBoxName);
    if (userBox.values.isNotEmpty) {
      _currentUser = userBox.values.first;
      return _currentUser;
    }
  }

  Future<bool> addImage(String filepath) async {
    _currentUser ??= getLogedinUser();
    if (_currentUser == null) return false;
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${_currentUser!.token}',
    };
    var request = http.MultipartRequest('POST', Uri.parse(kEditImageUrl))
      ..fields.addAll({'id': _currentUser!.id.toString()})
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future editUserInfo({required String props, required String value}) async {
    _currentUser ??= getLogedinUser();
    if (_currentUser == null) return false;
    switch (props) {
      case 'childrenNumber':
        props = 'children_number';
        break;
      case 'socialStatus':
        props = 'social_status';
        break;
      case 'civilIdNo':
        props = 'civil_id_no';
        break;
    }

    var url = Uri.parse(kEditUserDataUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${_currentUser!.token}',
      },
      body: jsonEncode(<String, dynamic>{
        'id': _currentUser!.id,
        'value': value,
        'prop': props
      }),
    );
    if (response.body == "1") {
      return true;
    } else {
      return false;
    }
  }
}
