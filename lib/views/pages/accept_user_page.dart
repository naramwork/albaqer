import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AcceptUserPage extends StatelessWidget {
  static String routeName = '/acceptUserPage';
  const AcceptUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Center(
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: context.watch<ColorMode>().isDarkMode
                      ? ColorConst.darkCardColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'يتم الآن مراجعة طلب التسجيل الخاص بكم , وسوف يصل أشعار قريب ليعلمكم بحالة الطلب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedButtonWidget(
                    label: const Text('العودة إلى التطبيق'),
                    width: 30.w,
                    onpressed: () {
                      Navigator.pushReplacementNamed(
                          context, MainLayout.routeName);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
