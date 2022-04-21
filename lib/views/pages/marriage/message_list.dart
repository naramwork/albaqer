import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/marriage_controller.dart';
import 'package:albaqer/controllers/user_controller.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/models/message.dart';

import 'package:albaqer/views/pages/marriage/messages_with_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  User? user;
  Map<String, List<Message>> messages = {};
  @override
  void didChangeDependencies() {
    user = context.watch<UserController>().user;
    messages = context.watch<MarriageController>().allMessages;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return !context.watch<MarriageController>().getReuslt
        ? const Center(child: CircularProgressIndicator())
        : Container(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'لايوجد',
                      style: TextStyle(
                          color: context.watch<ColorMode>().isDarkMode
                              ? Colors.white
                              : Colors.black),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, i) {
                      Message message = messages.values.elementAt(i).first;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesWithUserPage(
                                        id: messages.entries.elementAt(i).key,
                                        user: user,
                                      )),
                            );
                          },
                          child: Card(
                              elevation: 2,
                              color: const Color(0xff1e5180),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey.shade50,
                                      backgroundImage:
                                          NetworkImage(getImage(message)),
                                      maxRadius: 8.w,
                                    ),
                                    SizedBox(width: 5.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTitle(message),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          message.content.length > 20
                                              ? '${message.content.substring(0, 20)}...'
                                              : message.content,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                    itemCount: messages.keys.length,
                  ),
          );
  }

  String getTitle(Message message) {
    if (message.sender.id == user?.id) {
      return message.recipient.name;
    } else {
      return message.sender.name;
    }
  }

  //todo
  String getImage(Message message) {
    if (message.sender.id == user?.id) {
      return message.recipient.imageUrl;
    } else {
      return message.sender.imageUrl;
    }
  }
}
