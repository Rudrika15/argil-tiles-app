import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/Screens/group_company_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        leading: const BackButton(),
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
      endDrawer: Container(
        color: Colors.white,
        child: const SizedBox(
          width: 250, // You can adjust this width
          child: AppDrawer(),
        ),
      ),
      body: Stack(
        children: [
          // Background watermark logo
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
          // Foreground content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset('assets/images/award.png', height: 120),
                const SizedBox(height: 16),
                const Text(
                  "National Award for the year 1997 (for best quality products) from vice president of India\nNational Award",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Text(
                  "The Founder has been in the business since last 60 years within which he has scaled new heights regularly. He has been recognized a number of times and mostly by credible institutions including the Government of India.",
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
    DrawerProvider drawerProvider = context.watch<DrawerProvider>();

    return Drawer(
      child: Container(
        color: Colors.black, // Set your sidebar background color here
        child: ListView(
          padding: EdgeInsets.zero,
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
              title: const Text("Products", style: TextStyle(color: Colors.white)),
              children: [
                ListTile(title: const Text("Dura Quartz Surface", style: TextStyle(color: Colors.white)), onTap: () {}),
                ListTile(title: const Text("SPC Products", style: TextStyle(color: Colors.white)), onTap: () {}),
              ],
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.favorite,
              text: 'Favorite',
              onTap: () {
                drawerProvider.selectItem('Favorite');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                );
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text("Corporate", style: TextStyle(color: Colors.white)),
              children: [
                ListTile(
                  title: const Text("Group Company", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    drawerProvider.selectItem('Group Company');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GroupCompanyScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Archievements", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    drawerProvider.selectItem('Archievements');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Quality", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    drawerProvider.selectItem('Quality');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QualityScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Company Profile", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    drawerProvider.selectItem('Company Profile');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CompanyProfileScreen()),
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
                drawerProvider.selectItem('About Us');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            _createDrawerItem(
              context: context,
              icon: Icons.contact_mail,
              text: 'Contact Us',
              onTap: () {
                drawerProvider.selectItem('Contact Us');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
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

  Widget _createDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final selectedItem = context.watch<DrawerProvider>().selectedItem;
    final isSelected = selectedItem == text;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.white),
      title: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
