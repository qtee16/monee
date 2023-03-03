import 'package:flutter/material.dart';
import 'package:spending_app/widgets/cached_image_widget.dart';
import 'package:spending_app/widgets/member_avatar.dart';

import '../constants.dart';

class CardItem extends StatelessWidget {
  final String? imageURL;
  final String title;
  final String? subTitle;
  final Widget? trailing;
  final bool isUserAvatar;
  final bool isShowCrown;

  const CardItem({
    Key? key,
    required this.imageURL,
    required this.title,
    this.subTitle,
    this.trailing,
    this.isUserAvatar = false,
    this.isShowCrown = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [AppColors.navBarStartColor, AppColors.navBarEndColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              isUserAvatar
                  ? MemberAvatar(
                      imageURL: imageURL,
                      width: 48,
                      height: 48,
                      border: 4,
                    )
                  : CachedImageWidget(
                      imageURL: imageURL!,
                      width: 48,
                      height: 48,
                      border: 4,
                    ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 4,),
                      isShowCrown ? Image.asset(AssetPaths.iconPath.getCrownIconPath, width: 20,) : const SizedBox(),
                    ],
                  ),
                  subTitle != null
                      ? Text(
                          subTitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.subTitleColor,
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
          trailing != null ? trailing! : const SizedBox(),
        ],
      ),
    );
  }
}
