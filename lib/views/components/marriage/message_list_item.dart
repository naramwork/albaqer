import 'package:albaqer/models/message.dart';
import 'package:albaqer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageListItem extends StatelessWidget {
  final Message message;
  final User? user;
  const MessageListItem({Key? key, required this.message, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        intl.DateFormat('yyyy-MM-dd').format(message.createdAt);
    String status =
        message.sender.id == user?.id ? message.status : message.sender.name;
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Align(
        alignment: message.sender.id == user?.id
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: message.sender.id != user?.id
                ? const BorderRadius.only(
                    topRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
          ),
          child: Container(
              width: 70.w,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: message.sender.id != user?.id
                    ? const Color(0xff82B1FF)
                    : const Color(0xff80D8FF),
                borderRadius: message.sender.id != user?.id
                    ? const BorderRadius.only(
                        topRight: Radius.circular(30),
                      )
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                      ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: message.sender.id != user?.id
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  IntrinsicHeight(
                      child: Row(
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.white54,
                      ),
                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
