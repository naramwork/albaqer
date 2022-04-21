import 'package:hive/hive.dart';

part 'new_verse.g.dart';

@HiveType(typeId: 8)
class NewVerse extends HiveObject {
  // surah number
  @HiveField(0)
  final int surahNumber;

  @HiveField(4)
  final int verseNumber;

  @HiveField(5)
  final int juzNumber;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String part;

  @HiveField(3)
  final String surah;

  NewVerse({
    required this.surahNumber,
    required this.verseNumber,
    required this.juzNumber,
    required this.content,
    required this.part,
    required this.surah,
  });
}
