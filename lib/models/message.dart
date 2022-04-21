import 'package:albaqer/models/user.dart';

//we can use this model fro messages and marriage request
// status fro messages : تمت الموافقة , مرفوض
// status for Marriage requests : في الإنتظار , قبول , رفض
// todo: change this to enum
class Message {
  final int id;
  final User sender;
  final User recipient;
  final String content;
  final DateTime createdAt;
  final String status;

  Message(
      {required this.id,
      required this.sender,
      required this.recipient,
      required this.content,
      required this.createdAt,
      required this.status});
}
