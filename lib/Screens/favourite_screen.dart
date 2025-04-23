import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/group_company_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, String>> favorites = [
    {'name': 'NERO MARQUINA', 'image': 'assets/images/category1.png'},
    {'name': 'GLACIAR WHITE', 'image': 'assets/images/category2.png'},
    {'name': 'CALACATTA ORO', 'image': 'assets/images/category3.png'},
    {'name': 'HIMALAYAN WHITE', 'image': 'assets/images/category4.png'},
  ];

  void removeFavorite(int index) {
    setState(() {
      favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const SizedBox(width: 200, child: AppDrawer()),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite items yet!",
                style: TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item['image']!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => removeFavorite(index),
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          color: Colors.black.withOpacity(0.6),
                          child: Text(
                            item['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerProvider>(context);

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text("Products", style: TextStyle(color: Colors.white)),
              children: [
                _drawerItem(
                  context,
                  icon: Icons.circle,
                  text: 'Dura Quartz Surface',
                  onTap: () {},
                ),
                _drawerItem(
                  context,
                  icon: Icons.circle,
                  text: 'SPC Products',
                  onTap: () {},
                ),
              ],
            ),
            _drawerItem(
              context,
              icon: Icons.favorite,
              text: 'Favorite',
              onTap: () {
                drawerProvider.selectItem('Favorite');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoriteScreen()),
                );
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text("Corporate", style: TextStyle(color: Colors.white)),
              children: [
                _drawerItem(
                  context,
                  icon: Icons.circle,
                  text: 'Group Company',
                  onTap: () {
                    drawerProvider.selectItem('Group Company');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GroupCompanyScreen()),
                    );
                  },
                ),
                _drawerItem(
                  context,
                  icon: Icons.circle,
                  text: 'Achievements',
                  onTap: () {
                    drawerProvider.selectItem('Achievements');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AchievementsScreen()),
                    );
                  },
                ),
                _drawerItem(
                  context,
                  icon: Icons.circle,
                  text: 'Quality',
                  onTap: () {
                    drawerProvider.selectItem('Quality');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QualityScreen()),
                    );
                  },
                ),
                _drawerItem(
                  context,
                  icon: Icons.circle,
                  text: 'Company Profile',
                  onTap: () {
                    drawerProvider.selectItem('Company Profile');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CompanyProfileScreen()),
                    );
                  },
                ),
              ],
            ),
            _drawerItem(
              context,
              icon: Icons.info,
              text: 'About Us',
              onTap: () {
                drawerProvider.selectItem('About Us');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutScreen()),
                );
              },
            ),
            _drawerItem(
              context,
              icon: Icons.contact_mail,
              text: 'Contact Us',
              onTap: () {
                drawerProvider.selectItem('Contact Us');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ContactUsScreen()),
                );
              },
            ),
            _drawerItem(
              context,
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to log out?"),
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
                            MaterialPageRoute(builder: (_) => const SplashScreen()),
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
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final drawerProvider = Provider.of<DrawerProvider>(context);
    final isSelected = drawerProvider.selectedItem == text;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.amber : Colors.white),
      title: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.amber : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.white12 : Colors.transparent,
      onTap: () {
        drawerProvider.selectItem(text);
        onTap();
      },
    );
  }
}
