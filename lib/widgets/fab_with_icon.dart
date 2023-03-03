import 'package:flutter/material.dart';

import '../constants.dart';

class FabWithIcons extends StatefulWidget {
  FabWithIcons({required this.items, required this.onIconTapped});
  final List<Map<String, dynamic>> items;
  ValueChanged<int> onIconTapped;
  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.items.length, (int index) {
        return _buildChild(widget.items[index], index);
      }).toList()..add(
        _buildFab(),
      ),
    );
  }

  Widget _buildChild(Map<String, dynamic> item, int index) {
    return Container(
      height: 60.0,
      width: double.infinity,
      alignment: FractionalOffset.topRight,
      child: ScaleTransition(
        alignment: Alignment.bottomRight,
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
              0.0,
              1.0 - index / widget.items.length / 2.0,
              curve: Curves.easeOut
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.purpleStartLinearColor,
                    AppColors.purpleEndLinearColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(widget.items[index]['title'], style: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w500),),
            ),
            const SizedBox(width: 4,),
            GestureDetector(
              onTap: () {
                _onTapped(index);
                widget.items[index]['onTap'].call();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.purpleStartLinearColor,
                      AppColors.purpleEndLinearColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(widget.items[index]['icon'], color: AppColors.whiteColor),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
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
        child: const Icon(Icons.add, color: AppColors.whiteColor,),
      ),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}