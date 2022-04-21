import 'package:albaqer/controllers/color_mode.dart';
import 'package:albaqer/controllers/marriage_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchContainer extends StatefulWidget {
  final Function switchLoading;
  const SearchContainer({Key? key, required this.switchLoading})
      : super(key: key);

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  String searchType = 'name';
  String hintText = 'البحث';

  TextInputType textInputType = TextInputType.text;
  @override
  void initState() {
    // debouncer.values.listen((search) =>
    //     context.read<MarriageController>().submitSearch(searchType, search));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: context.watch<ColorMode>().isDarkMode
            ? const Color(0xff111C2E)
            : Colors.grey.shade50,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 30,
            color: Color(0xff538CB2),
          ),
          SizedBox(
            width: 3.w,
          ),
          Expanded(
            child: TextField(
              autocorrect: false,
              showCursor: false,
              onTap: () {},
              onSubmitted: (value) {
                widget.switchLoading();
                context
                    .read<MarriageController>()
                    .submitSearch(searchType, value)
                    .then((value) {
                  widget.switchLoading();
                });
              },
              style: TextStyle(
                  color: context.watch<ColorMode>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w500),
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              keyboardType: textInputType,
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 2,
                hintStyle: TextStyle(
                    color: context.watch<ColorMode>().textInputHintColor,
                    fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          IconButton(
            onPressed: searchFilter,
            icon: const Icon(
              Icons.filter_list,
              size: 30,
              color: Color(0xff538CB2),
            ),
          )
        ],
      ),
    );
  }

  void searchFilter() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Wrap(children: [
              buildListTile(name: 'الإسم', type: 'name'),
              const Divider(),
              buildListTile(name: 'العمر', type: 'age'),
              const Divider(),
              buildListTile(name: 'الجنسية', type: 'nationality'),
              const Divider(),
              buildListTile(name: 'بلد الإقامة', type: 'country')
            ]),
          );
        });
  }

  Widget buildListTile({required String type, required String name}) {
    TextStyle textStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return ListTile(
      onTap: () {
        setState(() {
          if (type == 'age') {
            textInputType = TextInputType.number;
          }
          searchType = type;
          hintText = 'حسب $name';

          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.location_city,
        color: Color(0xff538CB2),
      ),
      title: Text(
        name,
        style: textStyle,
      ),
    );
  }
}
