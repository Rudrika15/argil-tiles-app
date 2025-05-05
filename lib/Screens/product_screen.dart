import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
import 'package:argil_tiles/utils/shared_preference/shared_prefrence.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../model/common_product_model.dart';
import '../widgets/custom_container.dart';
import 'favourite_screen.dart';

class ProductScreen extends StatefulWidget {
  final String title;
  final String url;
  final List<ProductModel> products;
  const ProductScreen({
    super.key,
    required this.title,
    required this.products,
    required this.url,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = context.watch<FavoriteProvider>();
    if (widget.products.isEmpty) {
      return Center(child: Text("No Products To Be Found !!"));
    }
    return PopAndRedirectToHome(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6F1),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          surfaceTintColor: const Color(0xFFD3C8BA),
          foregroundColor: AppColors.blackColor,
          elevation: 0,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppColors.blackColor,
              ),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoriteScreen()),
                  ),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                itemCount: widget.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8 / 1,
                ),
                itemBuilder: (context, index) {
                  ProductModel item = widget.products[index];
                  item.imageUrl = widget.url;
                  return InkWell(
                    onTap:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => ProductDetailsScreen(
                                  url: widget.url,
                                  productModel: item,
                                ),
                          ),
                        ),
                    child: Stack(
                      children: [
                        CustomContainer(
                          backGroundColor: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://admin.argiltiles.com/public/${widget.url}/${item.mainImg}",
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: AppSize.size10,
                                right: AppSize.size10,
                                child: InkWell(
                                  onTap:
                                      () async =>
                                          favoriteProvider.toggleFavorite(item),
                                  child: CustomContainer(
                                    backGroundColor: AppColors.blackColor
                                        .withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    child: Icon(
                                      favoriteProvider.isFavorite(item)
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border,
                                      color:
                                          favoriteProvider.isFavorite(item)
                                              ? AppColors.errorColor
                                              : AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                width: 42.w,
                                child: CustomContainer(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(AppSize.size10),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  backGroundColor: AppColors.blackColor
                                      .withOpacity(0.5),
                                  child: Text(
                                    item.names ?? "",
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String imagePath;
  const ProductDetailScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: Center(child: Image.asset(imagePath)),
    );
  }
}
