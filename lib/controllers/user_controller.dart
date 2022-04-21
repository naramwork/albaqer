import 'dart:convert';

import 'package:country_calling_code_picker/picker.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:phone_number/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  final Map<String, String> _userInfo = {};
  User? _user;

  Map<String, String> get usetInfo => _userInfo;

  User? get user => _user;

  void setUserGender(String gender) {
    _userInfo.update(
      'gender',
      (value) => gender,
      ifAbsent: () => gender,
    );
  }

  void addToUserInfo(Map<String, String> pageMap) {
    for (var element in pageMap.entries) {
      _userInfo.update(
        element.key,
        (value) => element.value,
        ifAbsent: () => element.value,
      );
    }

    notifyListeners();
  }

  Future<bool> registerUser() async {
    var url = Uri.parse(kGetRegisterUrl);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString(kStorTokenKey) ?? '';
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'type': 'user',
        'name': _userInfo['name'] ?? '',
        'email': _userInfo['email'] ?? '',
        'phone_number': _userInfo['phoneNumber'] ?? '',
        'password': _userInfo['password'] ?? '',
        'password_confirmation': _userInfo['confirmPassword'] ?? '',
        'job': _userInfo['job'] ?? '',
        'gender': _userInfo['gender'] ?? '',
        'children_number': _userInfo['childrenNumber']!.isNotEmpty
            ? _userInfo['childrenNumber']
            : 0,
        'social_status': _userInfo['socialStatus']!.isNotEmpty
            ? _userInfo['socialStatus']
            : 'غير محدد',
        'city': _userInfo['city'] ?? '',
        'nationality': _userInfo['nationality'] ?? '',
        'civil_id_no': _userInfo['civilIdNo'] ?? '',
        'fire_base_token': token,
        'birthdate': _userInfo['birthDate'] ?? '',
        'height': _userInfo['height']!.isNotEmpty ? _userInfo['height'] : 0,
        'weight': _userInfo['weight']!.isNotEmpty ? _userInfo['weight'] : 0,
        'fullName': _userInfo['fullName'],
        'country': _userInfo['country'],
        'smoking': _userInfo['smoking'],
        'beard': _userInfo['beard'],
        'religion': _userInfo['religion'],
        'financialStatus': _userInfo['financialStatus'],
        'skinColour': _userInfo['skinColour'],
        'physique': _userInfo['physique'],
        'religiosity': _userInfo['religiosity'],
        'employment': _userInfo['employment'],
        'healthStatus': _userInfo['healthStatus'],
        'specifications': _userInfo['specifications'],
        'income': _userInfo['income'],
        'aboutYou': _userInfo['aboutYou'],
        'educational': _userInfo['educational'],
        'image_url': _userInfo['gender'] == 'm' ? kmanImageUrl : kwomanImageUrl,
        'prayer': _userInfo['prayer'],
      }),
    );
    if (response.statusCode == 201) {
      return loginUser(_userInfo['email'] ?? '', _userInfo['password'] ?? '');
    } else {
      return false;
    }
  }

  Future<bool> logoutUser(String email, String token) async {
    var url = Uri.parse(kGetLogoutUrl);
    final logoutResponse = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
      }),
    );
    if (logoutResponse.body == 'done') {
      Box userBox = Hive.box<User>(kUserBoxName);
      userBox.clear();
      _user = null;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future getLogedinUser() async {
    Box userBox = Hive.box<User>(kUserBoxName);
    if (userBox.values.isNotEmpty) {
      _user = userBox.values.first;
      refreshUserInfo(_user);
    }

    return _user;
  }

  Future<bool> refreshUserFcm() async {
    if (_user == null) return false;
    int id = _user?.id ?? 0;
    String token = _user?.token ?? '';
    var url = Uri.parse('$krefreshFcmUrl/$id');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    final jsonExtractedList = json.decode(response.body);
    if (jsonExtractedList['error'] != null) {
      return false;
    }
    List<String> fcmResponse = [];
    if (jsonExtractedList['fire_base_token'].runtimeType == String) {
      fcmResponse.add(jsonExtractedList['fire_base_token']);
    } else {
      List<dynamic> dyn = jsonExtractedList['fire_base_token'];
      fcmResponse = dyn.map((e) => e.toString()).toList();
    }
    _user?.fcm = fcmResponse;
    await _user?.save();
    return true;
  }

  Future<bool> loginUser(String email, String pssword) async {
    var url = Uri.parse(kGetLoginUrl);
    final loginResponse = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': pssword,
        'device_name': 'mobile'
      }),
    );

    final jsonExtractedList = json.decode(loginResponse.body);
    if (jsonExtractedList['errors'] == null) {
      String token = jsonExtractedList['toke'];
      var userJson = jsonExtractedList['user'];
      String email = userJson['email'];
      String name = userJson['name'];
      bool isBlock = jsonExtractedList['isBlocked'] == "1";

      int id = userJson['id'];
      var profile = userJson['profile'];
      User user = User.fromJson(id, email, name, profile, token, isBlock);
      Box userBox = Hive.box<User>(kUserBoxName);
      userBox.add(user);
      _user = user;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void deleteInfo() {
    _userInfo.clear();
    notifyListeners();
  }

  Future<bool> addAndValidatePhoneNumber(String phone, Country? country) async {
    PhoneNumberUtil plugin = PhoneNumberUtil();
    RegionInfo region = RegionInfo(
        name: country!.name,
        prefix: int.parse(country.callingCode),
        code: country.countryCode);
    bool isValid = await plugin.validate(phone, region.code);
    if (isValid) {
      String phoneNumber = country.callingCode + phone;
      _userInfo.update(
        'phoneNumber',
        (value) => phoneNumber,
        ifAbsent: () => phoneNumber,
      );
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  //Check if the provided email in sign up stage is already saved into the database
  Future<String> checkUser(String name, String value) async {
    var url = Uri.parse(kCheckUserFcmUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'name': name, 'value': value}),
    );
    final jsonExtractedList = json.decode(response.body);

    if (jsonExtractedList == 1) {
      return '1';
    }
    if (jsonExtractedList['errors'] != null) {
      if (jsonExtractedList['errors']['no_user'] != null) {
        return jsonExtractedList['errors']['no_user'][0] as String;
      } else {
        return jsonExtractedList['errors']['value'][0] as String;
      }
    } else {
      return '2';
    }
  }

  //refresh user data after update
  Future refreshUserInfo(User? currentUser) async {
    if (currentUser == null) return false;
    try {
      var url = Uri.parse('$kRefreshUserUrl${currentUser.id}');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${currentUser.token}',
        },
      );

      String token = currentUser.token;
      final jsonExtractedList = json.decode(response.body);

      if (jsonExtractedList['errors'] == null) {
        String email = jsonExtractedList['email'];
        String name = jsonExtractedList['name'];
        bool isBlock = jsonExtractedList['isBlocked'] == "1";
        int id = jsonExtractedList['id'];
        var profile = jsonExtractedList['profile'];
        User user = User.fromJson(id, email, name, profile, token, isBlock);
        Box userBox = Hive.box<User>(kUserBoxName);
        userBox.delete(_user!.key);
        userBox.add(user);
        _user = user;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
