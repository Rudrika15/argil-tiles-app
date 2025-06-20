import 'dart:async';
import 'package:argil_tiles/Screens/HomeScreen.dart';
import 'package:argil_tiles/Screens/dashboard_screen.dart';
import 'package:argil_tiles/Screens/login_screen.dart';
import 'package:argil_tiles/provider/auth_provider.dart';
import 'package:argil_tiles/utils/shared_preference/shared_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utils/method_helper/gradient_helper.dart';
import '../widgets/custom_container.dart';

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
    // start
    Future.delayed(Duration(seconds: 3), () => redirectUserToScreen());
  }

  /// check if token than to dashboard, if both empty
  void redirectUserToScreen() async {
    final String token = await SharedPrefs.getToken();
    final String visited = await SharedPrefs.getString(key: "visited");
    if (token.isNotEmpty) {
      context.read<AuthProvider>().setAdminLoginStatus(
        status: token.isNotEmpty,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else if (token.isEmpty && visited.isEmpty) {
      await SharedPrefs.saveString(key: "visited", value: "visited");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
