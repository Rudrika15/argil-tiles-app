import 'package:flutter/material.dart';
import '../app_const/app_color.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: AppColors.brown,
        color: AppColors.appBar,
      ),
    );
  }
}
