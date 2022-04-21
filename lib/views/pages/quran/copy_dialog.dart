import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/full_quran/quran.dart';
import 'package:albaqer/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'copy_button.dart';

class CopyDialog extends StatefulWidget {
  final Surah surah;
  const CopyDialog({Key? key, required this.surah}) : super(key: key);

  @override
  State<CopyDialog> createState() => _CopyDialogState();
}

class _CopyDialogState extends State<CopyDialog> {
  String content = '';
  int versNumber = 0;
  final myController = TextEditingController(text: '1');

  @override
  void initState() {
    content += getFirstVerse();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.w),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.watch<ColorMode>().isDarkMode
              ? ColorConst.darkCardColor
              : Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'النسخ',
                style: TextStyle(
                  color: context.watch<ColorMode>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search,
                            size: 30,
                            color: Color(0xff538CB2),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: TextField(
                              onTap: () {
                                myController.clear();
                              },
                              controller: myController,
                              autocorrect: false,
                              showCursor: false,
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                versNumber = int.parse(value);
                                content = getNextVerse();
                                setState(() {});
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: 'البدء من الآية رقم',
                                hintMaxLines: 2,
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      versNumber = int.parse(myController.text);
                      content = getNextVerse();
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                    child: Text(
                      'موافق',
                      style: TextStyle(
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 45.h,
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: TextStyle(
                        color: context.watch<ColorMode>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 2,
                        fontFamily: 'Amiri'),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Divider(
                indent: 4.w,
                endIndent: 4.w,
                color: Colors.blue.shade200,
                thickness: 0.8,
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CopyButton(
                    title: '+ الآية التالية',
                    onPress: () {
                      versNumber++;
                      content += getNextVerse();
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  CopyButton(
                    title: 'النسخ',
                    onPress: () {
                      Clipboard.setData(ClipboardData(
                              text: content.replaceAll(
                                  '\u0621\u064E\u0627', '\u0622')))
                          .then((value) {
                        Navigator.pop(context);
                        showSnackBar('تم النسخ', context);
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CopyButton(
                    onPress: () {
                      versNumber == 0;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: 'إغلاق'),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getFirstVerse() {
    Map<int, List<int>> suarhMap =
        Quran.getSurahAndVersesFromJuz(widget.surah.juzNumber);
    String content = '';
    for (var element in suarhMap.entries) {
      if (element.key == widget.surah.number) {
        List<int> versesNumbers = element.value;
        versNumber = versesNumbers.first;

        content += ' ' +
            Quran.getVerse(widget.surah.number, versNumber,
                verseEndSymbol: true);
      }
    }
    return content.replaceAll('\u0621\u064E\u0627', '\u0622');
  }

  String getNextVerse() {
    Map<int, List<int>> suarhMap =
        Quran.getSurahAndVersesFromJuz(widget.surah.juzNumber);
    String content = '';

    for (var element in suarhMap.entries) {
      if (element.key == widget.surah.number) {
        List<int> versesNumbers = element.value;
        if (versNumber == 0) {
          versNumber = versesNumbers.first;
        } else if (versNumber > versesNumbers.last) {
          return '';
        }

        content += ' ' +
            Quran.getVerse(widget.surah.number, versNumber,
                verseEndSymbol: true);
      }
    }
    return content.replaceAll('\u0621\u064E\u0627', '\u0622');
  }
}
