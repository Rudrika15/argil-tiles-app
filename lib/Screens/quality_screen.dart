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
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          title: const Text('Quality'),
          leading: const BackButton(),
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
            ),
          ],
        ),
        endDrawer: DrawerWidget(),
        body: Stack(
          children: [
            WaterMarkLogo(),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 25.h,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
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
                  const SizedBox(height: 24),
                  const Text(
                    "In the past 65 odd years of working in semi professional and professional environment, we have observed that quality is not limited to products, but to all activities that we do. From smallest of the tasks like keying in an invoice data to closing the biggest deal, quality is required at every stage and at all levels. We have some quality and standard certificates.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
