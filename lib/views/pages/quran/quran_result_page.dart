import 'package:albaqer/app/helper_files/functions.dart';
import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/full_quran/quran.dart';
import 'package:albaqer/models/qurran_result.dart';
import 'package:albaqer/models/surah.dart';
import 'package:albaqer/views/components/layout/custom_bottom_app_bar.dart';
import 'package:albaqer/views/components/layout/fap.dart';

import 'package:albaqer/views/pages/quran/quran_search_dialog.dart';
import 'package:albaqer/views/pages/quran/quran_search_page.dart';
import 'package:albaqer/views/pages/quran/surah_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../components/marriage_app_bar.dart';

class QuranResultPage extends StatefulWidget {
  static String routeName = '/quran_result_page';
  const QuranResultPage({Key? key}) : super(key: key);

  @override
  State<QuranResultPage> createState() => _QuranResultPageState();
}

class _QuranResultPageState extends State<QuranResultPage> {
  double fontSize = 16;
  List<String> surahsNames = [];
  String? _selectedItem;
  QuranResult? foundedVerse;
  int initIndex = 0;
  List<Surah> fullQuran = [];
  String foundedVerseString = 'naram';
  List<Surah> searchSurah = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getFullQuran();
    final route = ModalRoute.of(context);
    if (route != null) {
      final args = route.settings.arguments;
      if (args != null) {
        foundedVerse = args as QuranResult;
      }
    }
    if (foundedVerse != null) {
      onSurahSearch(foundedVerse!);
    }
    surahsNames = getSurrahsNames();
    _selectedItem = surahsNames.first;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: MarriageAppBar(
        appBar: AppBar(),
      ),
      body: Container(
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
                                      color:
                                          context.watch<ColorMode>().isDarkMode
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
                    ? ScrollablePositionedList.builder(
                        itemCount: fullQuran.length,
                        initialScrollIndex: initIndex,
                        itemBuilder: (context, index) => SurahContainer(
                          surah: fullQuran[index],
                          searchVerse: foundedVerseString,
                          fontSize: fontSize,
                        ),
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
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
      ),
      floatingActionButton: FAP(
        onPressed: () {
          gotToMarriagePage(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(
        selectedIndex: 1,
        selectPage: selectPage,
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

  void onSurahSearch(QuranResult quranResult) {
    int index = fullQuran.indexWhere((surah) {
      if (surah.juzNumber == quranResult.verse.juzNumber &&
          surah.number == quranResult.verse.surahNumber) return true;
      return false;
    });

    if (index != -1) {
      initIndex = index;
      foundedVerseString = quranResult.verse.content;
    }
    // if (WidgetsBinding.instance != null) {
    //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //     String message = '';
    //     if (quranResult.isReadMark) {
    //       message =
    //           "العلامة المرجعية موجودة في الاية رقم ${quranResult.verse.verseNumber} من سورة ${quranResult.verse.surah}";
    //     } else {
    //       message =
    //           "النتيجة موجودة في الاية رقم ${quranResult.verse.verseNumber} من سورة ${quranResult.verse.surah}";
    //     }
    //     showSnackBar(message, context);
    //   });
    // }
  }

  void onSurahSelect(int number) {
    searchSurah.clear();

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

  getFullQuran() {
    List surahsJson = Quran.getFullQuran();

    for (var surah in surahsJson) {
      fullQuran.add(Surah(
          number: surah['surah_number'],
          content: surah['content'],
          juzNumber: surah['juz_num'],
          name: surah['surah_name']));
    }
  }
}
