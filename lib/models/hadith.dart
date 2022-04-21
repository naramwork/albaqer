import 'package:hive/hive.dart';

part 'hadith.g.dart';

@HiveType(typeId: 5)
class Hadith extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final int order;

  @HiveField(2)
  final String updatedAt;
  @HiveField(3)
  final int id;
  Hadith({
    required this.content,
    required this.order,
    required this.updatedAt,
    required this.id,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) => Hadith(
      content: json['content'],
      id: json['id'],
      order: json['order'],
      updatedAt: json['updated_at'] ?? '');
}
