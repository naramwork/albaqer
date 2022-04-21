import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/marriage_controller.dart';

import 'package:albaqer/models/message.dart';
import 'package:albaqer/models/user.dart';

import 'package:albaqer/views/components/marriage/message_list_item.dart';
import 'package:albaqer/views/pages/marriage/partner_info_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class MessagesWithUserPage extends StatefulWidget {
  static String routeName = '/messages_with_user_page';
  final String id;
  final User? user;

  const MessagesWithUserPage({Key? key, required this.id, this.user})
      : super(key: key);

  @override
  State<MessagesWithUserPage> createState() => _MessagesWithUserPageState();
}

class _MessagesWithUserPageState extends State<MessagesWithUserPage> {
  List<Message> messages = [];
  String title = '';
  User? recipientUser;
  final _controller = ScrollController();

  String getTitle() {
    Message message = messages.first;
    return message.sender.id == widget.user?.id
        ? message.recipient.name
        : message.sender.name;
  }

  User getUser() {
    Message message = messages.first;
    return message.sender.id == widget.user?.id
        ? message.recipient
        : message.sender;
  }

  @override
  void initState() {
    initPage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemBuilder: (context, i) {
                      Message message = messages[i];
                      return MessageListItem(
                        message: message,
                        user: widget.user,
                      );
                    },
                    itemCount: messages.length,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                )
              ],
            ),
          ),
          SendMessageField(
            sendMessage: (String content) {
              sendeMessage(context, content);
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 15.w),
        child: FloatingActionButton(
          child: const Icon(Icons.arrow_downward_rounded),
          onPressed: () {
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          },
        ),
      ),
    );
  }

  void sendeMessage(BuildContext context, String content) async {
    if (widget.user != null) {
      context
          .read<MarriageController>()
          .sendMessage(
              senderID: widget.user!.id,
              recipientId: recipientUser!.id,
              content: content)
          .then((value) {
        if (value != null) {
          messages.add(value);
          setState(() {});
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    }
  }

  Future getMessages() async {
    messages.clear();
    messages = await context
        .read<MarriageController>()
        .getMessageByID(id: widget.id, currentUserID: widget.user?.id ?? 0);

    return;
  }

  void initPage() async {
    await getMessages();

    title = getTitle();
    recipientUser = getUser();
    setState(() {});
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text(
          title,
          style: TextStyle(
              color: context.watch<ColorMode>().isDarkMode
                  ? Colors.white
                  : Colors.black,
              fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextButton.icon(
                icon: Icon(
                  Icons.info_outline,
                  color: context.watch<ColorMode>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(PartnerInfoPage.routeName,
                      arguments: recipientUser);
                },
                label: Text(
                  'المزيد',
                  style: TextStyle(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 12),
                )),
          )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
          color: context.watch<ColorMode>().isDarkMode
              ? Colors.white
              : Colors.black,
          //change your color here
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      );
}

class SendMessageField extends StatelessWidget {
  final Function sendMessage;
  final myController = TextEditingController();
  SendMessageField({Key? key, required this.sendMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: context.watch<ColorMode>().isDarkMode
                  ? const Color(0xFF184B6C)
                  : Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: myController,
                  autocorrect: false,
                  showCursor: false,
                  onSubmitted: (value) {
                    sendMessage(value);
                  },
                  style: TextStyle(
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500),
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالة',
                    hintMaxLines: 2,
                    hintStyle: TextStyle(
                        color: context.watch<ColorMode>().textInputHintColor,
                        fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                    splashRadius: 6.w,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (myController.text.isNotEmpty) {
                        sendMessage(myController.text);
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: context.watch<ColorMode>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
