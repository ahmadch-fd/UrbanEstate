import 'dart:math' as math;

import 'package:flutter/material.dart';

class Responsive {
  Responsive._(this.context)
    : size = MediaQuery.sizeOf(context),
      shortestSide = MediaQuery.sizeOf(context).shortestSide;

  final BuildContext context;
  final Size size;
  final double shortestSide;

  static Responsive of(BuildContext context) => Responsive._(context);

  double get width => size.width;
  double get height => size.height;
  bool get isSmallPhone => width < 360;
  bool get isTablet => shortestSide >= 600;

  double scale(double value) {
    final baseWidth = isTablet ? 600.0 : 390.0;
    final scale = width / baseWidth;
    return value * scale.clamp(0.85, 1.25);
  }

  double font(double value) => scale(value);
  double space(double value) => scale(value);
  double icon(double value) => scale(value);

  double get pagePadding => scale(isTablet ? 24 : 16);
  double get sectionGap => scale(14);
  double get bottomNavSpace =>
      scale(96) + MediaQuery.paddingOf(context).bottom;

  double get searchHeight => scale(isSmallPhone ? 46 : 52);
  double get buttonHeight => scale(isSmallPhone ? 48 : 52);
  double get authFieldWidth => math.min(width * 0.88, isTablet ? 520 : 380);
  double get socialButtonWidth => math.min(width * 0.2, 92);
  double get socialButtonHeight => scale(52);

  int get propertyGridColumns => isTablet ? 3 : 2;
  double get propertyGridRatio => isTablet ? 0.72 : (isSmallPhone ? 0.54 : 0.58);
  double get propertyGridSpacing => scale(14);
  double get compactCardImageHeight => scale(isSmallPhone ? 92 : 100);
  double get largeCardImageHeight => scale(isTablet ? 220 : 180);
  double get detailHeaderHeight => height.clamp(640, 900) * 0.42;
}
