import 'dart:async';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/utils/widget_helper/widhet_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';

class NoConnectionPage extends StatefulWidget {
  final VoidCallback onRetry;
  const NoConnectionPage({super.key, required this.onRetry});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  Timer? _backPressTimer;
  static const int _exitTimeInSec = 2;
  @override
  void dispose() {
    _backPressTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_backPressTimer == null || !_backPressTimer!.isActive) {
      _backPressTimer = Timer(const Duration(seconds: _exitTimeInSec), () {
        _backPressTimer = null;
      });

      WidgetHelper.customSnackBar(
        context: context,
        title: 'Press back again to exit',
        isError: true,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: AppColors.homeGradient3,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie Animation
                  Lottie.asset(
                    'assets/animations/no_internet.json',
                    width: 60.w,
                    height: 40.h,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: 2.h),

                  // Title
                  Text(
                    "No Internet Connection",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  // Subtitle
                  Text(
                    "Please check your network settings and try again.",
                    style: GoogleFonts.poppins(
                      fontSize: AppSize.size20,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 3.h),

                  // Retry Button
                  ElevatedButton(
                    onPressed: widget.onRetry,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                      ),
                      backgroundColor: AppColors.brown,
                      textStyle: GoogleFonts.poppins(fontSize: AppSize.size20),
                    ),
                    child: const Text(
                      "Back Home",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
