import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/verses_controller.dart';
import 'package:albaqer/models/verse.dart';
import 'package:albaqer/views/components/content_card_components/card_widget.dart';
import 'package:albaqer/views/components/content_card_components/verse_top_widget.dart';
import 'package:albaqer/views/components/empty.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';

import 'package:albaqer/views/components/static_page_name_container.dart';
import 'package:albaqer/views/pages/content_pages/verses_pages/previous_verses_page.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class OnlineVersesPage extends StatefulWidget {
  const OnlineVersesPage({Key? key}) : super(key: key);

  @override
  _OnlineVersesPageState createState() => _OnlineVersesPageState();
}

class _OnlineVersesPageState extends State<OnlineVersesPage> {
  final PagingController<int, Verse> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<VersesController>().fetchVerses(pageKey, _pagingController);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(
              // 2
              () => _pagingController.refresh(),
            ),
        child: Stack(
          children: [
            Column(children: [
              StaticPageNameContainer(
                pageTitle: '﴿  آيات قرآنية ﴾',
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
                  builderDelegate: PagedChildBuilderDelegate<Verse>(
                      firstPageErrorIndicatorBuilder: ((context) =>
                          const EmptyWidget(
                            title: 'تأكد من اتصالك بالإنترنت',
                          )),
                      newPageErrorIndicatorBuilder: ((context) =>
                          const EmptyWidget(
                            title: 'تأكد من اتصالك بالإنترنت',
                          )),
                      itemBuilder: (context, verse, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RoundedButtonWidget(
                                  label: const Text(
                                    'الآيات السابقة',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  width: 30.w,
                                  onpressed: () => Navigator.pushNamed(
                                      context, PreviousVersesPage.routeName),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              buildCardWidget(verse, context),
                            ],
                          );
                        }
                        return buildCardWidget(verse, context);
                      }),
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
        ));
  }

  Padding buildCardWidget(Verse verse, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: CardWidget(
          hieght: (6.h - 3.h), // container hight - top positione
          topWidget: Positioned(
            top: -3.h,
            right: 10.w,
            child: VerseTopWidget(
              surah: verse.surah,
              part: verse.part,
            ),
          ),
          botWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextWidget('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ', 15),
                SizedBox(
                  height: 4.h,
                ),
                SelectableText(verse.content.trim(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      height: 2,
                      fontFamily: 'Amiri',
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 4.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: buildTextWidget('صٍدَّقَْ اٌللِهٌ اٌلِعٍَظَِيٌمِ', 15),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildTextWidget(String content, double font) => Text(
        content,
        style: TextStyle(
          fontFamily: 'Amiri',
          color: context.watch<ColorMode>().isDarkMode
              ? Colors.white
              : Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: font,
        ),
        textAlign: TextAlign.center,
      );
}
