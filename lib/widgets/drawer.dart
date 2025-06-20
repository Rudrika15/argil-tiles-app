import 'package:argil_tiles/provider/auth_provider.dart';
import 'package:argil_tiles/provider/quartzproducts_provider.dart';
import 'package:argil_tiles/provider/spcproducts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../Screens/about_screen.dart';
import '../Screens/achievements_screen.dart';
import '../Screens/company_profile_screen.dart';
import '../Screens/contact_us_screen.dart';
import '../Screens/favourite_screen.dart';
import '../Screens/group_company_screen.dart';
import '../Screens/login_screen.dart';
import '../Screens/product_screen.dart';
import '../Screens/quality_screen.dart';
import '../app_const/app_color.dart';
import '../widgets/drawer_item.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SpcProductProvider spcProductProvider = context.watch<SpcProductProvider>();
    AuthProvider authProvider = context.watch<AuthProvider>();
    QuartzproductsProvider quartzproductsProvider =
        context.watch<QuartzproductsProvider>();
    return Drawer(
      width: 60.w,
      backgroundColor: AppColors.blackColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 10.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          ExpansionTile(
            iconColor: AppColors.whiteColor,
            leading: const Icon(Icons.category, color: Colors.white),
            title: const Text(
              "Products",
              style: TextStyle(color: AppColors.whiteColor),
            ),
            children: [
              DrawerItem(
                title: "Dura Quartz Surface",

                icon: null,
                index: 1,
                screen: ProductScreen(
                  title: "Dura Quartz Surface",
                  url: "quartz",
                  products:
                      quartzproductsProvider.quartzProductModel?.data ?? [],
                ),
              ),
              DrawerItem(
                title: "SPC Products",

                icon: null,
                index: 2,
                screen: ProductScreen(
                  title: "SPC Products",
                  url: "spc",
                  products: spcProductProvider.spcProductModel?.data ?? [],
                ),
              ),
            ],
          ),
          DrawerItem(
            title: "Favorite",
            icon: Icons.favorite_border,
            index: 3,
            screen: FavoriteScreen(),
          ),
          ExpansionTile(
            iconColor: AppColors.whiteColor,
            leading: const Icon(Icons.business, color: AppColors.whiteColor),
            title: const Text(
              "Corporate",
              style: TextStyle(color: AppColors.whiteColor),
            ),
            children: [
              DrawerItem(
                title: "Group Company",
                icon: null,
                index: 4,
                screen: GroupCompanyScreen(),
              ),
              DrawerItem(
                title: "Achievements",
                icon: null,
                index: 5,
                screen: AchievementsScreen(),
              ),
              DrawerItem(
                title: "Quality",
                icon: null,
                index: 6,
                screen: QualityScreen(),
              ),
              DrawerItem(
                title: "Company Profile",

                icon: null,
                index: 7,
                screen: CompanyProfileScreen(),
              ),
            ],
          ),
          DrawerItem(
            title: "About Us",

            icon: Icons.info,
            index: 8,
            screen: AboutScreen(),
          ),
          DrawerItem(
            icon: Icons.contact_mail,
            index: 9,
            title: "Contact Us",
            screen: ContactUsScreen(),
          ),
          DrawerItem(
            icon: authProvider.isAdminLoggedIn ? Icons.logout : Icons.login,
            index: 10,
            title: authProvider.isAdminLoggedIn ? "Logout" : "Login",
            screen: LoginPage(),
            shouldPushRemove: authProvider.isAdminLoggedIn,
          ),
        ],
      ),
    );
  }
}
