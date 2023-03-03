

import 'package:flutter/material.dart';

class MyTab extends SliverPersistentHeaderDelegate{
  final Widget child;

  MyTab({required this.child,});

  @override
  Widget build(BuildContext context,shrinkOffset,overlapsContent) {
    return child;
  }
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {

    return true;
  }
  @override

  double  maxExtent = 50;
  @override

  double  minExtent = 50;
}