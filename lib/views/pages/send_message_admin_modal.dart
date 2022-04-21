import 'dart:convert';

import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class SendMessageAdminModal extends StatelessWidget {
  final User currentUser;
  SendMessageAdminModal({Key? key, required this.currentUser})
      : super(key: key);
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Column(
        children: [
          TextField(
            controller: myController,
            autocorrect: false,
            maxLines: 8,
            onSubmitted: (value) {
              sendMessageToUser(value).then((value) {
                if (value) {
                  showSnackBar('تم الإرسال بنجاح', context);
                  Navigator.pop(context);
                } else {
                  showSnackBar(
                      'حدث خطأ ما ، تأكد من اتصالك بالانترنت والمحاولة مرة اخرى',
                      context);
                  Navigator.pop(context);
                }
              });
            },
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'ارسال رسالة إلى الإدارة',
              hintMaxLines: 2,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          RoundedButtonWidget(
              label: const Text('ارسال'),
              width: 40.w,
              onpressed: () {
                String value = myController.text;

                sendMessageToUser(value).then((value) {
                  if (value) {
                    showSnackBar('تم الإرسال بنجاح', context);
                    Navigator.pop(context);
                  } else {
                    showSnackBar(
                        'حدث خطأ ما ، تأكد من اتصالك بالانترنت والمحاولة مرة اخرى',
                        context);
                    Navigator.pop(context);
                  }
                });
              })
        ],
      ),
    );
  }

  Future<bool> sendMessageToUser(String message) async {
    if (message.isEmpty) return false;

    try {
      var url = Uri.parse(kSendMessageToAdminsUrl);

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${currentUser.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': currentUser.id,
          'message': message,
        }),
      );
      final jsonExtractedList = json.decode(response.body);
      if (jsonExtractedList.containsKey('user_id')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }

    return true;
  }
}
