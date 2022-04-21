import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/pages/quran/quran_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class QuranSearchDialog extends StatelessWidget {
  final myController = TextEditingController();

  QuranSearchDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.watch<ColorMode>().isDarkMode
              ? ColorConst.darkCardColor
              : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'البحث',
                style: TextStyle(
                  color: context.watch<ColorMode>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search,
                    size: 30,
                    color: Color(0xff538CB2),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: TextField(
                      controller: myController,
                      autocorrect: false,
                      showCursor: false,
                      onSubmitted: (value) {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(
                            QuranSearchPage.routeName,
                            arguments: value);
                      },
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'ابحث',
                        hintMaxLines: 2,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            RoundedButtonWidget(
              label: const Text('موافق'),
              width: 40.w,
              onpressed: () {
                String value = myController.text;
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamed(QuranSearchPage.routeName, arguments: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
