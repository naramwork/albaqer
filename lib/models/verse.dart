import 'package:hive/hive.dart';

part 'verse.g.dart';

@HiveType(typeId: 2)
class Verse extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String part;

  @HiveField(3)
  final String surah;

  // well become verses number
  @HiveField(4)
  final String range;

  @HiveField(5)
  final int order;
  @HiveField(6)
  final String createdAt;
  @HiveField(7)
  final String updatedAt;
  Verse({
    required this.id,
    required this.content,
    required this.part,
    required this.surah,
    required this.range,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
      id: json['id'],
      content: json['content'],
      part: json['part'] ?? '',
      surah: json['surah'] ?? '',
      range: json['range'] ?? '',
      order: json['order'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '');
}
