import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WaterMarkLogo extends StatelessWidget {
  const WaterMarkLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.05,
        child: Image.asset(
          'assets/images/logo_triangle.png',
          width: 60.w,
          height: 30.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
