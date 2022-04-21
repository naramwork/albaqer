import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/marriage_controller.dart';
import 'package:albaqer/models/message.dart';
import 'package:albaqer/views/components/marriage/marriage_request_dialog.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:albaqer/views/pages/marriage/marriage_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MarriageRequestList extends StatefulWidget {
  const MarriageRequestList({Key? key}) : super(key: key);

  @override
  State<MarriageRequestList> createState() => _MarriageRequestListState();
}

class _MarriageRequestListState extends State<MarriageRequestList> {
  Map<String, List<Message>> showedMarriageRequest = {};
  bool isRecived = true;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    showedMarriageRequest =
        context.read<MarriageController>().recivedMarriageReques;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return !context.watch<MarriageController>().getReuslt
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedButtonWidget(
                  label: isRecived
                      ? const Text('عرض الطلبات المرسلة')
                      : const Text('عرض الطلبات المستلمة'),
                  width: 40.w,
                  onpressed: () {
                    switchList();
                  }),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: showedMarriageRequest.isEmpty
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
                        itemBuilder: (context, i) {
                          List<Message> messages =
                              showedMarriageRequest.values.elementAt(i);

                          return Column(
                              children: messages.map((message) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: InkWell(
                                onTap: () {
                                  if (isRecived) {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            MarriageRequestDialog(
                                                message: message,
                                                onTap: onTap));
                                  }
                                },
                                child: Card(
                                    elevation: 2,
                                    color: const Color(0xff1e5180),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 2.h),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade50,
                                            backgroundImage: NetworkImage(
                                                isRecived
                                                    ? message.sender.imageUrl
                                                    : message
                                                        .recipient.imageUrl),
                                            maxRadius: 8.w,
                                          ),
                                          SizedBox(width: 5.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isRecived
                                                    ? message.sender.name
                                                    : message.recipient.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              Text(
                                                message.status,
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
                          }).toList());
                        },
                        itemCount: showedMarriageRequest.keys.length,
                      ),
              ),
            ],
          );
  }

  void switchList() {
    isRecived = !isRecived;

    if (isRecived) {
      showedMarriageRequest =
          context.read<MarriageController>().recivedMarriageReques;
    } else {
      showedMarriageRequest =
          context.read<MarriageController>().sendedMarriageReques;
    }

    setState(() {});
  }

  void onTap(Message message, String status) {
    context
        .read<MarriageController>()
        .responseToMarriageRequest(message.id, status)
        .then((value) {
      if (value == "1") {
        showSnackBar('تم ', context);
        Navigator.pushReplacementNamed(context, MarriagePage.routeName);
      } else {
        showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا', context);
        Navigator.pop(context);
      }
    });
  }
}
