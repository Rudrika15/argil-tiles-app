import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/sevices/gradient_helper.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/custom_container.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          title: const Text('Achievements'),
          leading: const BackButton(),
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
            ),
          ],
        ),
        endDrawer: DrawerWidget(),
        body: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/logo_triangle.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 25.h,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items:
                        [
                          'assets/images/archievement1.png',
                          'assets/images/archievement2.png',
                        ].map((imagePath) {
                          return CustomContainer(
                            backGroundColor: AppColors.whiteColor,
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                            boxShadow: [GradientHelper.shadow],
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSize.size10,
                              ),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 2.h),
                  Image.asset('assets/images/award.png', height: 15.h),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "National Award for the year 1997 (for best quality products) from vice president of India\nNational Award",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "The Founder has been in the business since last 60 years within which he has scaled new heights regularly. He has been recognized a number of times and mostly by credible institutions including the Government of India.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
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
