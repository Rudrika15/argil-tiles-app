import 'package:flutter/material.dart';
import '../app_const/app_color.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewWidget extends StatelessWidget with NavigateHelper {
  const PhotoViewWidget({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGradient2,
      body: SafeArea(
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: AppColors.homeGradient2,
          ),
          imageProvider: NetworkImage(imageUrl),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pop(context),
        backgroundColor: AppColors.brown,
        foregroundColor: AppColors.homeGradient2,
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
