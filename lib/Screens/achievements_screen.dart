import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/utils/size_helper/size_helper.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:argil_tiles/widgets/water_mark_logo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/method_helper/gradient_helper.dart';
import '../widgets/custom_container.dart';
import 'dart:async';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/images/archievement1.png',
    'assets/images/archievement2.png',
  ];

  final List<String> message = [
    "National Award for the year 1997 (for best quality products) from vice president of India\nNational Award",
    "Highest Export Awards, Govt. of India and State",
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % imagePaths.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

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
            WaterMarkLogo(),
            ListView(
              children: [
                SizedBox(height: 2.h),
                SizedBox(
                  height: 40.h,
                  child: PageView.builder(
                    controller: _pageController,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          CustomContainer(
                            backGroundColor: AppColors.whiteColor,
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                            boxShadow: [BoxShadowHelper.shadow],
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSize.size10,
                              ),
                              child: Image.asset(
                                imagePaths[index],
                                fit: BoxFit.contain,
                                height: 20.h,
                              ),
                            ),
                          ),
                          SizeHelper.height(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              message[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}
