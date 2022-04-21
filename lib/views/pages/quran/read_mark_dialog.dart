import 'package:albaqer/app/helper_files/app_const.dart';
import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/app/themes/color_const.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/full_quran/quran.dart';
import 'package:albaqer/models/new_verse.dart';
import 'package:albaqer/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'copy_button.dart';

class ReadMarkDialog extends StatefulWidget {
  final Surah surah;
  const ReadMarkDialog({Key? key, required this.surah}) : super(key: key);

  @override
  State<ReadMarkDialog> createState() => _ReadMarkDialogState();
}

class _ReadMarkDialogState extends State<ReadMarkDialog> {
  String content = '';
  int versNumber = 0;
  final myController = TextEditingController();
  List<int> versesRange = [];
  String rangeText = '';

  @override
  void initState() {
    versesRange =
        Quran.getVersesCount(widget.surah.juzNumber, widget.surah.number);
    if (versesRange.isNotEmpty) {
      myController.text = versesRange.first.toString();
      versNumber = versesRange.first;
    }

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
                'العلامة المرجعية',
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
                              onChanged: (value) {
                                versNumber = int.parse(value);
                                content = getNextVerse();
                                setState(() {});
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
                                hintText: 'اختر رقم الآية',
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
                height: 0.5.w,
              ),
              Container(
                padding: EdgeInsets.only(right: 5.w),
                alignment: Alignment.centerRight,
                child: Text(
                  '* اختر رقم الآية بين ${versesRange.first} - ${versesRange.last}',
                  style: TextStyle(
                    color: context.watch<ColorMode>().isDarkMode
                        ? Colors.white
                        : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.w,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
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
              CopyButton(
                title: 'إضافة علامة مرجعية',
                onPress: () {
                  saveMark();
                },
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
    content += ' ' +
        Quran.getVerse(widget.surah.number, versNumber, verseEndSymbol: true);
    return content;
  }

  String getNextVerse() {
    if (versNumber == 0) {
      versNumber = versesRange.first;
    } else if (versNumber > versesRange.last) {
      return '';
    }

    content = Quran.getVerse(widget.surah.number, versNumber);
    return content;
  }

  void saveMark() async {
    versNumber = int.parse(myController.text);

    NewVerse markedVers = NewVerse(
      surahNumber: widget.surah.number,
      juzNumber: widget.surah.juzNumber,
      verseNumber: versNumber,
      content: getNextVerse(),
      part: 'الجزء ${widget.surah.juzNumber}',
      surah: Quran.getSuranArabicName(widget.surah.number),
    );

    var box = Hive.box<NewVerse>(kNewVerseBoxName);
    await box.add(markedVers);

    Navigator.pop(context);
    showSnackBar('تمت اضافة علامة مرجعية', context);
  }
}
