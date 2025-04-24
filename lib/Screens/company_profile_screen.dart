import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/Screens/group_company_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3C8BA),
        title: const Text('Company Profile'),
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
      endDrawer: const SizedBox(
        width: 250,
        child: AppDrawer(),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/logo.png',
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 100,
                ),
                SizedBox(height: 24),
                Text(
                  "Argil, where we have travelled from Tradition to technology, we feel the journey is growing longer and better with every passing day. We have always respected our traditions and culture and have whole heartedly embraced technology to take us forward without any exceptions. May this journey be never ending and always challenging us to soar greater height of success and achievement. The management of Argil has always accomplished the big goals set out by us together. Unarguably, they have done it with ethics and moral of our community. Throughout their journey they have upheld the principles of sharing the growth with all stakeholders, leaving faces smiling and hearts warm with affection and respect for the brand. I would like to congratulate you on the same and motivate you to always be this humble and serving to your brand and people associated.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14, height: 1.5),
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

  void _selectItem(BuildContext context, String itemName, VoidCallback navigate) {
    context.read<DrawerProvider>().selectItem(itemName);
    Navigator.pop(context);
    navigate();
  }

  bool _isSelected(BuildContext context, String itemName) {
    return context.watch<DrawerProvider>().selectedItem == itemName;
  }

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
                _drawerItem(
                  context: context,
                  text: 'Dura Quartz Surface',
                  isSelected: _isSelected(context, 'Dura Quartz'),
                  onTap: () => _selectItem(context, 'Dura Quartz', () {}),
                ),
                _drawerItem(
                  context: context,
                  text: 'SPC Products',
                  isSelected: _isSelected(context, 'SPC Products'),
                  onTap: () => _selectItem(context, 'SPC Products', () {}),
                ),
              ],
            ),
            _drawerItem(
              context: context,
              icon: Icons.favorite,
              text: 'Favorite',
              isSelected: _isSelected(context, 'Favorite'),
              onTap: () => _selectItem(context, 'Favorite', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteScreen()));
              }),
            ),
            ExpansionTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text("Corporate", style: TextStyle(color: Colors.white)),
              children: [
                _drawerItem(
                  context: context,
                  text: 'Group Company',
                  isSelected: _isSelected(context, 'Group Company'),
                  onTap: () => _selectItem(context, 'Group Company', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => GroupCompanyScreen()));
                  }),
                ),
                _drawerItem(
                  context: context,
                  text: 'Achievements',
                  isSelected: _isSelected(context, 'Achievements'),
                  onTap: () => _selectItem(context, 'Achievements', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AchievementsScreen()));
                  }),
                ),
                _drawerItem(
                  context: context,
                  text: 'Quality',
                  isSelected: _isSelected(context, 'Quality'),
                  onTap: () => _selectItem(context, 'Quality', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => QualityScreen()));
                  }),
                ),
                _drawerItem(
                  context: context,
                  text: 'Company Profile',
                  isSelected: _isSelected(context, 'Company Profile'),
                  onTap: () => _selectItem(context, 'Company Profile', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanyProfileScreen()));
                  }),
                ),
              ],
            ),
            _drawerItem(
              context: context,
              icon: Icons.info,
              text: 'About Us',
              isSelected: _isSelected(context, 'About Us'),
              onTap: () => _selectItem(context, 'About Us', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
              }),
            ),
            _drawerItem(
              context: context,
              icon: Icons.contact_mail,
              text: 'Contact Us',
              isSelected: _isSelected(context, 'Contact Us'),
              onTap: () => _selectItem(context, 'Contact Us', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
              }),
            ),
            _drawerItem(
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

  Widget _drawerItem({
    required BuildContext context,
    IconData? icon,
    required String text,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: isSelected ? Colors.black : Colors.white)
          : null,
      title: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white,
      onTap: onTap,
    );
  }
}
