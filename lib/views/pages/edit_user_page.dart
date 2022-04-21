import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/app/helper_files/user_props_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/edit_user_controller.dart';
import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/views/components/marriage/marriage_app_bar.dart';
import 'package:albaqer/views/components/register/date_text_field.dart';
import 'package:albaqer/views/components/register/phone_text_field.dart';
import 'package:albaqer/views/components/register/rounded_text_field.dart';

import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'edit_user/change_image.dart';
import 'edit_user/edit_user_dialog.dart';

class EditUserPage extends StatefulWidget {
  static String routeName = '/edit_user_page';
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  bool isLoading = false;
  User? user;
  String selectedItem = 'رقم الهاتف';
  String propsName = 'phoneNumber';
  final Map phoneMap = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    user = context.read<EditUserController>().getLogedinUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarriageAppBar(
        appBar: AppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: Stack(
          children: [
            user != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ChangeImage(
                          user: user,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Divider(
                          thickness: 2,
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          '- لتعديل بياناتك الشخصية قم باختيار الحقل المراد تعديله من الإسفل ',
                          style: TextStyle(
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        EditUserDropDown(
                          onItemSelected: onItemSelected,
                          selectedItem: selectedItem,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Form(
                          key: _formKey,
                          child: buildTextFieled(),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        RoundedButtonWidget(
                          label: const Text('تعديل'),
                          width: 40.w,
                          onpressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                          },
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          '- لحفظ التعديلات على الهاتف الرجاء الضغط على زر التحديث',
                          style: TextStyle(
                            color: context.watch<ColorMode>().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        RoundedButtonWidget(
                          label: const Text('تحديث'),
                          width: 40.w,
                          onpressed: () {
                            refreshUser();
                          },
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void refreshUser() async {
    bool isDone = await context.read<UserController>().refreshUserInfo(user);
    if (isDone) {
      showSnackBar('تم التحديث بنجاح', context);
    } else {
      showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا', context);
    }
    user = context.read<EditUserController>().getLogedinUser();
    setState(() {});
  }

  void onItemSelected(String? value) {
    var propsList =
        userProps.entries.where((element) => element.value == value);
    if (propsList.isNotEmpty) {
      propsName = propsList.first.key;

      selectedItem = propsList.first.value;
    }
    setState(() {});
  }

  void onFormSaved(value) async {
    if (propsName == 'phoneNumber') {
      editPhoneNumber();
    } else {
      bool isDone = await context
          .read<EditUserController>()
          .editUserInfo(props: propsName, value: value);
      if (isDone) {
        showSnackBar('تم التعديل بنجاح', context);
      } else {
        showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا', context);
      }
    }
  }

  void editPhoneNumber() async {
    if (phoneMap.isEmpty) {
      showSnackBar('تأكد من ادخال رقم هاتف صحيح', context);
    } else {
      PhoneNumberUtil plugin = PhoneNumberUtil();
      RegionInfo region = RegionInfo(
          name: phoneMap['country']!.name,
          prefix: int.parse(phoneMap['country'].callingCode),
          code: phoneMap['country'].countryCode);
      bool isValid = await plugin.validate(phoneMap['value'], region.code);
      if (isValid) {
        String phoneNumber =
            phoneMap['country'].callingCode + phoneMap['value'];
        bool isDone = await context
            .read<EditUserController>()
            .editUserInfo(props: 'phone_number', value: phoneNumber);
        if (isDone) {
          showSnackBar('تم التعديل بنجاح', context);
        } else {
          showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا', context);
        }
      } else {
        showSnackBar('تأكد من ادخال رقم هاتف صحيح', context);
      }
    }
  }

  Widget buildTextFieled() {
    switch (propsName) {
      case 'phoneNumber':
        return PhoneTextField(
          key: ObjectKey(propsName),
          hintText: selectedItem,
          icon: Icons.phone_enabled_outlined,
          isRequired: true,
          initValue: user!.phoneNumber.substring(4),
          onSave: (value) {
            phoneMap.addAll(value);
            onFormSaved(value);
          },
        );

      case 'civilIdNo':
      case 'height':
      case 'weight':
      case 'income':
      case 'childrenNumber':
        return RoundedTextField(
          key: ObjectKey(propsName),
          hintText: selectedItem,
          icon: Icons.edit_outlined,
          inputType: TextInputType.number,
          initValue: user!.getProp(propsName).toString(),
          isRequired: true,
          isLastInfoucs: true,
          onSave: (value) {
            onFormSaved(value);
          },
        );

      case 'birthDate':
        return DateTextField(
          key: ObjectKey(propsName),
          hintText: selectedItem,
          icon: Icons.calendar_today_outlined,
          isRequired: true,
          initValue: DateFormat.yMd().format(user!.birthDate),
          onSave: (value) {
            onFormSaved(value);
          },
        );
      default:
        return RoundedTextField(
          key: ObjectKey(propsName),
          hintText: selectedItem,
          icon: Icons.edit_outlined,
          isRequired: true,
          isLastInfoucs: true,
          initValue: user!.getProp(propsName).toString(),
          onSave: (value) {
            onFormSaved(value);
          },
        );
    }
  }
}
