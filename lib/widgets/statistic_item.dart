import 'package:flutter/material.dart';
import 'package:spending_app/widgets/cached_image_widget.dart';
import 'package:spending_app/widgets/member_avatar.dart';

import '../constants.dart';
import '../utils/utils.dart';

class StatisticItem extends StatelessWidget {
  final String? imageURL;
  final String name;
  final int spent;
  final int debt;

  const StatisticItem({
    Key? key,
    required this.imageURL,
    required this.name,
    required this.spent,
    required this.debt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double realWidth = MediaQuery.of(context).size.width - 56;
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 80,
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
          MemberAvatar(
            imageURL: imageURL,
            width: 56,
            height: 56,
            border: 4,
          ),
          const SizedBox(
            width: 12,
          ),
          SizedBox(
            width: realWidth - 68,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (realWidth - 78)*2/3,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: AppColors.whiteColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formatter.format(spent),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatter.format(debt),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
