import 'package:hive/hive.dart';

part 'update_content.g.dart';

@HiveType(typeId: 3)
class UpdateContent extends HiveObject {
  @HiveField(0)
  final int startAt;

  @HiveField(1)
  final String type;

  @HiveField(2)
  String lastUpdate;

  UpdateContent({
    required this.startAt,
    required this.type,
    required this.lastUpdate,
  });

  factory UpdateContent.fromJson(Map<String, dynamic> json, String date) =>
      UpdateContent(
          startAt: json['start'], type: json['name'], lastUpdate: date);
}
