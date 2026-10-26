import 'dart:async';
import 'dart:developer';
import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/method_helper/gradient_helper.dart';
import 'package:argil_tiles/widgets/custom_container.dart';
import 'package:argil_tiles/widgets/custom_image.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/inquiry_form.dart';
import 'package:argil_tiles/widgets/photo_view.dart';
import 'package:argil_tiles/utils/widget_helper/widhet_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../model/common_product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String url;
  final bool isSpcProduct;
  final ProductModel? productModel;
  final List<ProductModel>? products;
  final int initialIndex;
  final Future<List<ProductModel>> Function(int nextPage)? onLoadMore;

  const ProductDetailsScreen({
    super.key,
    this.productModel,
    this.products,
    this.initialIndex = 0,
    this.onLoadMore,
    required this.url,
    required this.isSpcProduct,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late List<ProductModel> _products;
  late int _currentIndex;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _nextPage = 2;
  bool _showTourGuide = false;
  double _tourGuideOpacity = 0.0;
  Timer? _tourGuideTimer;

  @override
  void initState() {
    super.initState();
    if (widget.products != null && widget.products!.isNotEmpty) {
      _products = List<ProductModel>.from(widget.products!);
      if (widget.productModel != null) {
        final foundIndex = _products.indexWhere(
          (p) => p.id == widget.productModel?.id,
        );
        _currentIndex = foundIndex != -1 ? foundIndex : widget.initialIndex;
      } else {
        _currentIndex = widget.initialIndex;
      }
      _currentIndex = _currentIndex.clamp(0, _products.length - 1);
    } else if (widget.productModel != null) {
      _products = [widget.productModel!];
      _currentIndex = 0;
    } else {
      _products = [];
      _currentIndex = 0;
    }

    _pageController = PageController(initialPage: _currentIndex);

    if (_products.length > 1) {
      _showTourGuide = true;
      _tourGuideOpacity = 1.0;
      _tourGuideTimer = Timer(const Duration(seconds: 4), () {
        _dismissTourGuide();
      });
    }
  }

  @override
  void dispose() {
    _tourGuideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _dismissTourGuide() {
    if (_showTourGuide && _tourGuideOpacity > 0.0) {
      _tourGuideTimer?.cancel();
      if (mounted) {
        setState(() {
          _tourGuideOpacity = 0.0;
        });
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted && _tourGuideOpacity == 0.0) {
            setState(() {
              _showTourGuide = false;
            });
          }
        });
      }
    }
  }

  void _previousProduct() {
    _dismissTourGuide();
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextProduct() {
    _dismissTourGuide();
    if (_currentIndex < _products.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _checkLoadMore(int index) async {
    if (widget.onLoadMore != null &&
        _hasMore &&
        !_isLoadingMore &&
        index >= _products.length - 2) {
      _isLoadingMore = true;
      try {
        final newItems = await widget.onLoadMore!(_nextPage);
        if (newItems.isEmpty) {
          _hasMore = false;
        } else {
          _nextPage++;
          if (mounted) {
            setState(() {
              _products.addAll(newItems);
            });
          }
        }
      } catch (e) {
        log("Error loading more products in details: $e");
      } finally {
        _isLoadingMore = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = context.watch<FavoriteProvider>();

    final currentProduct =
        _products.isNotEmpty && _currentIndex < _products.length
            ? _products[_currentIndex]
            : widget.productModel;

    final currentUrl =
        (currentProduct?.imageUrl != null &&
                currentProduct!.imageUrl!.isNotEmpty)
            ? currentProduct.imageUrl!
            : widget.url;

    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFD3C8BA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3C8BA),
        surfaceTintColor: const Color(0xFFD3C8BA),
        leading: BackButton(
          style: ButtonStyle(
            iconSize: WidgetStatePropertyAll(isTablet ? 26 : 22),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentProduct?.names ?? '',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_products.length > 1)
              Text(
                'Product ${_currentIndex + 1} of ${_products.length}',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.brown.shade900.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.blackColor,
                    size: isTablet ? 28 : 24,
                  ),
                  onPressed: () => WidgetHelper.openEndDrawerSafely(context),
                ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: DrawerWidget(),

      body: SafeArea(
        child: Column(
          children: [
            // Top Content - Swipeable between products
            Expanded(
              child:
                  _products.isEmpty
                      ? (widget.productModel != null
                          ? _buildProductDetailView(
                            context: context,
                            product: widget.productModel!,
                            favoriteProvider: favoriteProvider,
                          )
                          : const Center(child: Text("Product not found")))
                      : Stack(
                          children: [
                            NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is UserScrollNotification &&
                                    _showTourGuide) {
                                  _dismissTourGuide();
                                }
                                return false;
                              },
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _products.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                  _dismissTourGuide();
                                  _checkLoadMore(index);
                                },
                                itemBuilder: (context, index) {
                                  final product = _products[index];
                                  return _buildProductDetailView(
                                    context: context,
                                    product: product,
                                    favoriteProvider: favoriteProvider,
                                  );
                                },
                              ),
                            ),

                            // Side navigation buttons (product slider) & Tour guide
                            if (_products.length > 1) ...[
                              // Left navigation button
                              if (_currentIndex > 0)
                                Positioned(
                                  left: isTablet ? 16 : 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: _buildSideNavButton(
                                      icon: Icons.chevron_left,
                                      onTap: _previousProduct,
                                      isTablet: isTablet,
                                    ),
                                  ),
                                ),

                              // Right navigation button
                              if (_currentIndex < _products.length - 1)
                                Positioned(
                                  right: isTablet ? 16 : 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: _buildSideNavButton(
                                      icon: Icons.chevron_right,
                                      onTap: _nextProduct,
                                      isTablet: isTablet,
                                    ),
                                  ),
                                ),

                              // Tour guide: "Swipe to browse products"
                              if (_showTourGuide)
                                Positioned.fill(
                                  child: Center(
                                    child: _buildTourGuideWidget(isTablet),
                                  ),
                                ),
                            ],
                          ],
                        ),
            ),

            // Bottom Buttons
            SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 480 : 550,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isTablet ? 14 : 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            context: context,
                            label: "Inquiry Now",
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => Dialog(
                                        child: InquiryForm(
                                          productId: currentProduct?.id ?? -1,
                                          productName:
                                              currentProduct?.names ??
                                              "Not Found",
                                          category: currentUrl,
                                        ),
                                      ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailView({
    required BuildContext context,
    required ProductModel product,
    required FavoriteProvider favoriteProvider,
  }) {
    final effectiveUrl =
        (product.imageUrl != null && product.imageUrl!.isNotEmpty)
            ? product.imageUrl!
            : widget.url;
    final isSpc = product.isSpcProduct || widget.isSpcProduct;

    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 720 : double.infinity),
        child: ListView(
          padding: EdgeInsets.only(
            bottom: 20,
            left: isTablet ? 24 : 0,
            right: isTablet ? 24 : 0,
          ),
          children: [
            ProductImageCarousel(productModel: product, url: effectiveUrl),

            SizedBox(height: isTablet ? 24 : 16),
            _buildSectionTitle(
              title: "Product Information",
              favoriteProvider: favoriteProvider,
              item: product,
              url: effectiveUrl,
              isTablet: isTablet,
            ),
            SizedBox(height: isTablet ? 16 : 12),

            _buildInfoCard(
              iconPath: "assets/images/spaces_icon.png",
              title: "Spaces",
              isTablet: isTablet,
              rows: [
                _infoRow("Primary Color", product.primarycolors ?? '', isTablet),
                _infoRow("Stock", product.stock ?? '', isTablet),
                _infoRow("Book Match", product.bookmatch ?? '', isTablet),
                _infoRow("Available Finish", product.finishType ?? "", isTablet),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 10),

            _buildInfoCard(
              iconPath: "assets/images/sizes_icon.png",
              title: "Sizes",
              isTablet: isTablet,
              rows: [
                _infoRow("Thickness", product.thicknesses ?? '', isTablet),
                if (!isSpc) _infoRow("Slab Size", product.sizes ?? "", isTablet),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 10),

            _buildApplicationsCard(
              iconPath: "assets/images/application_icon.png",
              isSpc: isSpc,
              isTablet: isTablet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required FavoriteProvider favoriteProvider,
    required ProductModel item,
    required String url,
    bool isTablet = false,
  }) {
    log(" ===${item.imageUrl}");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 24 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap:
                () async => {
                  item.imageUrl = url,
                  favoriteProvider.toggleFavorite(item),
                },
            child: CustomContainer(
              shape: BoxShape.circle,
              padding: EdgeInsets.all(isTablet ? 4 : 0),
              child: Icon(
                favoriteProvider.isFavorite(item)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border,
                size: isTablet ? 30 : 24,
                color:
                    favoriteProvider.isFavorite(item)
                        ? AppColors.errorColor
                        : AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> rows,
    required String iconPath,
    bool isTablet = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 12,
          vertical: isTablet ? 18 : 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                iconImageContainer(iconPath, isTablet),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 21 : 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 14 : 8),
            ...rows,
          ],
        ),
      ),
    );
  }

  CustomContainer iconImageContainer(String iconPath, [bool isTablet = false]) {
    final double iconSize = isTablet ? 26 : 15;
    return CustomContainer(
      margin: EdgeInsets.only(right: isTablet ? 12 : 3.w),
      height: iconSize,
      width: iconSize,
      image: DecorationImage(image: AssetImage(iconPath)),
    );
  }

  Widget _infoRow(String label, String value, [bool isTablet = false]) {
    final TextStyle labelStyle = TextStyle(
      fontSize: isTablet ? 18 : 13,
      fontWeight: isTablet ? FontWeight.w600 : FontWeight.w500,
      color: Colors.black87,
    );
    final TextStyle valueStyle = TextStyle(
      fontSize: isTablet ? 18 : 13,
      color: Colors.black,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 7 : 2),
      child:
          value.trim().isNotEmpty
              ? Row(
                children: [
                  isTablet
                      ? SizedBox(
                        width: 200,
                        child: Text("$label :", style: labelStyle),
                      )
                      : Expanded(flex: 2, child: Text("$label :", style: labelStyle)),
                  Expanded(
                    flex: isTablet ? 1 : 3,
                    child: Text(value, style: valueStyle),
                  ),
                ],
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildApplicationsCard({
    required String iconPath,
    required bool isSpc,
    bool isTablet = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : AppSize.size10,
          vertical: isTablet ? 18 : AppSize.size10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F4),
          borderRadius: BorderRadius.circular(AppSize.size10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                iconImageContainer(iconPath, isTablet),
                Text(
                  "Applications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 21 : 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 14 : AppSize.size10),
            _applicationRow("Flooring", true, true, isTablet),
            if (!isSpc) _applicationRow("Counters", true, true, isTablet),
            _applicationRow("Wall", true, true, isTablet),
            // _applicationRow("Other", true, false),
          ],
        ),
      ),
    );
  }

  Widget _applicationRow(String label, bool residential, bool commercial, [bool isTablet = false]) {
    final TextStyle textStyle = TextStyle(
      fontSize: isTablet ? 18 : 13,
      fontWeight: isTablet ? FontWeight.w600 : FontWeight.normal,
    );
    final TextStyle statusStyle = TextStyle(
      fontSize: isTablet ? 17 : 13,
      fontWeight: isTablet ? FontWeight.w500 : FontWeight.normal,
    );
    final double iconSize = isTablet ? 22 : 16;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 7 : 2),
      child: Row(
        children: [
          isTablet
              ? SizedBox(
                width: 200,
                child: Text("$label :", style: textStyle),
              )
              : Expanded(child: Text("$label :", style: textStyle)),
          Expanded(
            flex: isTablet ? 1 : 2,
            child: Row(
              children: [
                Row(
                  children: [
                    Text("Residential ", style: statusStyle),
                    Icon(
                      residential ? Icons.check : Icons.close,
                      size: iconSize,
                      color: residential ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                SizedBox(width: isTablet ? 20 : 8),
                Row(
                  children: [
                    Text("Commercial ", style: statusStyle),
                    Icon(
                      commercial ? Icons.check : Icons.close,
                      size: iconSize,
                      color: commercial ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return SizedBox(
      height: isTablet ? 54 : 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade800,
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 36 : 16,
            vertical: isTablet ? 14 : 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    final double buttonSize = isTablet ? 54 : 44;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: Colors.brown.shade800.withValues(alpha: 0.65),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isTablet ? 32 : 26,
          ),
        ),
      ),
    );
  }

  Widget _buildTourGuideWidget(bool isTablet) {
    return IgnorePointer(
      ignoring: !_showTourGuide || _tourGuideOpacity == 0.0,
      child: AnimatedOpacity(
        opacity: _tourGuideOpacity,
        duration: const Duration(milliseconds: 350),
        child: GestureDetector(
          onTap: _dismissTourGuide,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 14,
              vertical: isTablet ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.brown.shade800.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: isTablet ? 20 : 16,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.swipe,
                  color: Colors.white,
                  size: isTablet ? 22 : 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "Swipe to browse products",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 15 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: isTablet ? 20 : 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class ProductImageCarousel extends StatefulWidget {
  final ProductModel? productModel;
  final String url;

  const ProductImageCarousel({
    super.key,
    required this.productModel,
    required this.url,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _goToPage(int delta) {
    final totalPages = widget.productModel?.availableImages.length ?? 0;
    final newPage = (_currentPage + delta).clamp(0, totalPages - 1);
    if (newPage != _currentPage) {
      _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage = newPage);
    }
  }

  @override
  void didUpdateWidget(covariant ProductImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productModel?.id != widget.productModel?.id) {
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageCount = widget.productModel?.availableImages.length ?? 0;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          borderColor: AppColors.greyColor,
          borderWidth: 0.4,
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 0 : 5.w,
            vertical: isTablet ? 1.h : 2.h,
          ),
          padding: const EdgeInsets.all(2),
          borderRadius: BorderRadius.circular(AppSize.size10),
          backGroundColor: AppColors.whiteColor,
          boxShadow: [BoxShadowHelper.shadow],
          height: isTablet
              ? (widget.url == "spc" ? 34.h : 28.h)
              : (widget.url == "spc" ? 25.h : 20.h),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const PageScrollPhysics(),
                itemCount: imageCount,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final imgUrl =
                      '${ApiHelper.assetsUrl}/${widget.url}/${widget.productModel?.getImageByIndex(index: index)}';
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => PhotoViewWidget(imageUrl: imgUrl),
                        ),
                      );
                    },
                    child: CustomContainer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: CustomImageWithLoader(imageUrl: imgUrl),
                      ),
                    ),
                  );
                },
              ),
              if (imageCount > 1) ...[
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () => _goToPage(-1),
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 8 : 4),
                        decoration: BoxDecoration(
                          color: AppColors.brown.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: AppColors.whiteColor,
                          size: isTablet ? 28 : 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () => _goToPage(1),
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 8 : 4),
                        decoration: BoxDecoration(
                          color: AppColors.brown.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: AppColors.whiteColor,
                          size: isTablet ? 28 : 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Horizontal thumbnail image row when product image is more than one
        if (imageCount > 1)
          Container(
            height: isTablet ? 90 : 80,
            margin: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 5.w),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imageCount,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _currentPage == index;
                final imageUrl =
                    '${ApiHelper.assetsUrl}/${widget.url}/${widget.productModel?.getImageByIndex(index: index)}';

                return GestureDetector(
                  onTap: () {
                    if (_currentPage != index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      setState(() => _currentPage = index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isTablet ? 90 : 80,
                    height: isTablet ? 90 : 80,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.brown
                                : AppColors.greyColor.withValues(alpha: 0.5),
                        width: isSelected ? 2.0 : 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isSelected
                                  ? AppColors.brown.withValues(alpha: 0.25)
                                  : Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWithLoader(
                        imageUrl: imageUrl,
                        showImageInPanel: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
