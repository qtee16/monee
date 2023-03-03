import 'package:flutter/material.dart';
import 'package:spending_app/constants.dart';

class ProfileTabHeader extends StatelessWidget {
  const ProfileTabHeader({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        ConstantStrings.appString.personal,
        style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            height: 32.0 / 24.0),
      ),
      subtitle: Text(
        ConstantStrings.appString.editYourProfile,
        style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            height: 19.0 / 14.0),
      ),
    );
  }
}
