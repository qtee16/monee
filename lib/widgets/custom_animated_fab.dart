import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAnimatedFAB extends StatefulWidget {
  final bool showFab;
  final Function() onTap;
  const CustomAnimatedFAB({Key? key, required this.showFab, required this.onTap}) : super(key: key);

  @override
  State<CustomAnimatedFAB> createState() => _CustomAnimatedFABState();
}

class _CustomAnimatedFABState extends State<CustomAnimatedFAB> {

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return AnimatedSlide(
      duration: duration,
      offset: widget.showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: duration,
        opacity: widget.showFab ? 1 : 0,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  AppColors.purpleStartLinearColor,
                  AppColors.purpleEndLinearColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
