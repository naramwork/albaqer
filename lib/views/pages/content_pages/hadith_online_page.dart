import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/verses_controller.dart';
import 'package:albaqer/models/hadith.dart';
import 'package:albaqer/views/components/content_card_components/bottom_widget.dart';
import 'package:albaqer/views/components/content_card_components/card_widget.dart';
import 'package:albaqer/views/components/content_card_components/icon_triangle_top_widget.dart';

import 'package:albaqer/views/components/static_page_name_container.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class HadithOnlinePage extends StatefulWidget {
  static const routeName = '/hadith_page';

  const HadithOnlinePage({Key? key}) : super(key: key);

  @override
  _HadithOnlinePageState createState() => _HadithOnlinePageState();
}

class _HadithOnlinePageState extends State<HadithOnlinePage> {
  final PagingController<int, Hadith> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<VersesController>().fetchHadith(pageKey, _pagingController);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        RefreshIndicator(
            onRefresh: () => Future.sync(
                  // 2
                  () => _pagingController.refresh(),
                ),
            child: Stack(
              children: [
                Column(children: [
                  StaticPageNameContainer(
                    pageTitle: '﴿  الحديث الشريف ﴾',
                    maxHeight: 27.0.h,
                    bottomBorderRad: const Radius.elliptical(100, 40),
                    boxFit: BoxFit.contain,
                    backgroundImageUrl: 'assets/images/quran.png',
                    imageAlignment: Alignment.bottomRight,
                  ),
                  Expanded(
                    child: PagedListView.separated(
                      pagingController: _pagingController,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      builderDelegate: PagedChildBuilderDelegate<Hadith>(
                        itemBuilder: (context, hadith, index) => Padding(
                          padding: EdgeInsets.only(bottom: 4.h, top: 3.h),
                          child: CardWidget(
                            hieght: (7.h -
                                3.8.h), // container hight - top positione
                            topWidget: const IconTriangleTopWidget(
                              icon: ImageIcon(
                                  AssetImage('assets/images/rosary.png'),
                                  color: Colors.white),
                            ),
                            botWidget: BottomWidget(
                              content: parseHtmlString(hadith.content.trim()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]
                    // 3
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
                  ),
                ),
              ],
            ))
      ]),
    );
  }

  Widget buildTextWidget(String content, double font) => Text(
        content,
        style: TextStyle(
          fontFamily: 'Amiri',
          color: context.watch<ColorMode>().isDarkMode
              ? Colors.white
              : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: font,
        ),
        textAlign: TextAlign.center,
      );
}
