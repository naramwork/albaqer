import 'package:adhan_dart/adhan_dart.dart';
import 'package:albaqer/views/components/page_name_container.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/models/prayer_hour.dart';
import 'package:albaqer/models/prayer_notification.dart';
import 'package:albaqer/views/pages/prayer_times/prayer_time_container.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/page_name_container.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({Key? key}) : super(key: key);

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  List<PrayerHour> prayerHour = [];
  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize = 15;
  final columns = 4;
  bool isLoading = true;
  PrayerTimes? prayerTimes;

  // @override
  // void initState() {
  //   super.initState();

  //   AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //     if (!isAllowed) {
  //       // Insert here your friendly dialog box before call the request method
  //       // This is very important to not harm the user experience
  //       AwesomeNotifications().requestPermissionToSendNotifications();
  //     }
  //   });
  // }

  @override
  void didChangeDependencies() {
    prayerTimes = context.watch<PrayerTimeController>().prayerTimes;
    getPrayer();
    super.didChangeDependencies();
  }

  void getPrayer() {
    prayerHour.clear();

    if (prayerTimes != null) {
      prayerHour = [
        PrayerHour(
          salahName: 'صلاة الفجر',
          time: convertTimeToString(prayerTimes!.fajr),
          imageUrl: 'assets/images/fajer.png',
          prayerEnglishName: Prayer.Fajr,
        ),
        PrayerHour(
            salahName: 'صلاة الظهر',
            time: convertTimeToString(prayerTimes!.dhuhr),
            imageUrl: 'assets/images/zoher.png',
            prayerEnglishName: Prayer.Dhuhr),
        PrayerHour(
            salahName: 'صلاة العصر',
            time: convertTimeToString(prayerTimes!.asr),
            imageUrl: 'assets/images/asr.png',
            prayerEnglishName: Prayer.Asr),
        PrayerHour(
            salahName: 'صلاة المغرب',
            time: convertTimeToString(prayerTimes!.maghrib),
            imageUrl: 'assets/images/magrb.png',
            prayerEnglishName: Prayer.Maghrib),
        PrayerHour(
            salahName: 'صلاة العشاء',
            time: convertTimeToString(prayerTimes!.isha),
            imageUrl: 'assets/images/isha.png',
            prayerEnglishName: Prayer.Isha),
      ];
      setState(() {
        isLoading = false;
      });
    }

    //checkAndAddNotifications(context);
  }

  void onChange(String value, BuildContext context) {
    setState(() {
      isLoading = true;
    });
    context
        .read<PrayerTimeController>()
        .setPrayerCalculationParam(value == 'shafi', value == 'shi3i')
        .then((value) {
      getPrayer();
    });
  }

  void checkAndAddNotifications(BuildContext context) async {
    await Hive.openBox<PrayerNotification>(kNotificationBoxName);
    context.read<PrayerTimeController>().setWeeklyPrayerTime();
  }

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
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                transform: Matrix4.translationValues(0.0, -5.h, 0.0),
                child: CustomScrollView(
                  slivers: [
                    PageNameContainer(
                      pageTitle: '﴿ مواعيد الصلاة ﴾',
                      minHeight: 15.0.h,
                      maxHeight: 25.0.h,
                      bottomBorderRad: const Radius.elliptical(100, 40),
                      backgroundImageUrl: 'assets/images/duas_bg.png',
                    ),
                    SliverPadding(
                        padding: EdgeInsets.fromLTRB(3.w, 5.h, 3.w, 5.h),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PrayerTimeContainer(
                                    salahName: prayerHour[0].salahName,
                                    dateName: prayerHour[0].time,
                                    imageUrl: prayerHour[0].imageUrl,
                                    prayerEnglishName:
                                        prayerHour[0].prayerEnglishName,
                                    filterColer: Colors.blue.withOpacity(0.2),
                                    color: Colors.blue.shade300,
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  PrayerTimeContainer(
                                    salahName: prayerHour[1].salahName,
                                    dateName: prayerHour[1].time,
                                    imageUrl: prayerHour[1].imageUrl,
                                    prayerEnglishName:
                                        prayerHour[1].prayerEnglishName,
                                    filterColer: Colors.blue.withOpacity(0.3),
                                    color: Colors.blue.shade200,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PrayerTimeContainer(
                                    salahName: prayerHour[2].salahName,
                                    dateName: prayerHour[2].time,
                                    imageUrl: prayerHour[2].imageUrl,
                                    prayerEnglishName:
                                        prayerHour[2].prayerEnglishName,
                                    filterColer: Colors.blue.withOpacity(0.3),
                                    color: const Color(0xff8AC0FF),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  PrayerTimeContainer(
                                    salahName: prayerHour[3].salahName,
                                    dateName: prayerHour[3].time,
                                    imageUrl: prayerHour[3].imageUrl,
                                    prayerEnglishName:
                                        prayerHour[3].prayerEnglishName,
                                    filterColer: Colors.blue.withOpacity(0.3),
                                    color: const Color(0xff8B95DD),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PrayerTimeContainer(
                                    salahName: prayerHour[4].salahName,
                                    dateName: prayerHour[4].time,
                                    imageUrl: prayerHour[4].imageUrl,
                                    prayerEnglishName:
                                        prayerHour[4].prayerEnglishName,
                                    filterColer: Colors.blue.withOpacity(0.3),
                                    color: const Color(0xff7382EE),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? value;
                                      if (prefs.getBool(kIsShafiKey) != null) {
                                        if (prefs.getBool(kIsShafiKey)!) {
                                          value = 'shafi';
                                        } else {
                                          if (prefs.getBool(kIsShi3iKey)!) {
                                            value = 'shi3i';
                                          } else {
                                            value = 'hanafi';
                                          }
                                        }
                                      }
                                      //print('value: $value');

                                      showDialog(
                                          context: context,
                                          builder: (ctx) => MazhabDialog(
                                                onChange: onChange,
                                                value: value,
                                              ));
                                    },
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Container(
                                        width: 42.w,
                                        height: 45.w,
                                        padding:
                                            EdgeInsets.fromLTRB(2.w, 0, 2.w, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: const Color(0xff7382EE),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.blue.withOpacity(0.2),
                                                BlendMode.dstIn),
                                            image: const AssetImage(
                                                'assets/images/colored_mosque.jpg'),
                                          ),
                                        ),
                                        child: Align(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.6),
                                            ),
                                            child: const Text(
                                              'اختيار المذهب',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            //6077E5
                          ),
                        )),
                  ],
                ),
              ),
      ],
    );
  }

  String convertTimeToString(DateTime? dateTime) {
    return DateFormat.jms('ar_Dz').format(dateTime!.toLocal()).toString();
  }
}

class MazhabDialog extends StatelessWidget {
  final Function onChange;
  final String? value;
  const MazhabDialog({Key? key, required this.onChange, this.value})
      : super(key: key);

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
        child: DropdownButton<String>(
          alignment: Alignment.centerRight,
          borderRadius: BorderRadius.circular(20),
          hint: AutoSizeText(
            'اختيار المذهب',
            maxLines: 1,
            style: TextStyle(
                fontFamily: 'Tajawal',
                color: context.watch<ColorMode>().isDarkMode
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ), // Not necessary for Option 1
          value: value,
          itemHeight: 10.h,
          dropdownColor: context.watch<ColorMode>().isDarkMode
              ? const Color(0xFF184B6C)
              : Colors.white,
          icon: Icon(
            Icons.arrow_drop_down,
            color: context.watch<ColorMode>().isDarkMode
                ? Colors.white
                : Colors.black,
          ),

          items: [
            DropdownMenuItem<String>(
              value: 'shafi',
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                child: Text(
                  'شافعي، حنبلي، مالكي',
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'shi3i',
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                child: Text(
                  'المذهب الجعفري',
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'hanafi',
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                child: Text(
                  'حنفي',
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
          onChanged: (newValue) {
            onChange(newValue, context);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
