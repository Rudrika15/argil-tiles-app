import 'dart:async';
import 'package:argil_tiles/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/method_helper/gradient_helper.dart';
import '../widgets/custom_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
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
          colors: BoxShadowHelper.homeGradient,
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
        child: Stack(
          children: [
            // Centered Logo
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
    );
  }
}
