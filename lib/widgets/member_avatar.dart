import 'package:flutter/material.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/widgets/cached_image_widget.dart';

class MemberAvatar extends StatelessWidget {
  final String? imageURL;
  final double? width;
  final double? height;
  final double? border;

  const MemberAvatar(
      {Key? key, required this.imageURL, this.width, this.height, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageURL != null
        ? CachedImageWidget(
            imageURL: imageURL!,
            width: width,
            height: height,
            border: border,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(border ?? 0),
            child: Image.asset(
              AssetPaths.imagePath.getDefaultUserImagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          );
  }
}
