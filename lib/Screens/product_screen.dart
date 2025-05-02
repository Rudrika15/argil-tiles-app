import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';

import '../app_const/app_color.dart';

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
    return PopAndRedirectToHome(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6F1),
        endDrawer: DrawerWidget(),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          foregroundColor: AppColors.blackColor,
          elevation: 0,
          title: const Text(
            'DURA QUARTZ SURFACE',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            const Icon(Icons.favorite_border),
            const SizedBox(width: 16),
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu),
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
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
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
      ),
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
