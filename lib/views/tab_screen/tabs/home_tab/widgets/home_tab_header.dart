import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class HomeTabHeader extends StatelessWidget {
  final String title;
  const HomeTabHeader({Key? key, required this.title,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
    );
  }
}
