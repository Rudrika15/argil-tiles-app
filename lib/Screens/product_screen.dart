import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
import 'package:argil_tiles/widgets/custom_image.dart';
import 'package:argil_tiles/widgets/debouncer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../model/common_product_model.dart';
import '../utils/api_helper/api_hepler.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_infinite_pagination.dart';
import 'favourite_screen.dart';

class ProductScreen extends StatefulWidget {
  final String title;
  final bool isSpcProduct;
  final String url;
  const ProductScreen({
    super.key,
    required this.title,
    required this.url,
    required this.isSpcProduct,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(
      () => Debouncer().run(
        () => setState(() {
          query = searchController.text;
        }),
      ),
    );
  }

  void clearSearch() {
    searchController.clear();
    // _onSearchChanged() will run automatically via listener
  }

  @override
  void dispose() {
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
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                child: UrlPagedList<ProductModel>(
                  url:
                      (page, query) =>
                          widget.isSpcProduct
                              ? ApiHelper.spcProductPagination(
                                page: page,
                                query: query,
                              )
                              : ApiHelper.quartzProductPagination(
                                page: page,
                                query: query,
                              ),
                  searchQuery: query,
                  pageParam: 'page',
                  perPageParam: 'per_page',
                  pageSize: 6,
                  fromJson:
                      (m) => ProductModel.fromJson(m, widget.isSpcProduct),
                  isListView: false,
                  itemBuilder: (ctx, product, i) {
                    product.imageUrl = widget.url;
                    return InkWell(
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductDetailsScreen(
                                    url: widget.url,
                                    productModel: product,
                                    isSpcProduct: widget.isSpcProduct,
                                  ),
                            ),
                          ),
                      child: Stack(
                        children: [
                          CustomContainer(
                            backGroundColor: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSize.size10,
                                  ),
                                  child: CustomImageWithLoader(
                                    height: 35.h,
                                    width: 50.w,
                                    showImageInPanel: false,
                                    imageUrl:
                                        "${ApiHelper.assetsUrl}${widget.url}/${product.mainImg}",
                                  ),
                                ),
                                Positioned(
                                  top: AppSize.size10,
                                  right: AppSize.size10,
                                  child: InkWell(
                                    onTap:
                                        () async => favoriteProvider
                                            .toggleFavorite(product),
                                    child: CustomContainer(
                                      backGroundColor: AppColors.blackColor
                                          .withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      child: Icon(
                                        favoriteProvider.isFavorite(product)
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border,
                                        color:
                                            favoriteProvider.isFavorite(product)
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
                                      product.names ?? "",
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
            ),
          ],
        ),
      ),
    );
  }
}
