import 'package:argil_tiles/Screens/product_details_screen.dart';
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
        backgroundColor: const Color(0xFFD3C8BA),
        surfaceTintColor: const Color(0xFFD3C8BA),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD3C8BA), Color.fromRGBO(244, 243, 241, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 1.0],
          ),
        ),
        child:
            homeScreenProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Featured Products'),
                        const SizedBox(height: 8),
                        if (homeScreenProvider.homeItems?.isNotEmpty == true)
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            items:
                                homeScreenProvider.homeItems!.map((item) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          'https://admin.argiltiles.com/public/slider/${item.sliderimg}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
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
                            Text(
                              'Quartz Products',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!showAllQuartz &&
                                quartzProvider.products!.length > 5)
                              TextButton(
                                onPressed: () {
                                  setState(() => showAllQuartz = true);
                                  // Navigate to the Product Screen for Quartz
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ProductScreen(), // Assuming ProductScreen is the target
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        quartzProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : quartzProvider.products?.isNotEmpty == true
                            ? SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    showAllQuartz
                                        ? quartzProvider.products!.length
                                        : (quartzProvider.products!.length > 5
                                            ? 5
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
                                                (context) =>
                                                    ProductDetailsScreen(
                                                      url: "quartz",
                                                      productModel: product,
                                                    ),
                                          ),
                                        ),
                                    child: Container(
                                      width: 120,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://admin.argiltiles.com/public/quartz/${product.mainImg}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            : const Text("No Quartz Products found."),
                        const SizedBox(height: 16),

                        // SPC Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SPC Products',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!showAllSpc && spcProvider.products!.length > 5)
                              TextButton(
                                onPressed: () {
                                  setState(() => showAllSpc = true);
                                  // Navigate to the Product Screen for SPC
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ProductScreen(), // Navigate to ProductScreen
                                    ),
                                  );
                                },
                                child: Text(
                                  "View All",
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        spcProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : spcProvider.products?.isNotEmpty == true
                            ? SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    showAllSpc
                                        ? spcProvider.products!.length
                                        : (spcProvider.products!.length > 5
                                            ? 5
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
                                                (context) =>
                                                    ProductDetailsScreen(
                                                      url: "spc",
                                                      productModel: product,
                                                    ),
                                          ),
                                        ),
                                    child: Container(
                                      width: 120,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://admin.argiltiles.com/public/spc/${product.mainImg}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            : const Text("No SPC Products found."),

                        const SizedBox(height: 16),

                        _buildSectionTitle('New Arrivals'),
                        const SizedBox(height: 8),
                        newArrivalProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : newArrivalProvider
                                    .newArrivals
                                    ?.data
                                    ?.isNotEmpty ==
                                true
                            ? SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    newArrivalProvider
                                        .newArrivals!
                                        .data!
                                        .length,
                                itemBuilder: (context, index) {
                                  final ProductModel item =
                                      newArrivalProvider
                                          .newArrivals!
                                          .data![index];
                                  debugPrint(item.names);
                                  return GestureDetector(
                                    onTap:
                                        () => push(
                                          context: context,
                                          widget: ProductDetailsScreen(
                                            productModel: item,
                                            url:
                                                newArrivalProvider
                                                    .newArrivals
                                                    ?.url ??
                                                "",
                                          ),
                                        ),
                                    child: Container(
                                      width: 140,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            "https://admin.argiltiles.com/${newArrivalProvider.newArrivals?.url}/${item.mainImg}",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
