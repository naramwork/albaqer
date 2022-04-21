import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/register/next_button.dart';

import 'package:albaqer/views/components/register/previouse_button.dart';

import 'package:albaqer/views/components/register/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPageFive extends StatelessWidget {
  final Function previousPage;
  final Function nextPage;

  RegisterPageFive(
      {Key? key, required this.previousPage, required this.nextPage})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  final Map<String, String> pageTowUserInfo = {};

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
                RoundedTextField(
                  hintText: 'الصلاة',
                  icon: Icons.create_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['prayer'],
                  onSave: (value) {
                    pageTowUserInfo['prayer'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'التدين',
                  icon: Icons.create_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['religiosity'],
                  onSave: (value) {
                    pageTowUserInfo['religiosity'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'اللحية',
                  icon: Icons.create_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['beard'],
                  onSave: (value) {
                    pageTowUserInfo['beard'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'التدخين',
                  imageIcon: 'assets/images/smoking.png',
                  isRequired: true,
                  initValue: pageTowUserInfo['smoking'],
                  onSave: (value) {
                    pageTowUserInfo['smoking'] = value;
                  },
                  isLastInfoucs: true,
                  suffixIcon: Icons.fiber_manual_record,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PreviousButton(width: 10.w, onpressed: previousPage),
                    NextButton(
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<UserController>().addToUserInfo(pageTowUserInfo);

      nextPage();

      // index of the page
    } else {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }
}
