import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final String? initValue;
  final int? maxLine;

  final Function onSave;
  final TextInputType? inputType;

  final IconData? suffixIcon;
  final IconData? icon;
  final String? imageIcon;

  final bool isPassword;
  final bool isRequired;
  final bool isLastInfoucs;

  const RoundedTextField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.onSave,
    this.imageIcon,
    this.maxLine,
    this.inputType,
    this.suffixIcon,
    this.initValue,
    this.isLastInfoucs = false,
    this.isRequired = false,
    this.isPassword = false,
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
                inputType: inputType,
                isPassword: isPassword,
                maxLine: maxLine,
                suffixIcon: suffixIcon,
                hintText: hintText,
                initValue: initValue,
                isLastInfoucs: isLastInfoucs,
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
  final TextInputType? inputType;
  final bool isPassword;
  final int? maxLine;
  final IconData? suffixIcon;
  final String hintText;
  final String? initValue;
  final bool isLastInfoucs;

  const CustomTextField({
    Key? key,
    required this.onSave,
    this.isRequired = false,
    this.inputType,
    this.isPassword = false,
    this.maxLine,
    this.suffixIcon,
    required this.hintText,
    required this.initValue,
    this.isLastInfoucs = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var isObscureText = false;

  @override
  void initState() {
    super.initState();
    isObscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        } else if (widget.isPassword) {
          if (value != null && value.length < 8) {
            return 'كلمة سر قصيرة';
          }
        } else if (widget.inputType == TextInputType.emailAddress) {
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value ?? '');
          if (emailValid) {
            return null;
          } else {
            return 'بريد إلكتروني غير صالح';
          }
        }
        return null;
      },
      textInputAction:
          widget.isLastInfoucs ? TextInputAction.done : TextInputAction.next,
      onEditingComplete: () {
        if (!widget.isLastInfoucs) {
          return context.nextEditableTextFocus();
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      initialValue: widget.initValue,
      keyboardType: widget.inputType,
      textAlignVertical: TextAlignVertical.center,
      cursorColor:
          context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.grey,
      autocorrect: false,
      obscureText: isObscureText,
      maxLines: widget.maxLine ?? 1,
      decoration: InputDecoration(
        suffixIcon: buildSuffixIcon(),
        contentPadding: EdgeInsets.symmetric(vertical: 3.h),
        hintText: widget.hintText,
        hintMaxLines: 2,
        hintStyle: TextStyle(
            color: context.watch<ColorMode>().textInputHintColor, fontSize: 14),
        border: InputBorder.none,
      ),
    );
  }

  //show and hide password
  Widget? buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      if (widget.isPassword) {
        return IconButton(
          onPressed: () {
            setState(() {
              isObscureText = !isObscureText;
            });
          },
          icon: Icon(
            widget.suffixIcon,
            color: context.watch<ColorMode>().textInputHintColor,
          ),
        );
      } else {
        return Icon(
          widget.suffixIcon,
          color: context.watch<ColorMode>().textInputIconColor,
        );
      }
    }
  }

  String? validateTextField(String? value) {}
}

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (
        FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}
