import 'package:flutter/material.dart';

import '../constants.dart';

class MainTitleText extends StatelessWidget {
  final String title;
  const MainTitleText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColors.whiteColor,
      ),
    );
  }
}
