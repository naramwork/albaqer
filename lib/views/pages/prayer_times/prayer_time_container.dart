import 'package:albaqer/views/pages/prayer_times/change_time_button.dart';
import 'package:albaqer/views/pages/prayer_times/notification_button.dart';
import 'package:albaqer/views/pages/prayer_times/prayer_time_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:expandable/expandable.dart';

class PrayerTimeContainer extends StatelessWidget {
  final String salahName;
  final String dateName;
  final String imageUrl;
  final Color filterColer;
  final Color color;
  final String prayerEnglishName;

  const PrayerTimeContainer(
      {Key? key,
      required this.salahName,
      required this.dateName,
      required this.imageUrl,
      required this.filterColer,
      required this.prayerEnglishName,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        scrollOnCollapse: false,
        child: Expandable(
          collapsed: ExpandableButton(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: PrayerTimeCard(
                  salahName: salahName,
                  dateName: dateName,
                  imageUrl: imageUrl,
                  filterColer: filterColer,
                  color: color),
            ),
          ),
          expanded: ExpandableButton(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: SizedBox(
                height: 65.w,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(2.w, 20.w, 2.w, 0),
                        height: 40.w,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromRGBO(4, 40, 82, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NotificationToggleButton(
                              salahName: salahName,
                            ),
                            VerticalDivider(
                              color: Colors.white,
                              indent: 1.5.h,
                              endIndent: 1.5.h,
                              thickness: 1.5,
                            ),
                            ChangeTimeButton(
                              salahName: salahName,
                              prayerEnglishName: prayerEnglishName,
                            ),
                          ],
                        ),
                      ),
                    ),
                    PrayerTimeCard(
                        salahName: salahName,
                        dateName: dateName,
                        imageUrl: imageUrl,
                        filterColer: filterColer,
                        color: color),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
