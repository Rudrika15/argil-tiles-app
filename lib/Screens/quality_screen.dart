import 'package:argil_tiles/provider/homescreen_provider.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:argil_tiles/Screens/group_company_screen.dart';
import 'package:argil_tiles/Screens/product_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';

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
            Center(
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180.0,
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _setSelected(BuildContext context, String item, Widget screen) {
    Provider.of<DrawerProvider>(context, listen: false).selectItem(item);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<DrawerProvider>(context).selectedItem;

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.asset('assets/images/logo.png', height: 80),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text(
                "Products",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                _buildTile(
                  context,
                  "dura",
                  "Dura Quartz Surface",
                  ProductScreen(),
                  selected,
                ),
                _buildTile(
                  context,
                  "spc",
                  "SPC Products",
                  ProductScreen(),
                  selected,
                ),
              ],
            ),
            _buildTile(
              context,
              "favorite",
              "Favorite",
              const FavoriteScreen(),
              selected,
              icon: Icons.favorite,
            ),
            ExpansionTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text(
                "Corporate",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                _buildTile(
                  context,
                  "group",
                  "Group Company",
                  GroupCompanyScreen(),
                  selected,
                ),
                _buildTile(
                  context,
                  "achievements",
                  "Achievements",
                  const AchievementsScreen(),
                  selected,
                ),
                _buildTile(
                  context,
                  "quality",
                  "Quality",
                  const QualityScreen(),
                  selected,
                ),
                _buildTile(
                  context,
                  "profile",
                  "Company Profile",
                  const CompanyProfileScreen(),
                  selected,
                ),
              ],
            ),
            _buildTile(
              context,
              "about",
              "About Us",
              const AboutScreen(),
              selected,
              icon: Icons.info,
            ),
            _buildTile(
              context,
              "contact",
              "Contact Us",
              const ContactUsScreen(),
              selected,
              icon: Icons.contact_mail,
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Provider.of<DrawerProvider>(
                  context,
                  listen: false,
                ).selectItem("logout");
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content: const Text(
                          "Are you sure you want to log out?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SplashScreen(),
                                ),
                              );
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                );
              },
              selected: selected == "logout",
              selectedTileColor: Colors.blue[100],
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildTile(
    BuildContext context,
    String id,
    String title,
    Widget screen,
    String selected, {
    IconData? icon,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.white) : null,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      selected: selected == id,
      selectedTileColor: Colors.blue[100],
      onTap: () => _setSelected(context, id, screen),
    );
  }
}
