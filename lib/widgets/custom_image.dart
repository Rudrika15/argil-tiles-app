import 'package:argil_tiles/utils/navigation_helper/navigation_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../app_const/app_color.dart';
import '../app_const/app_size.dart';
import 'package:shimmer/shimmer.dart';

import 'photo_view.dart';

class CustomImageWithLoader extends StatelessWidget with NavigateHelper {
  const CustomImageWithLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorIconSize,
    this.showImageInPanel = true,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? errorIconSize;
  final bool showImageInPanel;

  @override
  Widget build(BuildContext context) {
    final CachedNetworkImage image = CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      errorWidget:
          (context, url, error) => Icon(
            Icons.broken_image_rounded,
            color: AppColors.brown,
            size: errorIconSize ?? AppSize.size50,
          ),
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: AppColors.homeGradient2,
            highlightColor: AppColors.appBar,
            child: Container(
              width: width ?? double.infinity,
              // height: height ?? 10.h,
              color: AppColors.whiteColor,
            ),
          ),
    );

    return showImageInPanel
        ? GestureDetector(
          onTap:
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PhotoViewWidget(imageUrl: imageUrl),
                ),
              ),

          child: image,
        )
        : image;
  }
}

