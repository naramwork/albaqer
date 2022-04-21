import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DateTextField extends StatelessWidget {
  final String hintText;
  final String? initValue;

  final Function onSave;

  final IconData? suffixIcon;
  final IconData? icon;
  final String? imageIcon;
  final bool isRequired;
  const DateTextField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.onSave,
    this.imageIcon,
    this.suffixIcon,
    this.initValue,
    this.isRequired = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 2.w,
            ),
            icon != null
                ? Icon(
                    icon,
                    size: 35,
                    color: context.watch<ColorMode>().textInputIconColor,
                  )
                : ImageIcon(
                    AssetImage(imageIcon!),
                    size: 35,
                    color: context.watch<ColorMode>().textInputIconColor,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: VerticalDivider(
                thickness: 2,
                color: context.watch<ColorMode>().isDarkMode
                    ? const Color.fromRGBO(200, 230, 241, 0.6)
                    : Colors.grey.shade300,
              ),
            ),
            Expanded(
              child: CustomTextField(
                onSave: onSave,
                isRequired: isRequired,
                suffixIcon: suffixIcon,
                hintText: hintText,
                initValue: initValue,
              ),
            ),
            SvgPicture.asset(
              'assets/images/lift.svg',
              fit: BoxFit.fill,
              width: 14.w,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final Function onSave;
  final bool isRequired;
  final IconData? suffixIcon;
  final String hintText;
  final String? initValue;

  const CustomTextField({
    Key? key,
    required this.onSave,
    this.isRequired = false,
    this.suffixIcon,
    required this.hintText,
    required this.initValue,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = widget.initValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateinput,
      onSaved: (save) {
        widget.onSave(save);
      },
      style: TextStyle(
          color: context.watch<ColorMode>().isDarkMode
              ? Colors.white
              : Colors.black),
      validator: (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'هذا الحقل مطلوب';
        }

        return null;
      },
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                1900), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            dateinput.text =
                formattedDate; //set output date to TextField value.
          });
        }
      },
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        suffixIcon: Icon(
          widget.suffixIcon,
          color: context.watch<ColorMode>().textInputIconColor,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 3.h),
        hintText: widget.hintText,
        hintMaxLines: 2,
        hintStyle: TextStyle(
            color: context.watch<ColorMode>().textInputHintColor, fontSize: 14),
        border: InputBorder.none,
      ),
    );
  }
}
