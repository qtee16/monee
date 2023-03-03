import 'package:flutter/material.dart';

import '../constants.dart';

class GeneralHeader extends StatelessWidget {
  final String title;
  final Function() onTap;
  const GeneralHeader({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: InkWell(
        onTap: onTap,
        child: const Icon(Icons.arrow_back_outlined, color: AppColors.whiteColor,),
      ),
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
