import 'package:flutter/material.dart';

import '../../../constants.dart';


class VerifyEmailHeader extends StatelessWidget {
  const VerifyEmailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        ConstantStrings.appString.verifyEmail,
        style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
    );
  }
}
