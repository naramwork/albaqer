import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/register/next_button.dart';
import 'package:albaqer/views/components/register/previouse_button.dart';
import 'package:albaqer/views/components/register/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPageTow extends StatelessWidget {
  final Function nextPage;
  final Function previousPage;
  RegisterPageTow(
      {Key? key, required this.nextPage, required this.previousPage})
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
                  hintText: 'الجنسية',
                  icon: Icons.map_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['nationality'],
                  onSave: (value) {
                    pageTowUserInfo['nationality'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'بلد الإقامة',
                  imageIcon: 'assets/images/signpost.png',
                  isRequired: true,
                  initValue: pageTowUserInfo['country'],
                  onSave: (value) {
                    pageTowUserInfo['country'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'المدينة',
                  icon: Icons.home_work_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['city'],
                  onSave: (value) {
                    pageTowUserInfo['city'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'الرقم المدني',
                  icon: Icons.badge_outlined,
                  isRequired: true,
                  inputType: TextInputType.number,
                  initValue: pageTowUserInfo['civilIdNo'],
                  onSave: (value) {
                    pageTowUserInfo['civilIdNo'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
                ),
                RoundedTextField(
                  hintText: 'الديانة',
                  icon: Icons.edit_outlined,
                  isRequired: true,
                  initValue: pageTowUserInfo['religion'],
                  onSave: (value) {
                    pageTowUserInfo['religion'] = value;
                  },
                  suffixIcon: Icons.fiber_manual_record,
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
    //print('phone: $phone');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      nextPage(); // index of the page
      context.read<UserController>().addToUserInfo(pageTowUserInfo);
    } else {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }
}
