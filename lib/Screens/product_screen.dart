import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:argil_tiles/Screens/about_screen.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final List<Map<String, String>> surfaces = [
    {'name': 'NERO MARQUINA', 'image': 'assets/images/category1.png'},
    {'name': 'GLACIAR WHITE', 'image': 'assets/images/category2.png'},
    {'name': 'CALACATTA ORO', 'image': 'assets/images/category3.png'},
    {'name': 'HIMALAYAN WHITE', 'image': 'assets/images/category4.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      endDrawer: Container(
        color: Colors.white,
        child: const SizedBox(
          width: 250,
          child: AppDrawer(),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6F1),
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
            builder: (context) => IconButton(
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

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0; // Track the selected menu item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after item tap
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
              leading: const Icon(Icons.category),
              title: const Text("Products"),
              children: [
                ListTile(
                  title: const Text("Dura Quartz Surface"),
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductDetailScreen(
                          imagePath: 'assets/images/category1.png',
                        ),
                      ),
                    );
                  },
                ),
                ListTile(title: const Text("SPC Products"), onTap: () {}),
              ],
            ),
            _createDrawerItem(
              index: 1, // Index for Favorite
              icon: Icons.favorite,
              text: 'Favorite',
              onTap: () {
                _onItemTapped(1);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()),
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
                    _onItemTapped(2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Achievements"),
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AchievementsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Quality"),
                  onTap: () {
                    _onItemTapped(4);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QualityScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Company Profile"),
                  onTap: () {
                    _onItemTapped(5);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _createDrawerItem(
              index: 6, // Index for About Us
              icon: Icons.info,
              text: 'About Us',
              onTap: () {
                _onItemTapped(6);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            _createDrawerItem(
              index: 7, // Index for Contact Us
              icon: Icons.contact_mail,
              text: 'Contact Us',
              onTap: () {
                _onItemTapped(7);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                );
              },
            ),
            _createDrawerItem(
              index: 8, // Index for Logout
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                _onItemTapped(8);
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

  Widget _createDrawerItem({
    required int index,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blue[100], // Highlight color for selected item
      onTap: onTap,
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
