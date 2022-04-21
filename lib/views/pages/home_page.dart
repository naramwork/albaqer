import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/update_content_controler.dart';
import 'package:albaqer/models/verse.dart';
import 'package:albaqer/views/components/content_card_components/card_widget.dart';
import 'package:albaqer/views/components/content_card_components/spinner_bottom_widget.dart';
import 'package:albaqer/views/components/content_card_components/triangle_top_widget.dart';
import 'package:albaqer/views/components/content_card_components/verse_top_widget.dart';
import 'package:albaqer/views/components/home_page/azan_time_home_card.dart';
import 'package:albaqer/views/components/home_page/main_home_card.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/pages/content_pages/duas_page.dart';
import 'package:albaqer/views/pages/content_pages/hadith_online_page.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/verses_page.dart';
import 'package:albaqer/views/pages/holiday/holiday_page.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/pages_bg_rectangle.dart';
import '../main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PagesBgRectangle(),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 5.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const MainHomeCard(),
                SizedBox(
                  height: 6.h,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          MainLayout.routeName,
                          arguments: 3);
                    },
                    child: const AzanTimeHomeCard()),
                SizedBox(
                  height: 6.h,
                ),
                Consumer<UpdateContentController>(
                  builder: (BuildContext context, value, Widget? child) {
                    Verse? verse = value.verseOfTheDay;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(VersesPage.routeName);
                      },
                      child: CardWidget(
                        hieght: (6.h - 3.h),
                        topWidget: Positioned(
                          top: -3.h,
                          left: 20.w,
                          right: 20.w,
                          child: VerseTopWidget(
                            surah: verse?.surah ?? '',
                            part: verse?.part ?? '',
                          ),
                        ),
                        botWidget: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                                style: TextStyle(
                                  color: context.watch<ColorMode>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontFamily: 'Amiri',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              verse?.content == null
                                  ? JumpingDotsProgressIndicator(
                                      color:
                                          context.watch<ColorMode>().isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 30.sp,
                                    )
                                  : Text('${verse?.content.trim()}',
                                      style: TextStyle(
                                          color: context
                                                  .watch<ColorMode>()
                                                  .isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          fontFamily: 'Amiri',
                                          height: 1.6),
                                      textAlign: TextAlign.center),
                              SizedBox(
                                height: 4.h,
                              ),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'صٍدَّقَْ اٌللِهٌ اٌلِعٍَظَِيٌمِ',
                                    style: TextStyle(
                                      color:
                                          context.watch<ColorMode>().isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      fontFamily: 'Amiri',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RoundedButtonWidget(
                    label: const Text(
                      'ايجاد شريك',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    width: 45.w,
                    onpressed: () {
                      gotToMarriagePage(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(HadithOnlinePage.routeName);
                  },
                  child: CardWidget(
                    hieght: (90 - 50),
                    topWidget: const CardTriangleTopWidget(
                      title: 'حديث \nاليوم',
                    ),
                    botWidget: SpinnerBottomWidget(
                      content: parseHtmlString(context
                              .watch<UpdateContentController>()
                              .hadithOfTheDay
                              ?.content ??
                          ''),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(DuasPage.routeName);
                  },
                  child: CardWidget(
                    hieght: (90 - 50),
                    topWidget: const CardTriangleTopWidget(
                      title: 'دعاء \nاليوم',
                    ),
                    botWidget: SpinnerBottomWidget(
                      content: context
                              .watch<UpdateContentController>()
                              .duaOfTheDay
                              ?.content ??
                          '',
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                context.watch<UpdateContentController>().holidays.isEmpty
                    ? Container()
                    : InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(HolidayPage.routeName);
                        },
                        child: CardWidget(
                          hieght: (6.h - 3.h),
                          topWidget: Positioned(
                            top: -3.h,
                            left: 20.w,
                            right: 20.w,
                            child: const VerseTopWidget(
                              surah: 'المناسبات',
                              part: '',
                            ),
                          ),
                          botWidget: SpinnerBottomWidget(
                            content: context
                                .watch<UpdateContentController>()
                                .holidays,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 15.0.h,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
