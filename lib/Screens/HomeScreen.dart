import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/model/common_product_model.dart';
import 'package:argil_tiles/provider/newarraival_provider.dart';
import 'package:argil_tiles/utils/navigation_helper/navigation_helper.dart';
import 'package:argil_tiles/widgets/custom_container.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../provider/homescreen_provider.dart';
import '../provider/quartzproducts_provider.dart';
import '../provider/spcproducts_provider.dart';
import '../Screens/favourite_screen.dart';
import '../Screens/product_screen.dart';
import '../utils/method_helper/gradient_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with NavigateHelper {
  bool showAllQuartz = false;
  bool showAllSpc = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeScreenProvider>().loadHomeScreenData();
      context.read<QuartzproductsProvider>().loadQuartzProducts();
      context.read<SpcProductProvider>().loadSpcProducts();
      context.read<NewarrivalProvider>().fetchNewArrivals();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    QuartzproductsProvider quartzProvider =
        context.watch<QuartzproductsProvider>();
    SpcProductProvider spcProvider = context.watch<SpcProductProvider>();
    NewarrivalProvider newArrivalProvider = context.watch<NewarrivalProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        surfaceTintColor: AppColors.appBar,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: CustomContainer(
          child: Image.asset(
            'assets/images/logo.png',
            height: 5.h,
            width: 20.w,
          ),
        ),
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
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.blackColor),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      endDrawer: DrawerWidget(),
      body: CustomContainer(
        gradient: LinearGradient(
          colors: BoxShadowHelper.homeGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        child:
            homeScreenProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      _buildSectionTitle(title: 'Featured Products'),
                      SizedBox(height: 2.h),
                      if (homeScreenProvider.homeItems?.isNotEmpty == true)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 25.h,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                          items:
                              homeScreenProvider.homeItems!.map((item) {
                                return CustomContainer(
                                  backGroundColor: AppColors.whiteColor,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 1.w,
                                    vertical: 2.h,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://admin.argiltiles.com/public/slider/${item.sliderimg}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [BoxShadowHelper.shadow],
                                  borderRadius: BorderRadius.circular(
                                    AppSize.size10,
                                  ),
                                );
                              }).toList(),
                        )
                      else
                        const Text("No featured products found"),
                      SizedBox(height: 2.h),

                      // Quartz Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle(title: 'Quartz Products'),

                          if (!showAllQuartz &&
                              quartzProvider.products!.length > 3)
                            ViewAllBtn(
                              onTap: () {
                                setState(() => showAllQuartz = true);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductScreen(
                                          title: "Dura Quartz Surface",
                                          url: "quartz",
                                          products:
                                              quartzProvider.products ?? [],
                                        ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      quartzProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : quartzProvider.products?.isNotEmpty == true
                          ? SizedBox(
                            height: 25.h,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 5.w,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  showAllQuartz
                                      ? quartzProvider.products?.length
                                      : ((quartzProvider.products?.length ??
                                                  0) >
                                              3
                                          ? 3
                                          : quartzProvider.products!.length),
                              itemBuilder: (context, index) {
                                final ProductModel product =
                                    quartzProvider.products![index];
                                return GestureDetector(
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ProductDetailsScreen(
                                                url: "quartz",
                                                productModel: product,
                                              ),
                                        ),
                                      ),
                                  child: HomeScreenProductContainer(
                                    imageUrl:
                                        'https://admin.argiltiles.com/public/quartz/${product.mainImg}',
                                  ),
                                );
                              },
                            ),
                          )
                          : const Text("No Quartz Products found."),
                      SizedBox(height: 2.h),

                      // SPC Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle(title: 'SPC Products'),

                          if (!showAllSpc && spcProvider.products!.length > 3)
                            ViewAllBtn(
                              onTap: () {
                                setState(() => showAllSpc = true);
                                // Navigate to the Product Screen for SPC
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductScreen(
                                          title: "SPC Products",
                                          url: "spc",
                                          products: spcProvider.products ?? [],
                                        ), // Navigate to ProductScreen
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      spcProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : spcProvider.products?.isNotEmpty == true
                          ? SizedBox(
                            height: 25.h,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 5.w,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  showAllSpc
                                      ? spcProvider.products!.length
                                      : (spcProvider.products!.length > 3
                                          ? 3
                                          : spcProvider.products!.length),
                              itemBuilder: (context, index) {
                                final ProductModel product =
                                    spcProvider.products![index];
                                return GestureDetector(
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ProductDetailsScreen(
                                                url: "spc",
                                                productModel: product,
                                              ),
                                        ),
                                      ),
                                  child: HomeScreenProductContainer(
                                    imageUrl:
                                        'https://admin.argiltiles.com/public/spc/${product.mainImg}',
                                  ),
                                );
                              },
                            ),
                          )
                          : const Text("No SPC Products found."),
                      SizedBox(height: 2.h),
                      _buildSectionTitle(title: 'New Arrivals'),
                      SizedBox(height: 1.h),
                      newArrivalProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : newArrivalProvider.newArrivals?.data?.isNotEmpty ==
                              true
                          ? SizedBox(
                            height: 25.h,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 5.w,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  newArrivalProvider.getProductList().length,
                              itemBuilder: (listContext, index) {
                                final ProductModel item =
                                    newArrivalProvider
                                        .newArrivals!
                                        .data![index];
                                debugPrint(item.names);
                                return GestureDetector(
                                  onTap: () async {
                                    final navUrl =
                                        newArrivalProvider.navigateUrl;

                                    if (navUrl == null || navUrl.isEmpty) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Product link not available",
                                            ),
                                          ),
                                        );
                                      }
                                      return;
                                    }

                                    try {
                                      final product =
                                          await newArrivalProvider
                                              .getNewArrivalAndRedirectToProductPage();

                                      if (!context.mounted) return;

                                      if (product == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Product not found or failed to fetch.",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => ProductDetailsScreen(
                                                productModel: product,
                                                url:
                                                    newArrivalProvider
                                                        .newArrivals
                                                        ?.url ??
                                                    "",
                                              ),
                                        ),
                                      );
                                    } catch (e) {
                                      debugPrint("Navigation error: $e");
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Something went wrong during navigation.",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },

                                  child: HomeScreenProductContainer(
                                    width: 85.w,
                                    imageUrl:
                                        "https://admin.argiltiles.com/${newArrivalProvider.newArrivals?.url}/${item.mainImg}",
                                  ),
                                );
                              },
                            ),
                          )
                          : const Center(
                            child: Text('No new arrivals available.'),
                          ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildSectionTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
    );
  }
}

class ViewAllBtn extends StatelessWidget {
  const ViewAllBtn({super.key, required this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        margin: EdgeInsets.only(right: 2.w),
        // backGroundColor: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppSize.size10),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        image: DecorationImage(
          image: AssetImage("assets/images/right-arrow.png"),
        ),
      ),
    );
  }
}
