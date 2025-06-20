import 'package:argil_tiles/Screens/HomeScreen.dart';
import 'package:argil_tiles/Screens/dashboard_screen.dart';
import 'package:argil_tiles/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/homescreen_provider.dart';

class PopAndRedirectToHome extends StatelessWidget {
  const PopAndRedirectToHome({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    AuthProvider authProvider = context.watch<AuthProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          homeScreenProvider.setSelectedIndex = 0;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      authProvider.isAdminLoggedIn
                          ? DashboardPage()
                          : HomeScreen(),
            ),
            (route) => false,
          );
        }
      },
      child: child,
    );
  }
}
