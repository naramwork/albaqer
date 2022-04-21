import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/register/rounded_text_field.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/components/static_page_name_container.dart';
import 'package:albaqer/views/main_layout.dart';
import 'package:albaqer/views/pages/register/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'login_page';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void selectPage(int index, BuildContext context) {
    Navigator.of(context).pushNamed(MainLayout.routeName, arguments: index);
  }

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              StaticPageNameContainer(
                pageTitle: 'تسجيل دخول',
                maxHeight: 25.0.h,
                bottomBorderRad: const Radius.elliptical(100, 40),
                backgroundImageUrl: 'assets/images/mosque.png',
                boxFit: BoxFit.cover,
                imageAlignment: Alignment.center,
              ),
              SizedBox(
                height: 3.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 10.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedTextField(
                            hintText: 'البريد الإلكتروني',
                            icon: Icons.email_outlined,
                            inputType: TextInputType.emailAddress,
                            isRequired: true,
                            onSave: (value) {
                              email = value;
                            },
                          ),
                          RoundedTextField(
                            hintText: 'كلمة المرور',
                            icon: Icons.lock_outlined,
                            isRequired: true,
                            onSave: (value) {
                              password = value;
                            },
                            isLastInfoucs: true,
                            isPassword: true,
                            suffixIcon: Icons.visibility_off_outlined,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RoundedButtonWidget(
                              label: const Text('تسجيل دخول'),
                              width: 50.w,
                              onpressed: logUserIn),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            'غير مشترك؟ قم بتسجيل حساب',
                            style: TextStyle(
                              color: context.watch<ColorMode>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          RoundedButtonWidget(
                            label: const Text('تسجيل حساب'),
                            width: 50.w,
                            onpressed: () async {
                              Navigator.pushNamed(
                                  context, SignUpPage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
      floatingActionButton: FAP(
        onPressed: () {
          gotToMarriagePage(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: 0,
        selectPage: selectPage,
      ),
    );
  }

  void logUserIn() async {
    {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        bool isLogin =
            await context.read<UserController>().loginUser(email, password);
        if (isLogin) {
          Navigator.pop(context);
        } else {
          setState(() {
            isLoading = false;
          });
          showSnackBar('تأكد من معلومات الدخول', context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
