import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/register/next_button.dart';
import 'package:albaqer/views/components/register/phone_text_field.dart';

import 'package:albaqer/views/components/register/previouse_button.dart';

import 'package:albaqer/views/components/register/rounded_text_field.dart';
import 'package:albaqer/views/pages/register/register_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPageSeven extends StatelessWidget {
  final Function previousPage;

  RegisterPageSeven({Key? key, required this.previousPage}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  final Map<String, String> pageTowUserInfo = {};
  final Map phoneMap = {};

  void setUserInfoMap(BuildContext context) {
    var userInfo = context.watch<UserController>().usetInfo;
    if (userInfo.isNotEmpty) {
      pageTowUserInfo.addAll(userInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    setUserInfoMap(context);

    return WillPopScope(
      onWillPop: () {
        previousPage();
        return Future.value(false);
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    child: const Text(
                      'يرجى الكتابة بطريقة جادة ,ويمنع كتابة الإيميل أو رقم الجوال في هذا المكان',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                RoundedTextField(
                  hintText: 'المواصفات المطلوبة',
                  icon: Icons.create_outlined,
                  isRequired: true,
                  maxLine: null,
                  initValue: pageTowUserInfo['specifications'],
                  onSave: (value) {
                    pageTowUserInfo['specifications'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'اخبرنا عن نفسك',
                  icon: Icons.create_outlined,
                  isRequired: true,
                  maxLine: null,
                  initValue: pageTowUserInfo['aboutYou'],
                  onSave: (value) {
                    pageTowUserInfo['aboutYou'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                SizedBox(
                  height: 2.h,
                ),
                const Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    child: const Text(
                      'الاسم الكامل ورقم الجوال : معلومات خاصة بالإدارة ولن تظهر لأحد أبدا .\n \nكتابتك لهذه المعلومات بالشكل الصحيح هو تأكيد منك على جديتك في الزواج .',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                PhoneTextField(
                  hintText: 'رقم الجوال',
                  icon: Icons.phone_enabled_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['phoneNumber'] != null
                      ? pageTowUserInfo['phoneNumber']!.substring(4)
                      : '',
                  onSave: (value) {
                    phoneMap.addAll(value);
                  },
                ),
                RoundedTextField(
                  hintText: 'الأسم الكامل',
                  icon: Icons.person_outline,
                  isRequired: true,
                  initValue: pageTowUserInfo['fullName'],
                  onSave: (value) {
                    pageTowUserInfo['fullName'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                  isLastInfoucs: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PreviousButton(width: 10.w, onpressed: previousPage),
                    NextButton(
                        title: 'تسجيل',
                        width: 10.w,
                        onpressed: () async {
                          saveForm(context);
                        }),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveForm(BuildContext context) async {
    //print('phone: $phone');

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (phoneMap.isEmpty) {
        showSnackBar('تأكد من ادخال رقم هاتف صحيح', context);
      } else {
        bool phoneSaved = await context
            .read<UserController>()
            .addAndValidatePhoneNumber(phoneMap['value'], phoneMap['country']);
        if (!phoneSaved || phoneMap.isEmpty) {
          showSnackBar('تأكد من ادخال رقم هاتف صحيح', context);
        } else {
          showDialog(
              context: context,
              builder: (ctx) {
                return const RegisterDialog();
              }); // index of the page
          context.read<UserController>().addToUserInfo(pageTowUserInfo);
        }
      }
    } else {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  void showSnackBar(String text, BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Tajawl',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
