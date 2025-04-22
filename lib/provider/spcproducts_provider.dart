import 'package:flutter/material.dart';

import 'package:argil_tiles/sevices/spcproducts_service.dart';

import '../model/common_product_model.dart';

class SpcProductProvider with ChangeNotifier {
  final SpcProductService _service = SpcProductService();

  List<ProductModel>? _products = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel>? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSpcProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _products = await _service.fetchSpcProducts();
    _isLoading = false;
    notifyListeners();
  }
}
