import 'package:argil_tiles/Screens/product_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';


class QualityScreen extends StatelessWidget {
  const QualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality'),
        leading: const BackButton(),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      endDrawer: Container(
        color: Colors.white,
        child: const SizedBox(
          width: 250, // You can adjust this width
          child: AppDrawer(),
        ),
      ),

      body: Stack(
        children: [
          // Background watermark image
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

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset('assets/images/iso.png', height: 120),
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
            SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.asset(
                  'assets/images/logo.png', // Update if your path is different
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.category),
              title: const Text("Products"),
              children: [
                ListTile(
                  title: const Text("Dura Quartz Surface"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("SPC Products"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductScreen()),
                    );
                  },
                ),
              ],
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.favorite,
              text: 'Favorite',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.business),
              title: const Text("Corporate"),
              children: [
                ListTile(
                  title: const Text("Group Company"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Achievements"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AchievementsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Quality"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QualityScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Company Profile"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.info,
              text: 'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.contact_mail,
              text: 'Contact Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()),
                );
              },
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
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
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          SplashScreen(), 
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

  Widget _createDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(text), onTap: onTap);
  }
}
