import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/update_content_controler.dart';
import 'package:albaqer/models/dua.dart';
import 'package:albaqer/views/components/content_card_components/bottom_widget.dart';
import 'package:albaqer/views/components/content_card_components/card_widget.dart';
import 'package:albaqer/views/components/content_card_components/icon_triangle_top_widget.dart';
import 'package:albaqer/views/components/static_page_name_container.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DuasPage extends StatelessWidget {
  static const routeName = '/duas_page';

  const DuasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Dua> duas =
        context.watch<UpdateContentController>().duas.take(300).toList();
    return Scaffold(
      body: Stack(children: [
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
        Column(
          children: [
            StaticPageNameContainer(
              pageTitle: '﴿  الأدعية اليومية ﴾',
              maxHeight: 27.0.h,
              bottomBorderRad: const Radius.elliptical(100, 40),
              backgroundImageUrl: 'assets/images/duas_bg.png',
              imageAlignment: Alignment.bottomRight,
            ),
            duas.isEmpty
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF184B6C),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: duas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 3.h),
                          child: CardWidget(
                            title: getArabicDay(duas[index].order),
                            hieght: (7.h -
                                3.8.h), // container hight - top positione
                            topWidget: const IconTriangleTopWidget(
                              icon: ImageIcon(
                                  AssetImage('assets/images/dua_icon.png'),
                                  color: Colors.white),
                            ),
                            botWidget: BottomWidget(
                              content: duas[index].content.trim(),
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
        Positioned(
            top: 6.h,
            right: 6.w,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ]),
    );
  }
}
