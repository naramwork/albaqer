import 'package:auto_size_text/auto_size_text.dart';
import 'package:albaqer/app/helper_files/user_props_const.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditUserDropDown extends StatelessWidget {
  final Function onItemSelected;
  final String? selectedItem;
  const EditUserDropDown(
      {Key? key, required this.onItemSelected, required this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: selectedItem,
        dropdownMaxHeight: 40.h,
        iconEnabledColor:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        hint: Text(
          'اختيار الحقل',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: context.watch<ColorMode>().isDarkMode
                ? Colors.white
                : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: list
            .map((e) => DropdownMenuItem<String>(
                value: e,
                child: AutoSizeText(
                  e,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                )))
            .toList(),
        onChanged: (value) {
          onItemSelected(value);
        },
        buttonHeight: 8.h,
        buttonWidth: 80.w,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.watch<ColorMode>().isDarkMode
              ? ColorConst.darkCardColor
              : Colors.white,
        ),
        buttonElevation: 2,
        itemWidth: 70.w,
        itemHeight: 8.h,
        dropdownPadding: EdgeInsets.only(top: 2.h),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.watch<ColorMode>().isDarkMode
              ? ColorConst.darkCardColor
              : Colors.white,
        ),
        dropdownElevation: 8,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-20, 0),
      ),
    );
  }
}
