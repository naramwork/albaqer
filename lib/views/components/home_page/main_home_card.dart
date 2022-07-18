import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/prayer_time_controller.dart';
import 'package:albaqer/models/arabic_date.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'change_date_widget.dart';

class MainHomeCard extends StatelessWidget {
  final double rad = 60.0;
  const MainHomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rad),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 1.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(rad),
              color: context.watch<ColorMode>().isDarkMode
                  ? const Color(0xff366c85)
                  : const Color(0xff72A0BF),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 1.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rad),
                color: context.watch<ColorMode>().isDarkMode
                    ? const Color(0xff467f9e)
                    : const Color(0xff538CB2),
              ),
              child: Container(
                height: 26.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(rad),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/mosque.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 26.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rad),
                          color: const Color(0xff538CB2).withOpacity(0.7)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 3.h),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                const AssetImage('assets/images/calendar.png'),
                                color: Colors.white,
                                size: 7.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DateContainer(
                                      arabicDate: context
                                          .watch<PrayerTimeController>()
                                          .arabicDate,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => ChangeDateWidget(
                                                arabicDate: context
                                                    .watch<
                                                        PrayerTimeController>()
                                                    .arabicDate),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'الموقع الحالي',
                                style: TextStyle(
                                    //textStyle of the subtitle in the homeScreen
                                    color: Colors.blue.shade100,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0.sp),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 40.w,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ' ' +
                                      context
                                          .watch<PrayerTimeController>()
                                          .locationName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      //textStyle of the heading in the homeScreen
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0.sp),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(bottom: -5.h, left: 7.w, child: const MapContainer()),
      ],
    );
  }
}

class MapContainer extends StatefulWidget {
  const MapContainer({Key? key}) : super(key: key);

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () async {
            // showMapsBottomSheet(context);
            // // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

            if (!serviceEnabled) {
              const snackBar = SnackBar(
                  content: Text(
                      'الرجاء تفعيل ال GBS ثم تحديث الموقع لاحقا للحصول على مواعيد الصلاة بدقة'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            setState(() {
              isLoading = true;
            });

            context
                .read<PrayerTimeController>()
                .initPrayerTime(second: 20)
                .then((value) {
              checkAndAddNotifications(context).then((value) {
                setState(() {
                  isLoading = false;
                });
              });
            });
          },
          child: context.read<PrayerTimeController>().locationError
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset(
                        'assets/images/map_refresh.png',
                        fit: BoxFit.cover,
                        width: 33.w,
                        height: 16.h,
                      ),
                    ),
                    Positioned.fill(
                      child: isLoading
                          ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Color(0xff538CB2),
                              ),
                            )
                          : Icon(
                              Icons.cached_outlined,
                              size: 25.w,
                              color: const Color(0xff538CB2),
                            ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.cover,
                    width: 33.w,
                    height: 16.h,
                  ),
                )),
    );
  }
}

class DateContainer extends StatelessWidget {
  final ArabicDate arabicDate;
  const DateContainer({
    Key? key,
    required this.arabicDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date =
        '${arabicDate.day} ${arabicDate.monthName} - ${arabicDate.year} ه ';
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              date,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp),
            ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              arabicDate.gregorianDate + ' م',
              style: TextStyle(
                  //textStyle of the subtitle in the homeScreen
                  color: Colors.blue.shade100,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0.sp),
            ),
          ),
        ],
      ),
    );
  }
}
