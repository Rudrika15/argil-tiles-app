import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../model/common_product_model.dart';
import '../widgets/custom_container.dart';

class ProductScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (products.isEmpty) {
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
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [],
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
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8 / 1,
                ),
                itemBuilder: (context, index) {
                  ProductModel item = products[index];
                  return Stack(
                    children: [
                      CustomContainer(
                        backGroundColor: AppColors.whiteColor,
                        // boxShadow: [BoxShadowHelper.shadow],
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://admin.argiltiles.com/public/$url/${item.mainImg}",
                          ),
                        ),
                      ),
                      Positioned(
                        top: AppSize.size10,
                        right: AppSize.size10,
                        child: InkWell(
                          onTap: () => {},
                          child: Icon(
                            Icons.favorite_border,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            item.names ?? "",
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ],
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
