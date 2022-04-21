import 'dart:io';

import 'package:albaqer/app/helper_files/snack_bar.dart';
import 'package:albaqer/controllers/edit_user_controller.dart';
import 'package:albaqer/models/user.dart';
import 'package:albaqer/views/components/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChangeImage extends StatefulWidget {
  final User? user;
  const ChangeImage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangeImage> createState() => _ChangeImageState();
}

class _ChangeImageState extends State<ChangeImage> {
  File? _image;
  bool isLoading = false;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Card(
              elevation: 2.0,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: _image == null
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(widget.user!.imageUrl),
                      maxRadius: 20.w,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(_image!),
                      maxRadius: 20.w,
                    ),
            ),
            SizedBox(
              height: 5.w,
            ),
            Column(
              children: [
                RoundedButtonWidget(
                  onpressed: getImage,
                  label: const Text('اختيار الصورة'),
                  width: 40.w,
                ),
                _image != null
                    ? RoundedButtonWidget(
                        onpressed: () {
                          uploadImage(_image!.path);
                        },
                        label: const Text('موافق'),
                        width: 40.w,
                      )
                    : Container()
              ],
            ),
          ],
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(),
      ],
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  void uploadImage(String path) async {
    isLoading = true;
    setState(() {});
    bool response = await context.read<EditUserController>().addImage(path);
    if (response) {
      showSnackBar('تم تعديل الصورة بنجاح', context);
    } else {
      showSnackBar('حدث خطأ ما الرجاء المحاولة لاحقا', context);
    }

    isLoading = false;
    setState(() {});
  }
}
