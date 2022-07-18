import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/color_mode.dart';

class MarriageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String title;
  const MarriageAppBar({Key? key, required this.appBar, this.title = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
            color: context.watch<ColorMode>().isDarkMode
                ? Colors.white
                : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color:
            context.watch<ColorMode>().isDarkMode ? Colors.white : Colors.black,
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

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
