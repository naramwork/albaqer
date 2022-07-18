import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/full_quran/quran.dart';
import 'package:albaqer/models/new_verse.dart';
import 'package:albaqer/models/qurran_result.dart';
import 'package:albaqer/views/components/content_card_components/card_widget.dart';
import 'package:albaqer/views/components/content_card_components/verse_top_widget.dart';
import 'package:albaqer/views/pages/quran/quran_result_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/marriage_app_bar.dart';

class QuranSearchPage extends StatefulWidget {
  static String routeName = '/quran_search_page';
  const QuranSearchPage({Key? key}) : super(key: key);

  @override
  _QuranSearchPageState createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  String searchWord = '';
  @override
  void didChangeDependencies() {
    final route = ModalRoute.of(context);
    if (route != null) {
      final args = route.settings.arguments;

      if (args != null) {
        searchWord = args as String;
      } else {}
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MarriageAppBar(appBar: AppBar()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Stack(
          children: [
            Center(
              child: FutureBuilder<List<NewVerse>>(
                  future: getVersesResult(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError ||
                          (snapshot.data != null && snapshot.data!.isEmpty)) {
                        return Text(
                          'لايوجد نتائج',
                          style: TextStyle(
                              color: context.watch<ColorMode>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (ctx, i) => InkWell(
                            onTap: () {
                              QuranResult quranResult = searchWord.isEmpty
                                  ? QuranResult(
                                      isReadMark: true,
                                      verse: snapshot.data![i])
                                  : QuranResult(
                                      isReadMark: false,
                                      verse: snapshot.data![i]);
                              Navigator.of(context).pushNamed(
                                  QuranResultPage.routeName,
                                  arguments: quranResult);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 4.h, top: 3.h),
                              child: CardWidget(
                                  hieght: (6.h -
                                      3.h), // container hight - top positione
                                  topWidget: Positioned(
                                    top: -3.h,
                                    right: 10.w,
                                    child: VerseTopWidget(
                                      surah: snapshot.data![i].surahNumber
                                          .toString(),
                                      part: snapshot.data![i].verseNumber
                                          .toString(),
                                    ),
                                  ),
                                  botWidget: Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                                    child: searchWord.isEmpty
                                        ? Column(
                                            children: [
                                              Text(
                                                snapshot.data![i].content
                                                    .trim(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  height: 1.5,
                                                  fontFamily: 'Amiri',
                                                  color: context
                                                          .watch<ColorMode>()
                                                          .isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: TextButton.icon(
                                                    onPressed: () {
                                                      deleteReadMark(
                                                          snapshot.data![i]);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    label: const Text('حذف')),
                                              )
                                            ],
                                          )
                                        : Text(
                                            snapshot.data![i].content.trim(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              height: 1.5,
                                              fontFamily: 'Amiri',
                                              color: context
                                                      .watch<ColorMode>()
                                                      .isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  )),
                            ),
                          ),
                          itemCount: snapshot.data!.length,
                        );
                      } else {
                        return const Text('لا يوجد');
                      }
                    } else {
                      return const Text('لايوجد نتائج}');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  deleteReadMark(NewVerse verse) {
    verse.delete();
    setState(() {});
  }

  Future<List<NewVerse>> getVersesResult() async {
    List<NewVerse> verses = [];
    if (searchWord.isEmpty) {
      List<NewVerse> newVerseList =
          Hive.box<NewVerse>(kNewVerseBoxName).values.toList();

      return verses = newVerseList;
    } else {
      List versesJson = await Quran.searchQuran(searchWord);
      for (var verse in versesJson) {
        int juzInt =
            Quran.getJuzNumber(verse['surah_number'], verse['verse_number']);

        if (juzInt != -1) {
          verses.add(
            NewVerse(
                surahNumber: verse['surah_number'],
                content: verse['content'],
                part: 'الجزء $juzInt',
                surah: Quran.getSuranArabicName(verse['surah_number']),
                juzNumber: juzInt,
                verseNumber: verse['verse_number']),
          );
        }
      }
    }

    return verses;
  }
}
