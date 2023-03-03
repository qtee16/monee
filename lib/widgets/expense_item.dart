import 'package:flutter/material.dart';
import 'package:spending_app/widgets/cached_image_widget.dart';
import 'package:spending_app/widgets/member_avatar.dart';

import '../constants.dart';
import '../utils/utils.dart';

class ExpenseItem extends StatelessWidget {
  final String? imageURL;
  final String title;
  final String type;
  final int price;
  final int quantityMember;
  final DateTime dateTime;
  final Function() onLongPress;

  const ExpenseItem({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.type,
    required this.price,
    required this.quantityMember,
    required this.dateTime,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double realWidth = MediaQuery.of(context).size.width - 56;
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: realWidth - 68,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (realWidth - 78)*2/3,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: AppColors.whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: (realWidth - 78)*1/3,
                        child: Text(
                          "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: realWidth - 68,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (realWidth - 68) / 3,
                        child: Row(
                          children: [
                            SizedBox(
                              width: (realWidth - 68) / 3 - 20,
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.subTitleColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.purpleStartLinearColor,
                                    AppColors.purpleEndLinearColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  quantityMember.toString(),
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          formatter.format(price),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
