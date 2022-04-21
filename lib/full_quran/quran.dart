import 'dart:convert';

import 'src/quran_text_without_tashkel.dart';
import 'src/surah_list.dart';
import 'src/helper_list.dart';
import 'src/translate.dart';

class Quran {
  static List getFullQuran() {
    return surahs;
  }

  static Future<List> searchQuran(String search) {
    String normaliseSearch = normalisePackage(search);
    List foundedVerses = [];

    foundedVerses = quranTextWithoutTashkel.where((verse) {
      if (verse['search_content'].contains(normaliseSearch)) {
        return true;
      } else if (verse['search_content_with'].contains(normaliseSearch)) {
        return true;
      } else {
        return false;
      }
    }).toList();

    return Future.value(foundedVerses);
  }

  static List getQuran(List<int> nums) {
    List selectedSurah = [];
    for (var surahNumber in nums) {
      for (var surah in surahs) {
        if (surah['surah_number'] == surahNumber) {
          selectedSurah.add(surah);
        }
      }
    }

    return selectedSurah;
  }

  static List onSurahSelect(int num1) {
    List selectedSurah = [];
    for (var surah in surahs) {
      if (surah['surah_number'] == num1) {
        selectedSurah.add(surah);
      }
    }
    return selectedSurah;
  }

  //Get Surah Name in arabic
  static String getSuranArabicName(int num) {
    final jsonExtractedList = json.decode(surahList);
    final List<dynamic> suarhListData =
        jsonExtractedList['surat'] as List<dynamic>;
    Map surahMap = suarhListData
        .firstWhere((element) => element['surah'] == num.toString());
    if (surahMap.isNotEmpty) {
      return surahMap['name'];
    }

    return '';
  }

  ///Returns 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'
  static String getBasmala() {
    return "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";
  }

  static Map<int, List<int>> getSurahAndVersesFromJuz(int juzNumber) {
    return juz[juzNumber - 1]["verses"];
  }

  static String getVerse(int surahNumber, int verseNumber,
      {bool verseEndSymbol = false}) {
    String verse = "";
    for (var i in quranTextWithoutTashkel) {
      if (i['surah_number'] == surahNumber &&
          i['verse_number'] == verseNumber) {
        verse = i['content'].toString();
        break;
      }
    }

    if (verse == "") {
      throw "No verse found with given surahNumber and verseNumber.\n\n";
    }

    return verse + (verseEndSymbol ? getVerseEndSymbol(verseNumber) : "");
  }

  ///Reurns total juz count
  static int getTotalJuzCount() {
    return 30;
  }

  static List<int> getSurahFromJuz(int juzNumber) {
    return juz[juzNumber - 1]["surahs"];
  }

  ///Takes [surahNumber] & [verseNumber] and returns Juz number
  static int getJuzNumber(int surahNumber, int verseNumber) {
    for (var juz in juz) {
      if (juz["verses"].keys.contains(surahNumber)) {
        if (verseNumber >= juz["verses"][surahNumber][0] &&
            verseNumber <= juz["verses"][surahNumber][1]) {
          return int.parse(juz["id"].toString());
        }
      }
    }
    return -1;
  }

  static List<int> getVersesCount(int juzNumber, int surahNumber) {
    if (juzNumber > 30) {
      return [];
    }
    for (var juzItem in juz) {
      if (juzItem['id'] == juzNumber) {
        List<int> versesRange = juzItem['verses'][surahNumber];
        if (versesRange.isNotEmpty) {
          return versesRange;
        }
      }
    }
    return [];
  }

  ///Takes [verseNumber] and returns '۝' symbol with verse number
  static String getVerseEndSymbol(int verseNumber) {
    String arabicNumeric = " ﴿";

    for (int i = 0; i < verseNumber.toString().length; i++) {
      String digit = verseNumber.toString().split("")[i];
      if (digit == "0") {
        arabicNumeric += "٠";
      } else if (digit == "1") {
        arabicNumeric += "١";
      } else if (digit == "2") {
        arabicNumeric += "٢";
      } else if (digit == "3") {
        arabicNumeric += "٣";
      } else if (digit == "4") {
        arabicNumeric += "٤";
      } else if (digit == "5") {
        arabicNumeric += "٥";
      } else if (digit == "6") {
        arabicNumeric += "٦";
      } else if (digit == "7") {
        arabicNumeric += "٧";
      } else if (digit == "8") {
        arabicNumeric += "٨";
      } else if (digit == "9") {
        arabicNumeric += "٩";
      }
    }

    arabicNumeric += "﴾";

    return arabicNumeric;
  }

  ///Takes [verseNumber] and returns '۝' symbol with verse number
  static String getArabicNumber(int verseNumber) {
    String arabicNumeric = "";

    for (int i = verseNumber.toString().length - 1; i >= 0; i--) {
      String digit = verseNumber.toString().split("")[i];
      if (digit == "0") {
        arabicNumeric += "٠";
      } else if (digit == "1") {
        arabicNumeric += "١";
      } else if (digit == "2") {
        arabicNumeric += "٢";
      } else if (digit == "3") {
        arabicNumeric += "٣";
      } else if (digit == "4") {
        arabicNumeric += "٤";
      } else if (digit == "5") {
        arabicNumeric += "٥";
      } else if (digit == "6") {
        arabicNumeric += "٦";
      } else if (digit == "7") {
        arabicNumeric += "٧";
      } else if (digit == "8") {
        arabicNumeric += "٨";
      } else if (digit == "9") {
        arabicNumeric += "٩";
      }
    }

    return arabicNumeric;
  }
}
