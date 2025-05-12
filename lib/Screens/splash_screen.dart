import 'dart:async';
import 'package:argil_tiles/Screens/HomeScreen.dart';
import 'package:argil_tiles/app_const/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/method_helper/gradient_helper.dart';
import '../widgets/custom_container.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Trigger fade-in animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Optionally navigate after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        gradient: LinearGradient(
          colors: BoxShadowHelper.splashScreenGradient,
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _opacity,
          curve: Curves.easeIn,
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo_transparent_triangle.png",
                  color: Colors.brown.shade100.withOpacity(0.1),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40.w,
                  height: 15.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
