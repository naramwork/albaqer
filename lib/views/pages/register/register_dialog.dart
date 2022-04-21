import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({Key? key}) : super(key: key);

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  bool isLodaing = false;

  final String content =
      'اقسم بالله العظيم بأن غايتي من التسجيل في هذا التطبيق هو الزواج الشرعي الإسلامي وليس لأي هدف اخر وأقسم أن المعلومات المقدمة من قبلي صحيحة تماما وعلى مسؤوليتي وأن ألتزم الآداب العامة في المراسلات والله على ما أقول شهيد.';

  final String containerText =
      'أعلم أن المعلومات المقدمة على مسؤوليتي و مسؤولية بقية المستخدمين';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.w),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.watch<ColorMode>().isDarkMode
                  ? ColorConst.darkCardColor
                  : Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  content,
                  style: TextStyle(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xff7EADCC),
                        Color(0xff538CB2),
                        Color(0xff538CB2),
                      ],
                    ),
                  ),
                  child: Text(
                    containerText,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                RoundedButtonWidget(
                    label: const Text('متابعة'),
                    width: 40.w,
                    onpressed: () async {
                      bool isRegisterd =
                          await context.read<UserController>().registerUser();
                      if (isRegisterd) {
                        showSnackBar('Done', context);

                        Navigator.of(context)
                            .pushReplacementNamed(MainLayout.routeName);
                      } else {
                        showSnackBar('Erorr', context);

                        Navigator.pop(context);
                      }

                      Navigator.of(context)
                          .pushReplacementNamed(MainLayout.routeName);
                    }),
                SizedBox(
                  height: 1.h,
                ),
                BlackRoundedButton(
                    label: const Text('تراجع'),
                    width: 40.w,
                    onpressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
          isLodaing ? const CircularProgressIndicator() : Container(),
        ],
      ),
    );
  }
}

class BlackRoundedButton extends StatelessWidget {
  final Widget label;
  final double width;
  final Function onpressed;
  const BlackRoundedButton({
    Key? key,
    required this.label,
    required this.width,
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.blue.shade100,
                offset: const Offset(0, 4),
                blurRadius: 5.0)
          ],
          color: Colors.black87,
          borderRadius: BorderRadius.circular(50),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(width, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            onpressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: label,
          ),
        ),
      ),
    );
  }
}
