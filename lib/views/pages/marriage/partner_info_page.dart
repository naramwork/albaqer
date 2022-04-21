import 'package:auto_size_text/auto_size_text.dart';
import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/app/themes/color_const.dart';

import 'package:albaqer/controllers/marriage_controller.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';
import 'package:albaqer/views/components/marriage/send_message_dialog.dart';
import 'package:albaqer/views/components/name_header_card.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../main_layout.dart';

class PartnerInfoPage extends StatelessWidget {
  static String routeName = '/partner_info_page';
  const PartnerInfoPage({Key? key}) : super(key: key);

  void selectPage(int index, BuildContext context) {
    Navigator.of(context).pushNamed(MainLayout.routeName, arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    final route = ModalRoute.of(context);
    if (route != null) {
      final args = route.settings.arguments;
      if (args != null) {
        user = args as User;
      }
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              NameHeaderCard(
                title: user?.name ?? '',
                hasClose: true,
              ),
              SizedBox(
                height: 10.h,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xff1e5180),
                      ),
                      child: Transform.translate(
                          offset: Offset(0, -15.w),
                          child: AllInfoColumn(
                            user: user,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FAP(
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: 0,
        selectPage: selectPage,
      ),
    );
  }
}

class AllInfoColumn extends StatefulWidget {
  final User? user;
  const AllInfoColumn({Key? key, required this.user}) : super(key: key);

  @override
  _AllInfoColumnState createState() => _AllInfoColumnState();
}

class _AllInfoColumnState extends State<AllInfoColumn> {
  bool isReadMore = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Card(
            elevation: 2.0,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade50,
              backgroundImage: NetworkImage(widget.user!.imageUrl),
              maxRadius: 20.w,
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: [
            Icon(
              Icons.work,
              color: ColorConst.lightCylan,
            ),
            SizedBox(
              width: 5.w,
            ),
            AutoSizeText(
              widget.user?.job ?? '',
              maxLines: 1,
              style: TextStyle(
                  color: ColorConst.lightCylan,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: [
            Icon(
              Icons.person,
              color: ColorConst.lightCylan,
            ),
            SizedBox(
              width: 5.w,
            ),
            AutoSizeText(
              widget.user?.socialStatus ?? '',
              maxLines: 1,
              style: TextStyle(
                  color: ColorConst.lightCylan,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
            content:
                'العمر ${calculateAge(widget.user?.birthDate ?? DateTime.now())} سنة',
            icon: Icons.create),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
            content:
                'مكان الإقامة ${widget.user?.country} ${widget.user?.city}',
            icon: Icons.apartment),
        SizedBox(
          height: 4.h,
        ),
        Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xff6796C2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات حولي',
                    style: TextStyle(
                      color: ColorConst.lightCylan,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    widget.user?.aboutYou ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : Container(),
          ],
        ),
        SizedBox(height: 4.h),
        InkWell(
          onTap: () {
            setState(() {
              isReadMore = !isReadMore;
            });
          },
          child: Row(
            children: const [
              Text(
                'مشاهدة المزيد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              )
            ],
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
        isReadMore
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isReadMore = !isReadMore;
                  });
                },
                child: MoreInfo(
                  user: widget.user,
                ),
              )
            : Container(),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: [
            RoundedButtonWidget(
              borderRad: 50,
              label: const Text(
                'مراسلة',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              width: 30.w,
              onpressed: () {
                showDialog(
                    context: context,
                    builder: (context) => SendMessageDialog(
                          sendMessage: (content) {
                            setState(() {
                              isLoading = true;
                            });
                            context
                                .read<MarriageController>()
                                .sendMessage(
                                    content: content,
                                    recipientId: widget.user!.id)
                                .then((value) {
                              if (value != null) {
                                showSnackBar('تم إرسال الرسالة', context);
                              } else {
                                showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا',
                                    context);
                              }
                              Navigator.pop(context);
                            });
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ));
              },
            ),
            RoundedButtonWidget(
              borderRad: 50,
              label: const Text(
                'طلب زواج',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              width: 30.w,
              onpressed: () {
                setState(() {
                  isLoading = true;
                });
                context
                    .read<MarriageController>()
                    .sendMarriageRequest(widget.user?.id ?? 0)
                    .then((value) {
                  if (value.containsKey('status')) {
                    showSnackBar(value['content'], context);
                  }
                  setState(() {
                    isLoading = false;
                  });
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class MoreInfo extends StatelessWidget {
  final User? user;
  const MoreInfo({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoRow(
          content: 'الجنسية ${user?.nationality}',
          icon: Icons.map_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'الطول (سم) ${user?.height}',
          icon: Icons.height_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'الوزن (كغ) ${user?.weight}',
          icon: Icons.monitor_weight_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'الصلاة ${user?.prayer}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'التدين ${user?.religiosity}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        user?.childrenNumber == 0
            ? Container()
            : InfoRow(
                content: 'عدد الأطفال  ${user?.childrenNumber}',
                icon: Icons.person,
              ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'بنية الجسم ${user?.physique}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'لون البشرة ${user?.skinColour}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'التدخين ${user?.smoking}',
          icon: Icons.smoking_rooms_rounded,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'اللحية ${user?.beard}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'الوضع المادي ${user?.financialStatus}',
          icon: Icons.money,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'المؤهل العلمي ${user?.educational}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'مجال العمل ${user?.employment}',
          icon: Icons.work_outline,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'الدخل الشهري ${user?.income}',
          icon: Icons.create_outlined,
        ),
        SizedBox(
          height: 2.h,
        ),
        InfoRow(
          content: 'الحالة الصحية ${user?.healthStatus}',
          icon: Icons.local_hospital_outlined,
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String content;
  final IconData icon;
  const InfoRow({Key? key, required this.content, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: ColorConst.lightCylan,
        ),
        SizedBox(
          width: 5.w,
        ),
        AutoSizeText(
          content,
          maxLines: 1,
          style: TextStyle(
              color: ColorConst.lightCylan,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
