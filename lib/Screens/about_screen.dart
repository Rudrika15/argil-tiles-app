import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/Screens/company_profile_screen.dart';
import 'package:argil_tiles/Screens/contact_us_screen.dart';
import 'package:argil_tiles/Screens/favourite_screen.dart';
import 'package:argil_tiles/Screens/quality_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
        width: 200,
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
                Image(image: AssetImage('assets/images/logo.png'), height: 100),
                SizedBox(height: 24),
                Text(
                  """India's greatest entrepreneurial stories are all epics within themselves. One of those is the story of the Argil Group of companies. Shri Mothibai Prajapati was a potter at Sultanpur, a very small village. He was blessed with a son, who was destined to create history in the region. We know him now as Shri Amarsibhai Prajapati. Since a young age, he was helping his father in the work of pottery where he attained technical expertise in the workings of clay. His father shifted to Morbi employed at Parshuram Pottery. The family and the young boy too moved to the place where he would later set up one of the most admired ceramic brands of the world.

Shri Amarsibhai too worked in the same factory for 8 to 10 years working in different roles, ranging from a manufacturer of glazed jars to plaster turning moulder. He moved on to Junagadh District to serve as a moulder for 2 years in Kathiavadh Industries Ltd.

People destined to create history are always blessed with astute vision of things to come and determination to articulate the vision into reality. Shri Amarsibhai was no different. While still employed he saw a heap of Mangalore roof tiles which were being manufactured in the South India only. Mangalore roofing tiles main ingredient was Black and Red clay, which was available in abundance in Morbi. The nearness to the raw material and his technical know-how of clay encouraged him to start his own production of roofing tiles.""",
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFF9F6F2), // Set your sidebar background color here
        // If you want gradient instead, comment above and uncomment below:
        /*
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDED8D1), Color(0xFFF9F6F2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        */
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
                ListTile(title: const Text("Dura Quartz Surface"), onTap: () {}),
                ListTile(title: const Text("SPC Products"), onTap: () {}),
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
              leading: const Icon(Icons.category),
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
                  title: const Text("Archievements"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AchievementsScreen()),
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
                      MaterialPageRoute(builder: (context) => CompanyProfileScreen()),
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
                            MaterialPageRoute(builder: (context) => SplashScreen()),
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
