import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  const EmptyWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/empty.png'),
        Text(
          title,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
