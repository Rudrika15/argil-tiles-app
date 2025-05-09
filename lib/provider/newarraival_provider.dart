import 'dart:developer';
import 'package:flutter/material.dart';
import '../model/newarrival_model.dart';
import '../model/common_product_model.dart';
import '../sevices/newarraival_service.dart';

class NewarrivalProvider with ChangeNotifier {
  final NewArrivalService _service = NewArrivalService();

  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NewArrivalModel? _newArrivalModel;
  NewArrivalModel? get newArrivalModel => _newArrivalModel;

  String? _navigateUrl;
  String? get navigateUrl => _navigateUrl;

  // Fetch new arrivals and extract navigateUrl
  Future<void> fetchNewArrivals({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    _newArrivalModel = await _service.getNewArrivals(context: context);

    // Try to find an object with navigate_url
    ProductModel? navItem = _newArrivalModel?.data?.firstWhere(
      (e) => e.navigateUrl != null,
    );

    _navigateUrl = navItem?.navigateUrl;

    log("navigate_url ==> $_navigateUrl");

    _isLoading = false;
    notifyListeners();
  }

  // Get filtered list of valid products
  List<ProductModel> getProductList() {
    return _newArrivalModel?.data
            ?.where((e) => e.mainImg != null && e.names != null)
            .toList() ??
        [];
  }

  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;
  // Trigger navigation using stored URL
  Future<void> getNewArrivalAndRedirectToProductPage({
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    _productModel = await _service.getNewArrivalProduct(
      url: _navigateUrl!,
      context: context,
    );

    _isLoading = false;
    notifyListeners();
  }
}
