import 'package:flutter/material.dart';

import '../../app_const/app_color.dart';

class BoxShadowHelper {
  static BoxShadow shadow = BoxShadow(
    color: Color(0xFF000000).withOpacity(1),
    offset: Offset(0, 4),
    blurRadius: 8,
    spreadRadius: -2,
  );
  static List<Color> homeGradient = [
    AppColors.appBar,
    AppColors.homeGradient2,
  ];
}
