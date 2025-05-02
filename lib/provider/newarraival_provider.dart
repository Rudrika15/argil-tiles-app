import 'dart:developer';

import 'package:flutter/material.dart';
import '../Screens/product_details_screen.dart';
import '../model/newarrival_model.dart';
import '../model/common_product_model.dart';
import '../sevices/newarraival_service.dart';

class NewarrivalProvider with ChangeNotifier {
  final NewArrivalService _service = NewArrivalService();

  NewarrivalModel? _newArrivals;
  bool _isLoading = false;
  String? _navigateUrl;

  // Getters
  NewarrivalModel? get newArrivals => _newArrivals;
  bool get isLoading => _isLoading;
  String? get navigateUrl => _navigateUrl;

  // Fetch new arrivals and extract navigateUrl
  Future<void> fetchNewArrivals() async {
    _isLoading = true;
    notifyListeners();

    _newArrivals = await _service.getNewArrivals();

    // Try to find an object with navigate_url
    ProductModel? navItem = _newArrivals?.data?.firstWhere(
      (e) => e.navigateUrl != null,
    );

    _navigateUrl = navItem?.navigateUrl;
    log("navigate_url ==> $navigateUrl");

    _isLoading = false;
    notifyListeners();
  }

  // Get filtered list of valid products
  List<ProductModel> getProductList() {
    return _newArrivals?.data
            ?.where((e) => e.mainImg != null && e.names != null)
            .toList() ??
        [];
  }

  // Trigger navigation using stored URL
  Future<ProductModel?> getNewArrivalAndRedirectToProductPage() async {
    _isLoading = true;
    notifyListeners();

    ProductModel? product = await _service.getNewArrivalProduct(
      url: _navigateUrl!,
    );
    log(product?.toJson().toString() ?? "not");
    _isLoading = false;
    notifyListeners();
    return product;
  }
}
