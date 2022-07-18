import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/full_quran/quran.dart';
import 'package:albaqer/models/new_verse.dart';
import 'package:albaqer/models/surah.dart';
import 'package:albaqer/views/pages/quran/quran_search_dialog.dart';
import 'package:albaqer/views/pages/quran/surah_container.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'quran_search_page.dart';

class QuranPage extends StatefulWidget {
  static String routeName = '/quran_page';
  const QuranPage({Key? key}) : super(key: key);

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final PagingController<int, Surah> _pagingController =
      PagingController(firstPageKey: 1);
  double fontSize = 16;
  List<String> surahsNames = [];
  String? _selectedItem;
  NewVerse? foundedVerse;
  String foundedVerseString = '';
  List<Surah> searchSurah = [];

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pagingController.addPageRequestListener((pageKey) {
      getQuran(pageKey);
    });
    surahsNames = getSurrahsNames();
    _selectedItem = surahsNames.first;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.watch<ColorMode>().isDarkMode
          ? const Color(0xFF184B6C)
          : Colors.white,
      transform: Matrix4.translationValues(0.0, -5.h, 0.0),
      padding: EdgeInsets.fromLTRB(2.w, 5.h, 2.w, 0.h),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: context.watch<ColorMode>().isDarkMode
            ? const Color.fromARGB(255, 0, 10, 22)
            : Colors.grey.shade100,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return QuranSearchDialog();
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Icon(
                        Icons.search,
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedItem,
                      dropdownColor: context.watch<ColorMode>().isDarkMode
                          ? ColorConst.darkCardColor
                          : Colors.white,
                      iconEnabledColor: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      items: surahsNames
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: context.watch<ColorMode>().isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: 'Amiri'),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        _selectedItem = value;
                        int surahNumber = surahsNames.indexOf(value) + 1;
                        onSurahSelect(surahNumber);
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(QuranSearchPage.routeName);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(1.w, 2.h, 3.w, 2.h),
                      child: Icon(
                        Icons.bookmark_border,
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (fontSize <= 20) {
                              fontSize++;
                            }
                          });
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (fontSize >= 10) {
                              fontSize = fontSize - 1;
                            }
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: searchSurah.isEmpty
                  ? PagedListView(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Surah>(
                          itemBuilder: (context, surah, index) {
                            return SurahContainer(
                              surah: surah,
                              searchVerse: foundedVerseString,
                              fontSize: fontSize,
                            );
                          },
                          firstPageProgressIndicatorBuilder: (c) =>
                              const Center(
                                child: CircularProgressIndicator(),
                              )),
                    )
                  : ListView.builder(
                      itemBuilder: (context, i) {
                        return SurahContainer(
                          surah: searchSurah[i],
                          searchVerse: foundedVerseString,
                          fontSize: fontSize,
                        );
                      },
                      itemCount: searchSurah.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSurrahsNames() {
    List<String> surahsNams = [];
    surahsNams.add('كامل');

    for (int i = 1; i <= 114; i++) {
      surahsNams.add('سورة ${Quran.getSuranArabicName(i)}');
    }

    return surahsNams;
  }

  void onSurahSearch(NewVerse verse) {
    searchSurah.clear();
    _pagingController.refresh();
    List surahs = Quran.onSurahSelect(verse.surahNumber);
    int juzNumber = int.parse(verse.part.replaceAll('الجزء', '').trim());

    for (var surah in surahs) {
      if (surah['juz_num'] == juzNumber) {
        searchSurah.add(Surah(
            number: surah['surah_number'],
            content: surah['content'],
            juzNumber: surah['juz_num'],
            name: surah['surah_name']));
      }

      foundedVerseString = verse.content;
    }
    setState(() {});
  }

  void onSurahSelect(int number) {
    searchSurah.clear();
    _pagingController.refresh();
    if (number == 1) {
      _pagingController.refresh();
    }
    List surahs = Quran.onSurahSelect(number - 1);
    for (var surah in surahs) {
      searchSurah.add(Surah(
          number: surah['surah_number'],
          content: surah['content'],
          juzNumber: surah['juz_num'],
          name: surah['surah_name']));
    }

    setState(() {});
  }

  Future<List<Surah>> getQuran(int juz) async {
    List<Surah> surahs = [];
    if (juz <= Quran.getTotalJuzCount()) {
      List<int> suarhMap = Quran.getSurahFromJuz(juz);
      List surahsList = Quran.getQuran(suarhMap);
      for (var surah in surahsList) {
        surahs.add(Surah(
            number: surah['surah_number'],
            content: surah['content'],
            juzNumber: surah['juz_num'],
            name: surah['surah_name']));
      }
      if (juz == Quran.getTotalJuzCount()) {
        _pagingController.appendLastPage(surahs);
      } else {
        _pagingController.appendPage(surahs, juz + 1);
      }
    }
    return surahs;
  }
}
