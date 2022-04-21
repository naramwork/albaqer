import 'package:albaqer/app/helper_files/custom_icons_icons.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_icon.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final Function selectPage;
  const CustomBottomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.selectPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: const CircularNotchedRectangle(), //shape of notch
      notchMargin: 10, //notche margin between floating button and bottom appbar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavIcon(
              icon: Icons.home,
              active: selectedIndex == 0,
              index: 0,
              selectPage: selectPage,
            ),
            BottomNavIcon(
              icon: CustomIcons.quran,
              active: selectedIndex == 1,
              index: 1,
              selectPage: selectPage,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
            ),
            BottomNavIcon(
              icon: CustomIcons.quran_2,
              active: selectedIndex == 2,
              index: 2,
              selectPage: selectPage,
            ),
            BottomNavIcon(
              icon: CustomIcons.prayer,
              active: selectedIndex == 3,
              index: 3,
              selectPage: selectPage,
            ),
          ],
        ),
      ),
    );
  }
}
