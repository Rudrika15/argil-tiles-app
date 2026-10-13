import 'dart:developer';
import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import '../utils/http_helper/http_helper.dart';
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
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    FavoriteProvider favoriteProvider = context.watch<FavoriteProvider>();

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
            widget.title,
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: AppColors.blackColor,
                size: isTablet ? 28 : 24,
              ),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoriteScreen()),
                  ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 3.w : 5.w,
                vertical: isTablet ? 1.5.h : 2.h,
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(fontSize: isTablet ? 16 : 14),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                  prefixIcon: Icon(
                    Icons.search,
                    size: isTablet ? 24 : 20,
                    color: Colors.grey.shade600,
                  ),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: isTablet ? 22 : 18,
                            ),
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
                  itemBuilderWithList: (ctx, product, i, allProducts) {
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
                                    products: allProducts,
                                    initialIndex: i,
                                    onLoadMore: (nextPage) async {
                                      try {
                                        final uri =
                                            widget.isSpcProduct
                                                ? ApiHelper.spcProductPagination(
                                                  page: nextPage.toString(),
                                                  query: query,
                                                )
                                                : ApiHelper.quartzProductPagination(
                                                  page: nextPage.toString(),
                                                  query: query,
                                                );
                                        final resp = await HttpHelper.get(
                                          context: context,
                                          uri: uri,
                                        );
                                        if (resp['data'] != null &&
                                            resp['data']['data'] is List) {
                                          final List<dynamic> rawList =
                                              resp['data']['data'];
                                          return rawList
                                              .whereType<Map<String, dynamic>>()
                                              .map((m) {
                                                final p = ProductModel.fromJson(
                                                  m,
                                                  widget.isSpcProduct,
                                                );
                                                p.imageUrl = widget.url;
                                                return p;
                                              })
                                              .toList();
                                        }
                                      } catch (e) {
                                        log("Error loading more products in details: $e");
                                      }
                                      return [];
                                    },
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
                                    height: isTablet ? double.infinity : 35.h,
                                    width: isTablet ? double.infinity : 50.w,
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
                                      padding: EdgeInsets.all(isTablet ? 6 : 4),
                                      backGroundColor: AppColors.blackColor
                                          .withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      child: Icon(
                                        favoriteProvider.isFavorite(product)
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border,
                                        size: isTablet ? 24 : 20,
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
                                  right: 0,
                                  child: CustomContainer(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(AppSize.size10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: isTablet ? 8 : 4,
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    backGroundColor: AppColors.blackColor
                                        .withOpacity(0.55),
                                    child: Text(
                                      product.names ?? "",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: isTablet ? 14 : 11,
                                        fontWeight: FontWeight.w600,
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
