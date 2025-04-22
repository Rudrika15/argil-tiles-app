import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _selectedItem = '';

  void _selectItem(String itemName, VoidCallback navigate) {
    setState(() {
      _selectedItem = itemName;
    });
    Navigator.pop(context);
    navigate();
  }

  bool _isSelected(String itemName) => _selectedItem == itemName;

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
              leading: const Icon(Icons.category),
              title: const Text("Products"),
              children: [
                _drawerItem(
                  text: 'Dura Quartz Surface',
                  isSelected: _isSelected('Dura Quartz'),
                  onTap: () => _selectItem('Dura Quartz', () {}),
                ),
                _drawerItem(
                  text: 'SPC Products',
                  isSelected: _isSelected('SPC Products'),
                  onTap: () => _selectItem('SPC Products', () {}),
                ),
              ],
            ),
            _drawerItem(
              icon: Icons.favorite,
              text: 'Favorite',
              isSelected: _isSelected('Favorite'),
              onTap: () => _selectItem('Favorite', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoriteScreen()),
                );
              }),
            ),
            ExpansionTile(
              leading: const Icon(Icons.business),
              title: const Text("Corporate"),
              children: [
                _drawerItem(
                  text: 'Group Company',
                  isSelected: _isSelected('Group Company'),
                  onTap: () => _selectItem('Group Company', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  }),
                ),
                _drawerItem(
                  text: 'Achievements',
                  isSelected: _isSelected('Achievements'),
                  onTap: () => _selectItem('Achievements', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                    );
                  }),
                ),
                _drawerItem(
                  text: 'Quality',
                  isSelected: _isSelected('Quality'),
                  onTap: () => _selectItem('Quality', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QualityScreen()),
                    );
                  }),
                ),
                _drawerItem(
                  text: 'Company Profile',
                  isSelected: _isSelected('Company Profile'),
                  onTap: () => _selectItem('Company Profile', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CompanyProfileScreen()),
                    );
                  }),
                ),
              ],
            ),
            _drawerItem(
              icon: Icons.info,
              text: 'About Us',
              isSelected: _isSelected('About Us'),
              onTap: () => _selectItem('About Us', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              }),
            ),
            _drawerItem(
              icon: Icons.contact_mail,
              text: 'Contact Us',
              isSelected: _isSelected('Contact Us'),
              onTap: () => _selectItem('Contact Us', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              }),
            ),
            _drawerItem(
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
    IconData? icon,
    required String text,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(text),
      selected: isSelected,
      selectedTileColor: Colors.grey[300],
      onTap: onTap,
    );
  }
}
