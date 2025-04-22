import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  // List to store the favorite items locally (using names and image paths as placeholder)
  List<Map<String, String>> favorites = [
    {'name': 'NERO MARQUINA', 'image': 'assets/images/category1.png'},
    {'name': 'GLACIAR WHITE', 'image': 'assets/images/category2.png'},
    {'name': 'CALACATTA ORO', 'image': 'assets/images/category3.png'},
    {'name': 'HIMALAYAN WHITE', 'image': 'assets/images/category4.png'},
  ];

  // Method to remove a favorite item
  void removeFavorite(int index) {
    setState(() {
      favorites.removeAt(index);
    });
  }

  // Method to add a new item to the favorites list
  void addFavorite(Map<String, String> item) {
    setState(() {
      favorites.add(item);
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
              leading: const Icon(Icons.category),
              title: const Text("Products"),
              children: [
                ListTile(title: const Text("Dura Quartz Surface"), onTap: () {}),
                ListTile(title: const Text("SPC Products"), onTap: () {}),
              ],
            ),
            _drawerItem(
              context,
              icon: Icons.favorite,
              text: 'Favorite',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoriteScreen()),
                );
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.business),
              title: const Text("Corporate"),
              children: [
                ListTile(
                  title: const Text("Group Company"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  ),
                ),
                ListTile(
                  title: const Text("Achievements"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                  ),
                ),
                ListTile(
                  title: const Text("Quality"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QualityScreen()),
                  ),
                ),
                ListTile(
                  title: const Text("Company Profile"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CompanyProfileScreen()),
                  ),
                ),
              ],
            ),
            _drawerItem(
              context,
              icon: Icons.info,
              text: 'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            _drawerItem(
              context,
              icon: Icons.contact_mail,
              text: 'Contact Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
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
                            MaterialPageRoute(builder: (context) => const SplashScreen()),
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
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
