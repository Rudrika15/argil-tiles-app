import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:argil_tiles/provider/homescreen_provider.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:argil_tiles/Screens/group_company_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';

class ProductScreen extends StatelessWidget {
  final int initialTab;
  ProductScreen({super.key, this.initialTab = 0});

  final List<Map<String, String>> surfaces = [
    {'name': 'NERO MARQUINA', 'image': 'assets/images/category1.png'},
    {'name': 'GLACIAR WHITE', 'image': 'assets/images/category2.png'},
    {'name': 'CALACATTA ORO', 'image': 'assets/images/category3.png'},
    {'name': 'HIMALAYAN WHITE', 'image': 'assets/images/category4.png'},
  ];

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      endDrawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3C8BA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'DURA QUARTZ SURFACE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          const Icon(Icons.favorite_border, color: Colors.black),
          const SizedBox(width: 16),
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: surfaces.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = surfaces[index];
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(Icons.favorite_border, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            item['name']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 5,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.only(bottom: 12),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigate(BuildContext context, String key, Widget screen) {
    Provider.of<DrawerProvider>(context, listen: false).selectItem(key);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerProvider>(context);
    final selected = drawerProvider.selectedItem;

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
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
                ListTile(
                  title: const Text(
                    "Dura Quartz Surface",
                    style: TextStyle(color: Colors.white),
                  ),
                  selected: selected == "Dura Quartz Surface",
                  selectedTileColor: Colors.blue[100],
                  onTap:
                      () => _navigate(
                        context,
                        "Dura Quartz Surface",
                        const ProductDetailScreen(
                          imagePath: 'assets/images/category1.png',
                        ),
                      ),
                ),
                ListTile(
                  title: const Text(
                    "SPC Products",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            _drawerItem(
              context,
              "Favorite",
              Icons.favorite,
              'Favorite',
              const FavoriteScreen(),
            ),
            ExpansionTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text(
                "Corporate",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                _drawerItem(
                  context,
                  "Group Company",
                  null,
                  'Group Company',
                  GroupCompanyScreen(),
                ),
                _drawerItem(
                  context,
                  "Achievements",
                  null,
                  'Achievements',
                  const AchievementsScreen(),
                ),
                _drawerItem(
                  context,
                  "Quality",
                  null,
                  'Quality',
                  const QualityScreen(),
                ),
                _drawerItem(
                  context,
                  "Company Profile",
                  null,
                  'Company Profile',
                  const CompanyProfileScreen(),
                ),
              ],
            ),
            _drawerItem(
              context,
              "About",
              Icons.info,
              'About Us',
              const AboutScreen(),
            ),
            _drawerItem(
              context,
              "Contact",
              Icons.contact_mail,
              'Contact Us',
              const ContactUsScreen(),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                drawerProvider.selectItem("Logout");
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
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
                                  builder: (context) => const SplashScreen(),
                                ),
                              );
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    String key,
    IconData? icon,
    String text,
    Widget screen,
  ) {
    final isSelected = Provider.of<DrawerProvider>(context).selectedItem == key;
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.white) : null,
      title: Text(text, style: const TextStyle(color: Colors.white)),
      selected: isSelected,
      selectedTileColor: Colors.blue[100],
      onTap: () => _navigate(context, key, screen),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String imagePath;
  const ProductDetailScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: Center(child: Image.asset(imagePath)),
    );
  }
}
