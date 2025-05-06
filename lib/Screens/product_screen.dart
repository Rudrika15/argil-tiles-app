import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
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
  final TextEditingController searchController = TextEditingController();
  List<ProductModel> searchProduct = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchProduct = widget.products;
    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        searchProduct = widget.products;
      } else {
        searchProduct =
            widget.products.where((p) {
              final name = p.names?.toLowerCase() ?? '';
              return name.contains(query);
            }).toList();
      }
    });
  }

  void clearSearch() {
    searchController.clear();
    // _onSearchChanged() will run automatically via listener
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = context.watch<FavoriteProvider>();

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
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: clearSearch,
                          )
                          : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.size30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            searchProduct.isNotEmpty
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    itemCount: searchProduct.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8 / 1,
                        ),
                    itemBuilder: (context, index) {
                      ProductModel item = searchProduct[index];
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
                              borderRadius: BorderRadius.circular(
                                AppSize.size10,
                              ),
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
                                          () async => favoriteProvider
                                              .toggleFavorite(item),
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
                )
                : Center(child: Text("No Products To Be Found !!")),
          ],
        ),
      ),
    );
  }

  void searchProducts(String value) {
    setState(() {
      if (value.isEmpty) {
        searchProduct = widget.products;
      } else {
        searchProduct =
            widget.products
                .where(
                  (e) =>
                      e.names?.toLowerCase().contains(value.toLowerCase()) ??
                      false,
                )
                .toList();
      }
    });
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:sizer/sizer.dart';

// class ProductScreen extends StatefulWidget {
//   final String title;
//   final String imageFolder;
//   final List<ProductModel> products;

//   const ProductScreen({
//     Key? key,
//     required this.title,
//     required this.imageFolder,
//     required this.products,
//   }) : super(key: key);

//   @override
//   _ProductScreenState createState() => _ProductScreenState();
// }

// class _ProductScreenState extends State<ProductScreen> {
//   late TextEditingController _searchController;
//   late List<ProductModel> _filteredProducts;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _filteredProducts = widget.products;
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     final query = _searchController.text.trim().toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredProducts = widget.products;
//       } else {
//         _filteredProducts =
//             widget.products.where((p) {
//               final name = p.names?.toLowerCase() ?? '';
//               return name.contains(query);
//             }).toList();
//       }
//     });
//   }

//   void _clearSearch() {
//     _searchController.clear();

//   }

//   @override
//   Widget build(BuildContext context) {
//     final favProvider = context.watch<FavoriteProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF6F1),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFD3C8BA),
//         foregroundColor: AppColors.blackColor,
//         elevation: 0,
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.favorite_border,
//               color: AppColors.blackColor,
//             ),
//             onPressed:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FavoriteScreen()),
//                 ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search products...',
//                 filled: true,
//                 fillColor: Colors.white,
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon:
//                     _searchController.text.isNotEmpty
//                         ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: _clearSearch,
//                         )
//                         : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppSize.size30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),

//           // Results
//           Expanded(
//             child:
//                 _filteredProducts.isEmpty
//                     ? const Center(child: Text("No products found."))
//                     : GridView.builder(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 5.w,
//                         vertical: 2.h,
//                       ),
//                       itemCount: _filteredProducts.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 16,
//                             mainAxisSpacing: 16,
//                             childAspectRatio: 0.8,
//                           ),
//                       itemBuilder: (context, i) {
//                         final product = _filteredProducts[i];
//                         final imageUrl =
//                             "https://admin.argiltiles.com/public/"
//                             "${widget.imageFolder}/${product.mainImg}";

//                         return InkWell(
//                           onTap:
//                               () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (_) => ProductDetailsScreen(
//                                         url: widget.imageFolder,
//                                         productModel: product,
//                                       ),
//                                 ),
//                               ),
//                           child: Stack(
//                             children: [
//                               // Product image & name overlay
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: AppColors.whiteColor,
//                                   borderRadius: BorderRadius.circular(
//                                     AppSize.size10,
//                                   ),
//                                   image: DecorationImage(
//                                     image: NetworkImage(imageUrl),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 child: Align(
//                                   alignment: Alignment.bottomCenter,
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.black54,
//                                       borderRadius: BorderRadius.vertical(
//                                         bottom: Radius.circular(AppSize.size10),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       product.names ?? '',
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               // Favorite toggle
//                               Positioned(
//                                 top: AppSize.size10,
//                                 right: AppSize.size10,
//                                 child: GestureDetector(
//                                   onTap:
//                                       () => favProvider.toggleFavorite(product),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.black45,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       favProvider.isFavorite(product)
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color:
//                                           favProvider.isFavorite(product)
//                                               ? AppColors.errorColor
//                                               : Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }
