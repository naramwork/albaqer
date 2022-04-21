import 'package:hive/hive.dart';

part 'dua.g.dart';

@HiveType(typeId: 4)
class Dua extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final int order;

  @HiveField(2)
  final String updatedAt;
  @HiveField(3)
  final int id;

  Dua({
    required this.content,
    required this.order,
    required this.updatedAt,
    required this.id,
  });

  factory Dua.fromJson(Map<String, dynamic> json) => Dua(
      content: json['content'],
      order: json['order'],
      updatedAt: json['updated_at'] ?? '',
      id: json['id']);
}
