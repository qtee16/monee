import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double border;

  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    required this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!.withOpacity(0.4),
      highlightColor: Colors.grey[100]!.withOpacity(0.4),
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(border),
        ),
      ),
    );
  }
}
