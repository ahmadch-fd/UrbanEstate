import 'package:flutter/material.dart';

class MySliverDelegate extends SliverPersistentHeaderDelegate{
 Widget child;
 double height;

 MySliverDelegate({ required this.child,required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => height;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(MySliverDelegate oldDelegate) {
     return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
     
  }
  
}