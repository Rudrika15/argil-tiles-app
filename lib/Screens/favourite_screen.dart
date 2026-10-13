import 'dart:developer';
import 'package:argil_tiles/model/common_product_model.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
import 'package:argil_tiles/widgets/custom_image.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../utils/api_helper/api_hepler.dart';
import '../utils/widget_helper/widhet_helper.dart';
import '../widgets/custom_container.dart';
import 'product_details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = context.watch<FavoriteProvider>();
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return PopAndRedirectToHome(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6F1),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          surfaceTintColor: const Color(0xFFD3C8BA),
          foregroundColor: AppColors.blackColor,
          elevation: 0,
          leading: BackButton(
            style: ButtonStyle(
              iconSize: WidgetStatePropertyAll(isTablet ? 26 : 22),
            ),
          ),
          title: Text(
            "Favorite",
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: isTablet ? 28 : 24,
                      color: AppColors.blackColor,
                    ),
                    onPressed: () => WidgetHelper.openEndDrawerSafely(context),
                  ),
            ),
            SizedBox(width: isTablet ? 12 : 8),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: DrawerWidget(),
        body:
            favoriteProvider.favorites.isEmpty
                ? Center(
                  child: Text(
                    "No Favorite Products yet!",
                    style: TextStyle(fontSize: isTablet ? 20 : 16),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.all(isTablet ? 16.0 : 10.0),
                  child: GridView.builder(
                    itemCount: favoriteProvider.favorites.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? (isLandscape ? 4 : 3) : 2,
                      crossAxisSpacing: isTablet ? 16 : 10,
                      mainAxisSpacing: isTablet ? 16 : 10,
                      childAspectRatio: isTablet ? 0.95 : 3 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final ProductModel item =
                          favoriteProvider.favorites[index];
                      log(
                        "${ApiHelper.assetsUrl}${item.imageUrl}/${item.mainImg}",
                      );
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductDetailsScreen(
                                      url: item.imageUrl ?? "",
                                      productModel: item,
                                      isSpcProduct: item.isSpcProduct,
                                      products: favoriteProvider.favorites,
                                      initialIndex: index,
                                    ),
                              ),
                            ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CustomImageWithLoader(
                                showImageInPanel: false,
                                width: isTablet ? double.infinity : 50.w,
                                height: isTablet ? double.infinity : 30.h,
                                imageUrl:
                                    "${ApiHelper.assetsUrl}${item.imageUrl}/${item.mainImg}",
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap:
                                    () => favoriteProvider.removeFavorite(item),
                                child: CircleAvatar(
                                  radius: isTablet ? 16 : 14,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    size: isTablet ? 18 : 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CustomContainer(
                                padding: EdgeInsets.all(isTablet ? 8 : 6),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                                backGroundColor: Colors.black.withOpacity(0.6),
                                child: Text(
                                  item.names ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTablet ? 14 : 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
