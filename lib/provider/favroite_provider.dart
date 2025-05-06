import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/common_product_model.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ProductModel> _favorites = [];
  List<ProductModel> get favorites => _favorites;

  static const _prefsKey = 'favorite_products';

  FavoriteProvider() {
    _loadFavorites();
  }

  void toggleFavorite(ProductModel product) {
    final isFav = isFavorite(product);
    if (isFav) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    _saveFavorites(); // Save after any change
    notifyListeners();
  }

  void removeFavorite(ProductModel product) {
    _favorites.removeWhere((p) => p.id == product.id);
    _saveFavorites(); // Save after any change
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    return _favorites.any((p) => p.names == product.names);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = _favorites.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList(_prefsKey, favJson);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = prefs.getStringList(_prefsKey) ?? [];
    _favorites =
        favJson
            .map((jsonStr) => ProductModel.fromJson(json.decode(jsonStr)))
            .toList();
    notifyListeners();
  }
}
