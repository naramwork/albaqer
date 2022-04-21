import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/views/components/page_name_container.dart';
import 'package:albaqer/views/pages/content_pages/duas_page.dart';
import 'package:albaqer/views/pages/content_pages/hadith_online_page.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/verses_page.dart';
import 'package:albaqer/views/pages/holiday/holiday_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../main_layout.dart';

class AllContentPage extends StatefulWidget {
  const AllContentPage({Key? key}) : super(key: key);

  @override
  _AllContentPageState createState() => _AllContentPageState();
}

class _AllContentPageState extends State<AllContentPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(0),
            child: Container(
              width: 85.w,
              height: double.infinity,
              color: context.watch<ColorMode>().isDarkMode
                  ? const Color(0xff111C2E)
                  : Colors.white,
            ),
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -5.h, 0.0),
          child: CustomScrollView(
            slivers: [
              PageNameContainer(
                pageTitle: 'المحتوى اليومي',
                minHeight: 15.0.h,
                maxHeight: 25.0.h,
                bottomBorderRad: const Radius.elliptical(100, 40),
                backgroundImageUrl: 'assets/images/mosque.png',
              ),
              SliverPadding(
                  padding: EdgeInsets.fromLTRB(3.w, 5.h, 3.w, 10.h),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ContentTypeCard(
                                name: 'آيات قرآنية',
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(VersesPage.routeName);
                                },
                                imageUrl: 'assets/images/quran.png'),
                            SizedBox(
                              width: 2.w,
                            ),
                            ContentTypeCard(
                                name: 'الأدعية اليومية',
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(DuasPage.routeName);
                                },
                                imageUrl: 'assets/images/duas_bg.png'),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ContentTypeCard(
                                name: 'الحديث الشريف',
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(HadithOnlinePage.routeName);
                                },
                                imageUrl: 'assets/images/small_mosque.png'),
                            SizedBox(
                              width: 2.w,
                            ),
                            ContentTypeCard(
                                name: 'المناسبات',
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(HolidayPage.routeName);
                                },
                                imageUrl: 'assets/images/colored_mosque.jpg'),
                          ],
                        ),
                      ],
                      //6077E5
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}

class ContentTypeCard extends StatelessWidget {
  final String name;
  final Function onTap;
  final String imageUrl;
  final double rad = 40;
  const ContentTypeCard(
      {Key? key,
      required this.name,
      required this.onTap,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42.w,
      height: 45.w,
      child: InkWell(
          onTap: () {
            onTap();
          },
          child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rad),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 42.w,
                    height: 45.w,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.fromLTRB(2.w, 3.h, 2.w, 0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(rad),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(imageUrl),
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.6), BlendMode.dstIn),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(rad),
                        ),
                        color: Colors.white30,
                      ),
                      width: 42.w,
                      height: 6.h,
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
