import 'package:argil_tiles/utils/navigation_helper/navigation_helper.dart';
import 'package:argil_tiles/widgets/custom_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../app_const/app_size.dart';
import 'package:shimmer/shimmer.dart';

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
              () =>
              // push(
              //   context: context,
              //   widget: ViewImageInPage(imageUrl: imageUrl),
              //   transition: FadeForwardsPageTransitionsBuilder(),
              // ),
              showDialog(
                context: context,
                builder:
                    (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: CustomContainer(
                          width: 100.w,
                          height: 100.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            child: InteractiveViewer(
                              scaleEnabled: true,
                              child: CustomImageWithLoader(
                                fit: BoxFit.contain,
                                imageUrl: imageUrl,
                                showImageInPanel: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
          child: image,
        )
        : image;
  }
}

// class CustomLoaderImage extends StatelessWidget {
//   const CustomLoaderImage({
//     super.key,
//     this.backGroundColor,
//     required this.imageUrl,
//     this.radius,
//   });
//   final Color? backGroundColor;
//   final String imageUrl;
//   final double? radius;
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: radius ?? AppSize.size50,
//       backgroundColor: backGroundColor ?? AppColors.whiteColor,
//       backgroundImage: AssetImage(AppImageStrings.spinner),
//       foregroundImage: NetworkImage(imageUrl),
//     );
//   }
// }
// class ViewImageInPage extends StatelessWidget {
//   const ViewImageInPage({super.key, required this.imageUrl});
//   final String imageUrl;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () {}),
//       body: CustomContainer(
//         width: 100.w,
//         height: 100.h,
//         child: InteractiveViewer(
//           child: InteractiveViewer(
//             scaleEnabled: true,
//             child: CustomImageWithLoader(
//               fit: BoxFit.contain,
//               imageUrl: imageUrl,
//               showImageInPanel: false,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
