import 'package:argil_tiles/model/common_product_model.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_network_image.dart';
import 'product_details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = context.watch<FavoriteProvider>();
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          title: const Text("Favourites"),
        ),
        endDrawer: DrawerWidget(),
        body:
            favoriteProvider.favorites.isEmpty
                ? const Center(
                  child: Text(
                    "No favorite items yet!",
                    style: TextStyle(fontSize: 16),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: favoriteProvider.favorites.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 4,
                        ),
                    itemBuilder: (context, index) {
                      final ProductModel item =
                          favoriteProvider.favorites[index];
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductDetailsScreen(
                                      url: item.imageUrl ?? "",
                                      productModel: item,
                                    ),
                              ),
                            ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CustomNetworkImage(
                                width: double.infinity,
                                height: double.infinity,
                                boxFit: BoxFit.cover,
                                imageUrl:
                                    "https://admin.argiltiles.com/public/${item.imageUrl}/${item.mainImg}",
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap:
                                    () => favoriteProvider.removeFavorite(item),
                                child: const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
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
                                  item.names ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
