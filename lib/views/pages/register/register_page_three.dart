import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/register/date_text_field.dart';
import 'package:albaqer/views/components/register/next_button.dart';

import 'package:albaqer/views/components/register/previouse_button.dart';

import 'package:albaqer/views/components/register/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPageThree extends StatelessWidget {
  final Function nextPage;
  final Function previousPage;
  RegisterPageThree(
      {Key? key, required this.nextPage, required this.previousPage})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  final Map<String, String> pageThreeUserInfo = {};

  void setUserInfoMap(BuildContext context) {
    var userInfo = context.watch<UserController>().usetInfo;
    if (userInfo.isNotEmpty) {
      pageThreeUserInfo.addAll(userInfo);
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                RoundedTextField(
                  hintText: 'الحالة الإجتماعية',
                  icon: Icons.person_outline,
                  isRequired: true,
                  initValue: pageThreeUserInfo['socialStatus'],
                  onSave: (value) {
                    pageThreeUserInfo['socialStatus'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'الحالة الصحية',
                  icon: Icons.local_hospital_outlined,
                  isRequired: true,
                  initValue: pageThreeUserInfo['healthStatus'],
                  onSave: (value) {
                    pageThreeUserInfo['healthStatus'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                DateTextField(
                  hintText: 'تاريخ الميلاد',
                  icon: Icons.calendar_today_outlined,
                  isRequired: true,
                  initValue: pageThreeUserInfo['birthDate'],
                  onSave: (value) {
                    pageThreeUserInfo['birthDate'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'عدد الأطفال',
                  inputType: TextInputType.number,
                  imageIcon: 'assets/images/children.png',
                  isRequired: true,
                  initValue: pageThreeUserInfo['childrenNumber'],
                  suffixIcon: Icons.fiber_manual_record,
                  onSave: (value) {
                    pageThreeUserInfo['childrenNumber'] = value;
                  },
                  isLastInfoucs: true,
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

      nextPage(); // index of the page
      context.read<UserController>().addToUserInfo(pageThreeUserInfo);
    } else {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }
}
