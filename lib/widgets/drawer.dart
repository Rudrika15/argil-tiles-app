import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../Screens/about_screen.dart';
import '../Screens/achievements_screen.dart';
import '../Screens/company_profile_screen.dart';
import '../Screens/contact_us_screen.dart';
import '../Screens/favourite_screen.dart';
import '../Screens/group_company_screen.dart';
import '../Screens/product_screen.dart';
import '../Screens/quality_screen.dart';
import '../app_const/app_color.dart';
import '../widgets/drawer_item.dart';
import 'custom_container.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 60.w,
      backgroundColor: const Color(0xFFF5F5F5),
      child: CustomContainer(
        backGroundColor: AppColors.blackColor,
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
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text(
                "Products",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                DrawerItem(
                  title: "Dura Quartz Surface",

                  icon: null,
                  index: 1,
                  screen: ProductScreen(),
                ),
                DrawerItem(
                  title: "SPC Products",

                  icon: null,
                  index: 2,
                  screen: ProductScreen(),
                ),
              ],
            ),
            DrawerItem(
              title: "Favourite",

              icon: Icons.favorite_border,
              index: 3,
              screen: FavoriteScreen(),
            ),
            ExpansionTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text(
                "Corporate",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                DrawerItem(
                  title: "Group Company",

                  icon: Icons.favorite_border,
                  index: 4,
                  screen: GroupCompanyScreen(),
                ),
                DrawerItem(
                  title: "Achievements",

                  icon: Icons.favorite_border,
                  index: 5,
                  screen: AchievementsScreen(),
                ),
                DrawerItem(
                  title: "Quality",

                  icon: Icons.favorite_border,
                  index: 6,
                  screen: QualityScreen(),
                ),
                DrawerItem(
                  title: "Company Profile",

                  icon: Icons.favorite_border,
                  index: 7,
                  screen: CompanyProfileScreen(),
                ),
              ],
            ),
            DrawerItem(
              title: "About Us",

              icon: Icons.info,
              index: 4,
              screen: AboutScreen(),
            ),
            DrawerItem(
              icon: Icons.contact_mail,
              index: 5,
              title: "Contact Us",
              screen: ContactUsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
