import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/full_quran/quran.dart';
import 'package:albaqer/models/surah.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/pages/quran/read_mark_dialog.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'copy_dialog.dart';

class SurahContainer extends StatefulWidget {
  final Surah surah;
  final double fontSize;
  final String searchVerse;

  const SurahContainer({
    Key? key,
    required this.surah,
    required this.searchVerse,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<SurahContainer> createState() => _SurahContainerState();
}

class _SurahContainerState extends State<SurahContainer> {
  late Map<String, HighlightedWord> words = {};
  var _keys = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_keys.isNotEmpty) {
        if (_keys[0].currentContext != null) {
          Scrollable.ensureVisible(
            _keys[0].currentContext!,
            alignment: 0.2,
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    words = getWords(context);
    _keys = List<GlobalKey>.generate(
      words.length,
      (_) => GlobalKey(),
    );

    super.didChangeDependencies();
  }

  TextStyle textStyle(BuildContext context) {
    return TextStyle(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize,
        height: 2,
        fontFamily: 'Amiri');
  }

  TextStyle qurantextStyle(BuildContext context) {
    return TextStyle(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize,
        height: 2,
        fontFamily: 'UthmanicHafs');
  }

  TextStyle underlinedTextStyle(BuildContext context, bool withHilght) {
    if (withHilght) {
      return TextStyle(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize - 2,
        fontFamily: 'UthmanicHafs',
        background: Paint()
          ..color = Colors.yellowAccent.shade200
          ..style = PaintingStyle.fill,
      );
    }
    return TextStyle(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize - 2,
        fontFamily: 'UthmanicHafs',
        decoration: TextDecoration.overline);
  }

  Map<String, HighlightedWord> getWords(BuildContext context) {
    if (widget.searchVerse.isEmpty) {
      return {};
    }
    String newSearchVerse = widget.searchVerse
        .replaceAll('\u0644\u0652\u0622', '\u0644\u06E1\u0623\u0653')
        .replaceAll('\u0644\u0650\u0622', '\u0644\u0650\u0623\u0653')
        .replaceAll('\u0644\u064E\u0622', '\u0644\u064E\u0623\u0653');
    words[newSearchVerse] = HighlightedWord(
      onTap: () {
        showMapsBottomSheet(context, widget.surah);
      },
      textStyle: TextStyle(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
        fontSize: widget.fontSize,
        height: 2,
        fontFamily: 'UthmanicHafs',
        background: Paint()
          ..color = Colors.yellowAccent.shade200
          ..style = PaintingStyle.fill,
      ),
    );
    if (widget.surah.number == 96 && widget.surah.juzNumber == 30) {
      fixHighlight(context, 'وَٱسْجُدْ', newSearchVerse);
    } else if (widget.surah.number == 22 && widget.surah.juzNumber == 17) {
      fixHighlight(context, 'وَٱسْجُدُواْ', newSearchVerse);
    } else if (widget.surah.number == 25 && widget.surah.juzNumber == 19) {
      fixHighlight(context, 'ٱسْجُدُواْ', newSearchVerse);
    } else if (widget.surah.number == 41 && widget.surah.juzNumber == 24) {
      fixHighlight(context, 'وَٱسْجُدُواْ لِلَّهِ', newSearchVerse);
    } else if (widget.surah.number == 53 && widget.surah.juzNumber == 27) {
      fixHighlight(context, 'فَٱسۡجُدُواْ لِلَّهِ', newSearchVerse);
    }

    return words;
  }

  fixHighlight(BuildContext context, String text, String newSearchVerse) {
    if (newSearchVerse.contains(text)) {
      words[newSearchVerse] = HighlightedWord(
        onTap: () {
          showMapsBottomSheet(context, widget.surah);
        },
        textStyle: underlinedTextStyle(context, true),
      );
    } else {
      words[text] = HighlightedWord(
        onTap: () {
          showMapsBottomSheet(context, widget.surah);
        },
        textStyle: underlinedTextStyle(context, false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '﴿ سورة ${widget.surah.name} ﴾',
                  style: textStyle(context),
                ),
                Text(
                  '﴿ الجزء ${widget.surah.juzNumber}﴾',
                  style: textStyle(context),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(25.w, 1.h, 25.w, 0.4.h),
              child: Text(
                'سورة ${widget.surah.name}',
                style: textStyle(context),
                textAlign: TextAlign.center,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/surah_decoration.png'),
                    fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Column(
              children: [
                Divider(
                  indent: 4.w,
                  endIndent: 4.w,
                  color: Colors.blue.shade200,
                  height: 4,
                  thickness: 0.8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/quran_side_icon.png',
                      height: 26,
                      width: 26,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        Quran.getBasmala(),
                        style: textStyle(context),
                      ),
                    ),
                    Image.asset(
                      'assets/images/quran_side_icon.png',
                      height: 26,
                      width: 26,
                    ),
                  ],
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      VerticalDivider(
                        thickness: 0.8,
                        color: Colors.blue.shade200,
                        endIndent: 4,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                            onTap: () {
                              showMapsBottomSheet(context, widget.surah);
                            },
                            child: TextHighlight(
                              text: widget.surah.content,
                              words: words,
                              textScaleFactor: 1.4,
                              binding: HighlightBinding.first,
                              textAlign: TextAlign.right,
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: context.watch<ColorMode>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: widget.fontSize + 2,
                                  height: 2,
                                  fontFamily: 'UthmanicHafs'),
                              keys: _keys,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 0.8,
                        color: Colors.blue.shade200,
                        endIndent: 4,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/quran_side_icon.png',
                      height: 26,
                      width: 26,
                    ),
                    Image.asset(
                      'assets/images/quran_side_icon.png',
                      height: 26,
                      width: 26,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Divider(
                    indent: 4.w,
                    endIndent: 4.w,
                    color: Colors.blue.shade200,
                    thickness: 0.8,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

showMapsBottomSheet(BuildContext context, Surah surah) async {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 30.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedButtonWidget(
                label: const Text(
                  'نسخ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                width: 50.w,
                onpressed: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => CopyDialog(surah: surah));
                },
              ),
              RoundedButtonWidget(
                label: const Text(
                  'إضافة علامة مرجعية',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                width: 50.w,
                onpressed: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => ReadMarkDialog(surah: surah));
                },
              ),
            ],
          ),
        );
      });
}
