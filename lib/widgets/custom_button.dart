import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final Function() onTap;
  final bool isConfirm;
  const CustomButton({Key? key, this.isConfirm = true, required this.width, required this.height, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // stops: [0.0, 1.0],
          colors: isConfirm ? [
            AppColors.greenStartLinearColor,
            AppColors.greenEndLinearColor,
          ] : [
            AppColors.redStartLinearColor,
            AppColors.redEndLinearColor,
          ],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),),
        ),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
