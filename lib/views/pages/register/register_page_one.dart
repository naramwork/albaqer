import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/register/next_button.dart';

import 'package:albaqer/views/components/register/gender_card.dart';
import 'package:albaqer/views/components/register/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPageOne extends StatelessWidget {
  final Function nextPage;

  RegisterPageOne({
    Key? key,
    required this.nextPage,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void changeGender(String gender) {
    pageOneUserInfo['gender'] = gender;
  }

  final Map<String, String> pageOneUserInfo = {
    'gender': 'm',
  };

  void setUserInfoMap(BuildContext context) {
    var userInfo = context.watch<UserController>().usetInfo;
    if (userInfo.isNotEmpty) {
      pageOneUserInfo.addAll(userInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    setUserInfoMap(context);

    return WillPopScope(
      onWillPop: () {
        context.read<UserController>().deleteInfo();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                RoundedTextField(
                  hintText: 'اسم المستخدم',
                  icon: Icons.person_outline,
                  isRequired: true,
                  initValue: pageOneUserInfo['name'],
                  onSave: (value) {
                    pageOneUserInfo['name'] = value;
                  },
                ),
                RoundedTextField(
                  hintText: 'البريد الإلكتروني',
                  icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress,
                  isRequired: true,
                  initValue: pageOneUserInfo['email'],
                  onSave: (value) {
                    pageOneUserInfo['email'] = value;
                  },
                ),
                RoundedTextField(
                  hintText: 'كلمة المرور',
                  icon: Icons.lock_outlined,
                  isRequired: true,
                  initValue: pageOneUserInfo['password'],
                  onSave: (value) {
                    pageOneUserInfo['password'] = value;
                  },
                  isPassword: true,
                  suffixIcon: Icons.visibility_off_outlined,
                ),
                RoundedTextField(
                  hintText: 'تأكيد كلمة المرور',
                  icon: Icons.lock_outlined,
                  isRequired: true,
                  initValue: pageOneUserInfo['confirmPassword'],
                  onSave: (value) {
                    pageOneUserInfo['confirmPassword'] = value;
                  },
                  isLastInfoucs: true,
                  isPassword: true,
                  suffixIcon: Icons.visibility_off_outlined,
                ),
                GenderCard(
                    changeGender: changeGender,
                    gender: pageOneUserInfo['gender'] ?? 'm'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: NextButton(
                      width: 10.w,
                      onpressed: () async {
                        saveForm(context);
                      }),
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // check if email is alredy exits
      String response = await context
          .read<UserController>()
          .checkUser('email', pageOneUserInfo['email'] ?? '');

      //respose = 1 means there is no email register in data base
      if (response == "1") {
        if (pageOneUserInfo['password'] != pageOneUserInfo['confirmPassword']) {
          showSnackBar('كلمات السر غير متطابقة', context);
        } else {
          nextPage();
          context.read<UserController>().addToUserInfo(pageOneUserInfo);
        }
      } else {
        showSnackBar(response, context);
        scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
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
