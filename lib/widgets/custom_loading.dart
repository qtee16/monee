import 'package:flutter/material.dart';
import 'package:spending_app/constants.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({
    Key? key,
  }) : super(key: key);

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoadingTwo();
  }

  Widget _buildLoadingTwo() {
    return Stack(alignment: Alignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(
          AssetPaths.imagePath.getLogoImagePath,
          height: 50,
          width: 50,
        ),
      ),
      RotationTransition(
        alignment: Alignment.center,
        turns: _controller,
        child: Image.asset(
          AssetPaths.iconPath.getLoadingIconPath,
          height: 80,
          width: 80,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void showAppLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const CustomLoading();
    },
  );
}
