import 'package:argil_tiles/utils/widget_helper/widhet_helper.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:argil_tiles/widgets/water_mark_logo.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';

class QualityScreen extends StatelessWidget {
  const QualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          surfaceTintColor: const Color(0xFFD3C8BA),
          leading: BackButton(
            style: ButtonStyle(
              iconSize: WidgetStatePropertyAll(isTablet ? 26 : 22),
            ),
          ),
          title: Text(
            'Quality',
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
                    ),
                    onPressed: () => WidgetHelper.openEndDrawerSafely(context),
                  ),
            ),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: const DrawerWidget(),
        body: Stack(
          children: [
            const WaterMarkLogo(),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 780 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 28.0 : 16.0),
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: isTablet ? 36.h : 25.h,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: isTablet ? 0.75 : 0.9,
                          aspectRatio: 16 / 9,
                          autoPlayInterval: const Duration(seconds: 3),
                        ),
                        items:
                            [
                              'assets/images/quality1.png',
                              'assets/images/quality2.png',
                              'assets/images/quality3.png',
                            ].map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 2.h),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      Text(
                        "In the past 65 odd years of working in semi professional and professional environment, we have observed that quality is not limited to products, but to all activities that we do. From smallest of the tasks like keying in an invoice data to closing the biggest deal, quality is required at every stage and at all levels. We have some quality and standard certificates.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 17 : 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
