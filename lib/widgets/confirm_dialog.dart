import 'package:flutter/material.dart';

import '../constants.dart';
import '../routes/navigation_services.dart';
import 'custom_button.dart';
import 'main_title_text.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onConfirm;
  final Function()? onCancel;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 240,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainTitleText(title: title),
            const SizedBox(
              height: 20,
            ),
            Text(
              content,
              style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  width: 100,
                  height: 48,
                  title: ConstantStrings.appString.confirm,
                  onTap: () {
                    NavigationService().pop();
                    onConfirm.call();
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                CustomButton(
                  isConfirm: false,
                  width: 100,
                  height: 48,
                  title: ConstantStrings.appString.cancel,
                  onTap: () {
                    onCancel?.call();
                    NavigationService().pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Function() onConfirm,
  Function()? onCancel,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ConfirmDialog(
            title: title, content: content, onConfirm: onConfirm, onCancel: onCancel,);
      });
}
