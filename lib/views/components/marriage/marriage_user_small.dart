import 'package:auto_size_text/auto_size_text.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/views/pages/marriage/partner_info_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MarriageUserSmall extends StatelessWidget {
  final User user;
  const MarriageUserSmall({Key? key, required this.user}) : super(key: key);

  TextStyle setTextStyle(double fontSize) {
    return TextStyle(
        color: const Color(0xff84FFFF),
        fontSize: fontSize,
        fontWeight: FontWeight.w500);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PartnerInfoPage.routeName, arguments: user);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xff1e5180),
              ),
            ),
          ),
          Positioned(
            top: -7.5.w,
            right: 0,
            left: 0,
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    Card(
                      elevation: 2.0,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade50,
                        backgroundImage: NetworkImage(user.imageUrl),
                        maxRadius: 15.w,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    AutoSizeText(
                      user.name,
                      maxLines: 1,
                      style: setTextStyle(16),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        user.job,
                        maxLines: 1,
                        style: setTextStyle(12),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          user.socialStatus,
                          maxLines: 1,
                          style: setTextStyle(12),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        AutoSizeText(
                          'العمر ${calculateAge(user.birthDate)} سنة',
                          maxLines: 1,
                          style: setTextStyle(12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          AutoSizeText(
                            'عرض المزيد',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
