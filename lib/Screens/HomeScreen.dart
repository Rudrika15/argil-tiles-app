import 'dart:async';
import 'dart:developer';
import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/model/common_product_model.dart';
import '../utils/http_helper/http_helper.dart';
import 'package:argil_tiles/utils/navigation_helper/navigation_helper.dart';
import 'package:argil_tiles/widgets/custom_container.dart';
import 'package:argil_tiles/widgets/custom_image.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import '../app_const/app_color.dart';
import '../provider/homescreen_provider.dart';
import '../provider/quartzproducts_provider.dart';
import '../provider/spcproducts_provider.dart';
import '../Screens/favourite_screen.dart';
import '../Screens/product_screen.dart';
import '../utils/api_helper/api_hepler.dart';
import '../utils/method_helper/gradient_helper.dart';
import '../utils/widget_helper/widhet_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with NavigateHelper {
  bool showAllQuartz = false;
  bool showAllSpc = false;
  Timer? _backPressTimer;
  static const int _exitTimeInSec = 2;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      initHomeScreenData(context: context);
    });
  }

  void initHomeScreenData({required BuildContext context}) async {
    await context.read<HomeScreenProvider>().loadHomeScreenData(
      context: context,
    );
    await context.read<QuartzproductsProvider>().loadQuartzProducts(
      context: context,
    );
    await context.read<SpcProductProvider>().loadSpcProducts(context: context);
    // await context.read<NewarrivalProvider>().fetchNewArrivals(context: context);
  }

  Future<bool> _onWillPop() async {
    if (_backPressTimer == null || !_backPressTimer!.isActive) {
      _backPressTimer = Timer(const Duration(seconds: _exitTimeInSec), () {
        _backPressTimer = null;
      });
      WidgetHelper.customSnackBar(
        context: context,
        title: 'Press back again to exit',
        color: AppColors.brown,
        isError: true,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    QuartzproductsProvider quartzProvider =
        context.watch<QuartzproductsProvider>();
    SpcProductProvider spcProvider = context.watch<SpcProductProvider>();
    // NewarrivalProvider newArrivalProvider = context.watch<NewarrivalProvider>();

    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _onWillPop();
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        cupertinoButtonTextStyle: TextStyle(color: AppColors.brown),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.homeGradient2,
            surfaceTintColor: AppColors.homeGradient2,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: CustomContainer(
              child: Image.asset(
                'assets/images/logo.png',
                height: isTablet ? 48 : 5.h,
                width: isTablet ? 140 : 20.w,
                fit: BoxFit.contain,
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
              SizedBox(width: isTablet ? 16 : 10),
            ],
          ),
          endDrawerEnableOpenDragGesture: false,
          endDrawer: DrawerWidget(),
          body: CustomContainer(
            gradient: LinearGradient(
              colors: BoxShadowHelper.homeGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            child:
                homeScreenProvider.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(color: AppColors.brown),
                    )
                    : RefreshIndicator(
                      backgroundColor: AppColors.whiteColor,
                      color: AppColors.brown,
                      onRefresh:
                          () async => initHomeScreenData(context: context),
                      child: ListView(
                        // shrinkWrap: true,
                        children: [
                          SizedBox(height: 2.h),
                          // _buildSectionTitle(title: 'Featured Products'), // hide heading as per told
                          SizedBox(height: 2.h),
                          if (homeScreenProvider
                                  .homeSliderModel
                                  ?.data
                                  ?.isNotEmpty ==
                              true)
                            CarouselSlider(
                              options: CarouselOptions(
                                height: isTablet
                                    ? (isLandscape ? 38.h : 28.h)
                                    : 25.h,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: isTablet ? 0.92 : 0.8,
                              ),
                              items:
                                  homeScreenProvider.homeSliderModel?.data?.map((
                                    item,
                                  ) {
                                    return CustomContainer(
                                      backGroundColor: AppColors.whiteColor,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 8 : 1.w,
                                        vertical: isTablet ? 1.h : 2.h,
                                      ),

                                      boxShadow: [BoxShadowHelper.shadow],
                                      borderRadius: BorderRadius.circular(
                                        AppSize.size10,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          AppSize.size10,
                                        ),
                                        child: CustomImageWithLoader(
                                          showImageInPanel: false,
                                          imageUrl:
                                              '${ApiHelper.assetsUrl}slider/${item.sliderimg}',
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            )
                          else
                            const Text("No featured products found"),
                          SizedBox(height: 2.h),

                          // Quartz Section
                          InkWell(
                            onTap: () {
                              setState(() => showAllQuartz = true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductScreen(
                                        title: "Dura Quartz Surface",
                                        url: "quartz",
                                        isSpcProduct: false,
                                      ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionTitle(
                                  title: 'DURA QUARTZ SURFACE',
                                  isTablet: isTablet,
                                ),

                                if (!showAllQuartz &&
                                    (quartzProvider
                                                .quartzProductModel
                                                ?.data
                                                ?.length ??
                                            0) >
                                        3)
                                  ViewAllBtn(),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          quartzProvider.isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.brown,
                                ),
                              )
                              : quartzProvider
                                      .quartzProductModel
                                      ?.data
                                      ?.isNotEmpty ==
                                  true
                              ? SizedBox(
                                height: isTablet
                                    ? (isLandscape ? 26.h : 20.h)
                                    : 20.h,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 1.h : 2.h,
                                    horizontal: isTablet ? 3.w : 5.w,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      showAllQuartz
                                          ? quartzProvider
                                              .quartzProductModel
                                              ?.data
                                              ?.length
                                          : ((quartzProvider
                                                          .quartzProductModel
                                                          ?.data
                                                          ?.length ??
                                                      0) >
                                                  3
                                              ? 3
                                              : quartzProvider
                                                  .quartzProductModel
                                                  ?.data
                                                  ?.length),
                                  itemBuilder: (context, index) {
                                    final ProductModel? product =
                                        quartzProvider
                                            .quartzProductModel
                                            ?.data?[index];
                                    final quartzList =
                                        quartzProvider
                                            .quartzProductModel
                                            ?.data;
                                    return GestureDetector(
                                      onTap:
                                          () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      ProductDetailsScreen(
                                                        url: "quartz",
                                                        isSpcProduct: false,
                                                        productModel: product,
                                                        products: quartzList,
                                                        initialIndex: index,
                                                        onLoadMore: (nextPage) async {
                                                          try {
                                                            final resp = await HttpHelper.get(
                                                              context: context,
                                                              uri: ApiHelper.quartzProductPagination(page: nextPage.toString()),
                                                            );
                                                            if (resp['data'] != null && resp['data']['data'] is List) {
                                                              final List<dynamic> rawList = resp['data']['data'];
                                                              return rawList
                                                                  .whereType<Map<String, dynamic>>()
                                                                  .map((m) {
                                                                    final p = ProductModel.fromJson(m, false);
                                                                    p.imageUrl = "quartz";
                                                                    return p;
                                                                  })
                                                                  .toList();
                                                            }
                                                          } catch (e) {
                                                            log("Error loading more quartz products: $e");
                                                          }
                                                          return [];
                                                        },
                                                      ),
                                            ),
                                          ),
                                      child: HomeScreenProductContainer(
                                        width: isTablet
                                            ? (isLandscape ? 32.w : 42.w)
                                            : 60.w,
                                        imageUrl:
                                            '${ApiHelper.assetsUrl}quartz/${product?.mainImg}',
                                      ),
                                    );
                                  },
                                ),
                              )
                              : const Text("No Quartz Products found."),
                          SizedBox(height: 2.h),

                          // SPC Section
                          InkWell(
                            onTap: () {
                              setState(() => showAllSpc = true);
                              // Navigate to the Product Screen for SPC
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductScreen(
                                        title: "SPC Products",
                                        isSpcProduct: true,
                                        url: "spc",
                                      ), // Navigate to ProductScreen
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionTitle(
                                  title: 'SPC FLOORING',
                                  isTablet: isTablet,
                                ),

                                if (!showAllSpc &&
                                    (spcProvider
                                                .spcProductModel
                                                ?.data
                                                ?.length ??
                                            0) >
                                        3)
                                  ViewAllBtn(),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          spcProvider.isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.brown,
                                ),
                              )
                              : spcProvider.spcProductModel?.data?.isNotEmpty ==
                                  true
                              ? SizedBox(
                                height: isTablet
                                    ? (isLandscape ? 30.h : 24.h)
                                    : 25.h,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 1.h : 2.h,
                                    horizontal: isTablet ? 3.w : 5.w,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      showAllSpc
                                          ? spcProvider
                                              .spcProductModel
                                              ?.data
                                              ?.length
                                          : ((spcProvider
                                                          .spcProductModel
                                                          ?.data
                                                          ?.length ??
                                                      0) >
                                                  3
                                              ? 3
                                              : spcProvider
                                                  .spcProductModel
                                                  ?.data
                                                  ?.length),
                                  itemBuilder: (context, index) {
                                    final ProductModel? product =
                                        spcProvider
                                            .spcProductModel
                                            ?.data?[index];
                                    final spcList =
                                        spcProvider
                                            .spcProductModel
                                            ?.data;
                                    return GestureDetector(
                                      onTap:
                                          () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      ProductDetailsScreen(
                                                        url: "spc",
                                                        isSpcProduct: true,
                                                        productModel: product,
                                                        products: spcList,
                                                        initialIndex: index,
                                                        onLoadMore: (nextPage) async {
                                                          try {
                                                            final resp = await HttpHelper.get(
                                                              context: context,
                                                              uri: ApiHelper.spcProductPagination(page: nextPage.toString()),
                                                            );
                                                            if (resp['data'] != null && resp['data']['data'] is List) {
                                                              final List<dynamic> rawList = resp['data']['data'];
                                                              return rawList
                                                                  .whereType<Map<String, dynamic>>()
                                                                  .map((m) {
                                                                    final p = ProductModel.fromJson(m, true);
                                                                    p.imageUrl = "spc";
                                                                    return p;
                                                                  })
                                                                  .toList();
                                                            }
                                                          } catch (e) {
                                                            log("Error loading more spc products: $e");
                                                          }
                                                          return [];
                                                        },
                                                      ),
                                            ),
                                          ),
                                      child: HomeScreenProductContainer(
                                        width: isTablet
                                            ? (isLandscape ? 18.w : 24.w)
                                            : null,
                                        imageUrl:
                                            '${ApiHelper.assetsUrl}spc/${product?.mainImg}',
                                      ),
                                    );
                                  },
                                ),
                              )
                              : const Text("No SPC Products found."),
                          SizedBox(height: 2.h),
                          // _buildSectionTitle(title: 'New Arrivals'),
                          // SizedBox(height: 1.h),
                          // newArrivalProvider.isLoading
                          //     ? const Center(child: CircularProgressIndicator())
                          //     : newArrivalProvider
                          //             .newArrivalModel
                          //             ?.data
                          //             ?.navigateUrl
                          //             ?.isNotEmpty ==
                          //         true
                          //     ? GestureDetector(
                          //       onTap: () async {
                          //         final String navUrl =
                          //             newArrivalProvider
                          //                 .newArrivalModel
                          //                 ?.data
                          //                 ?.navigateUrl ??
                          //             "";
                          //         if (navUrl.isEmpty) {
                          //           if (context.mounted) {
                          //             ScaffoldMessenger.of(context).showSnackBar(
                          //               const SnackBar(
                          //                 content: Text(
                          //                   "Product link not available",
                          //                 ),
                          //               ),
                          //             );
                          //           }
                          //           return;
                          //         }

                          //         try {
                          //           await newArrivalProvider
                          //               .getNewArrivalAndRedirectToProductPage(
                          //                 context: context,
                          //               );

                          //           if (!context.mounted) return;

                          //           if (newArrivalProvider.productModel == null) {
                          //             ScaffoldMessenger.of(context).showSnackBar(
                          //               const SnackBar(
                          //                 content: Text(
                          //                   "Product not found or failed to fetch.",
                          //                 ),
                          //               ),
                          //             );
                          //             return;
                          //           }

                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder:
                          //                   (_) => ProductDetailsScreen(
                          //                     productModel:
                          //                         newArrivalProvider.productModel,
                          //                     url:
                          //                         newArrivalProvider
                          //                             .newArrivalModel
                          //                             ?.data
                          //                             ?.navigateUrl ??
                          //                         "",
                          //                   ),
                          //             ),
                          //           );
                          //         } catch (e) {
                          //           debugPrint("Navigation error: $e");
                          //           if (context.mounted) {
                          //             ScaffoldMessenger.of(context).showSnackBar(
                          //               const SnackBar(
                          //                 content: Text(
                          //                   "Something went wrong during navigation.",
                          //                 ),
                          //               ),
                          //             );
                          //           }
                          //         }
                          //       },
                          //       child: CustomContainer(
                          //         height: 25.h,
                          //         margin: EdgeInsets.only(
                          //           bottom: 2.h,
                          //           left: 2.w,
                          //           right: 2.w,
                          //         ),
                          //         child: HomeScreenProductContainer(
                          //           width: 85.w,
                          //           imageUrl:
                          //               "https://argiltiles.com/${newArrivalProvider.newArrivalModel?.data?.image}",
                          //         ),
                          //       ),
                          //     )
                          //     : const Center(
                          //       child: Text('No new arrivals available.'),
                          //     ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required String title, bool isTablet = false}) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isTablet ? 22 : 18,
          fontWeight: FontWeight.bold,
          letterSpacing: isTablet ? 0.5 : null,
        ),
      ),
    );
  }
}

class HomeScreenProductContainer extends StatelessWidget {
  const HomeScreenProductContainer({
    super.key,
    required this.imageUrl,
    this.width,
  });
  final double? width;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backGroundColor: AppColors.whiteColor,
      width: width ?? 30.w,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      borderRadius: BorderRadius.circular(AppSize.size10),
      boxShadow: [BoxShadowHelper.shadow],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.size10),
        child: CustomImageWithLoader(
          imageUrl: imageUrl,
          showImageInPanel: false,
        ),
      ),
    );
  }
}

class ViewAllBtn extends StatelessWidget {
  const ViewAllBtn({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return CustomContainer(
      margin: EdgeInsets.only(right: isTablet ? 4.w : 2.w),
      borderRadius: BorderRadius.circular(AppSize.size10),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 2.w : 3.w,
        vertical: isTablet ? 0.8.h : 1.h,
      ),
      width: isTablet ? 36 : null,
      height: isTablet ? 36 : null,
      image: const DecorationImage(
        image: AssetImage("assets/images/right-arrow.png"),
        fit: BoxFit.contain,
      ),
    );
  }
}
