import 'package:argil_tiles/sevices/quartzproducts_service.dart';
import 'package:flutter/material.dart';
import '../model/common_product_model.dart';

class QuartzproductsProvider with ChangeNotifier {
  final QuartzproductsService _service = QuartzproductsService();

  List<ProductModel>? _products = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel>? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadQuartzProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _products = await _service.fetchSpcProducts();
    _isLoading = false;
    notifyListeners();
  }
}
