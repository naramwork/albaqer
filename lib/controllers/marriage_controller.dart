import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/models/message.dart';
import 'package:albaqer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class MarriageController extends ChangeNotifier {
  final List<User> _user = [];
  User? _currentUser;
  Map<String, List<Message>> allMessages = {};
  Map<String, List<Message>> sendedMarriageReques = {};
  Map<String, List<Message>> recivedMarriageReques = {};

  bool _getResult = false;
  bool _getMessageResult = false;

  bool get getReuslt => _getResult;
  bool get getMessageResult => _getMessageResult;
  List<User> get user => _user;

  Future<bool> submitSearch(String type, String search) async {
    _user.clear();
    notifyListeners();
    try {
      var url = Uri.parse(kSearchUSerUrl);

      _currentUser ??= getLogedinUser();

      final searchResponse = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'type': type,
          'search': search,
          'gender': _currentUser!.gender
        }),
      );
      final jsonExtractedList =
          json.decode(searchResponse.body) as List<dynamic>;
      if (type != 'name') {
        for (var userData in jsonExtractedList) {
          String token = '';
          var userJson = userData['user'];
          String email = userJson['email'];
          String name = userJson['name'];
          int id = userJson['id'];
          User user = User.fromJson(id, email, name, userData, token, false);
          _user.add(user);
        }
      } else {
        for (var userData in jsonExtractedList) {
          String token = '';
          var profile = userData['profile'];
          String email = userData['email'];
          String name = userData['name'];
          int id = userData['id'];
          User user = User.fromJson(id, email, name, profile, token, false);
          _user.add(user);
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future getRandomUsers() async {
    _user.clear();
    _currentUser = getLogedinUser();
    String gender = _currentUser?.gender ?? 'm';
    String token = _currentUser?.token ?? '';
    try {
      var url = Uri.parse('$kGetRandomUsersUrl$gender');
      final userResponse = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      final jsonExtractedList = json.decode(userResponse.body) as List<dynamic>;

      for (var userData in jsonExtractedList) {
        String token = '';
        var userJson = userData['user'];
        String email = userJson['email'];
        String name = userJson['name'];
        int id = userJson['id'];
        User user = User.fromJson(id, email, name, userData, token, false);
        _user.add(user);
      }
      notifyListeners();
      return;
    } catch (e) {
      print(e);
    }
  }
  /* All Marriage Requests Functions */

  Future sendMarriageRequest(int recipientID) async {
    if (recipientID == 0) return;
    _currentUser ??= getLogedinUser();
    try {
      var url = Uri.parse(kSendMarriageRequestUrl);

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'sender_id': _currentUser!.id,
          'recipient_id': recipientID,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future getMarriageRequests() async {
    sendedMarriageReques.clear();
    recivedMarriageReques.clear();
    _currentUser ??= getLogedinUser();
    try {
      var url = Uri.parse('$kGetMarriageRequestUrl${_currentUser!.id}');
      final messageResponse = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
      );
      final jsonExtractedList = json.decode(messageResponse.body);
      if (jsonExtractedList.containsKey('send')) {
        Map<String, dynamic> sendList = jsonExtractedList['send'];
        for (var sendItem in sendList.entries) {
          String key = sendItem.key;

          sendedMarriageReques[key] = getListOfMessage(sendItem);
        }
      }
      if (jsonExtractedList.containsKey('receive')) {
        if (jsonExtractedList['receive'].isNotEmpty) {
          Map<String, dynamic> sendList = jsonExtractedList['receive'];

          if (sendList.isNotEmpty) {
            for (var sendItem in sendList.entries) {
              String key = sendItem.key;

              recivedMarriageReques[key] = getListOfMessage(sendItem);
            }
          }
        }
      }
      _getResult = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future responseToMarriageRequest(int id, String status) async {
    _currentUser ??= getLogedinUser();
    try {
      var url = Uri.parse(kUpdateMarriageRequestUrl);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'id': id,
          'status': status,
        }),
      );

      return response.body;
    } catch (e) {
      print(e);
    }
  }

  /* All Messages Functions */

  User? getLogedinUser() {
    Box userBox = Hive.box<User>(kUserBoxName);
    if (userBox.values.isNotEmpty) {
      return userBox.values.first;
    }
  }

  Future getMessages() async {
    _currentUser ??= getLogedinUser();
    try {
      var url = Uri.parse('$kGetMessagesUrl${_currentUser!.id}');
      final messageResponse = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
      );
      final jsonExtractedList = json.decode(messageResponse.body);
      if (jsonExtractedList.containsKey('send')) {
        Map<String, dynamic> sendList = jsonExtractedList['send'];
        for (var sendItem in sendList.entries) {
          String key = sendItem.key;

          allMessages[key] = getListOfMessage(sendItem);
        }
      }
      if (jsonExtractedList.containsKey('receive')) {
        var sendList = jsonExtractedList['receive'];

        if (sendList.isEmpty) {
        } else {
          for (var sendItem in sendList.entries) {
            String key = sendItem.key;
            if (allMessages.containsKey(key)) {
              List<Message> senderMessage = allMessages[key] ?? [];
              List<Message> receiveMessage = getListOfMessage(sendItem);
              var newList = [...senderMessage, ...receiveMessage];
              newList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
              allMessages[key] = newList;
            } else {
              allMessages[key] = getListOfMessage(sendItem);
            }
          }
        }
      }
      _getMessageResult = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Message>> getMessageByID(
      {required String id, required int currentUserID}) async {
    List<Message> message = [];

    try {
      var url = Uri.parse('$kGetMessagesByIdUrl$currentUserID/$id');
      final messageResponse = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
      );
      final jsonExtractedList = json.decode(messageResponse.body);
      if (jsonExtractedList.containsKey('send')) {
        Map<String, dynamic> sendList = jsonExtractedList['send'];
        for (var sendItem in sendList.entries) {
          message.addAll(getListOfMessage(sendItem));
        }
      }
      if (jsonExtractedList.containsKey('receive')) {
        var sendList = jsonExtractedList['receive'];

        if (sendList.isEmpty) {
        } else {
          for (var sendItem in sendList.entries) {
            message.addAll(getListOfMessage(sendItem));
            message.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
        }
      }
      return message;
    } catch (e) {
      print(e);
    }
    return message;
  }

  User getNewUserObject(dynamic messageSender) {
    String token = '';

    String email = messageSender['email'];
    String name = messageSender['name'];
    int id = messageSender['id'];
    var profile = messageSender['profile'];
    return User.fromJson(id, email, name, profile, token, false);
  }

  List<Message> getListOfMessage(var sendItem) {
    List<dynamic> jsonMessages = sendItem.value as List<dynamic>;
    List<Message> messages = [];
    for (var message in jsonMessages) {
      User sender = getNewUserObject(message['sender']);
      User recipient = getNewUserObject(message['recipient']);
      int id = message['id'];
      String content = message['message'] ?? '';
      DateTime createdAt = DateTime.parse(message['created_at']).toLocal();
      String status = message['status'];
      messages.add(Message(
          id: id,
          sender: sender,
          recipient: recipient,
          content: content,
          createdAt: createdAt,
          status: status));
    }

    return messages;
  }

  Future sendMessage(
      {int? senderID,
      required int recipientId,
      required String content}) async {
    if (senderID == null) {
      _currentUser ??= getLogedinUser();
      senderID = _currentUser!.id;
    }
    try {
      var url = Uri.parse(kSendMessageUrl);

      final sendMessageResponse = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_currentUser!.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'sender_id': senderID,
          'recipient_id': recipientId,
          'message': content
        }),
      );
      final jsonExtractedList = json.decode(sendMessageResponse.body);
      User sender = getNewUserObject(jsonExtractedList['sender']);
      User recipient = getNewUserObject(jsonExtractedList['recipient']);
      int id = jsonExtractedList['id'];
      //String message = jsonExtractedList['message'];
      DateTime createdAt =
          DateTime.parse(jsonExtractedList['created_at']).toLocal();
      String status = 'في الإنتظار';
      return Message(
          id: id,
          sender: sender,
          recipient: recipient,
          content: content,
          createdAt: createdAt,
          status: status);
    } catch (e) {
      print(e);
    }
  }
}
