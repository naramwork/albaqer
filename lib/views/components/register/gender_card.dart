import 'package:albaqer/controllers/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GenderCard extends StatefulWidget {
  final Function changeGender;
  final String gender;

  const GenderCard({Key? key, required this.changeGender, required this.gender})
      : super(key: key);

  @override
  State<GenderCard> createState() => _GenderCardState();
}

class _GenderCardState extends State<GenderCard> {
  String gender = '';
  @override
  void initState() {
    gender = widget.gender;
    super.initState();
  }

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
              width: 8.w,
            ),
            Center(
              child: Text(
                'الجنس',
                style: TextStyle(
                    color: context.watch<ColorMode>().textInputHintColor,
                    fontSize: 16),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: RadioListTile(
                      value: 'm',
                      groupValue: gender,
                      onChanged: (value) {
                        widget.changeGender(value);

                        setState(() {
                          gender = value as String;
                        });
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'ذكر',
                          style: TextStyle(
                              color:
                                  context.watch<ColorMode>().textInputHintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: RadioListTile(
                      value: 'f',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          widget.changeGender(value);
                          gender = value as String;
                        });
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'انثى',
                          style: TextStyle(
                              color:
                                  context.watch<ColorMode>().textInputHintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
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
