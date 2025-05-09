import 'package:argil_tiles/app_const/app_size.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.boxFit,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width ?? 50.w,
      height: height ?? 20.h,
      fit: boxFit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "assets/images/no_image_found.png",
          width: AppSize.size40,
          height: AppSize.size50,
        );
      },
    );
  }
}

