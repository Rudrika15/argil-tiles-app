import 'package:argil_tiles/Screens/product_details_screen.dart';
import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:argil_tiles/sevices/newarraival_service.dart';
import 'package:flutter/material.dart';
import '../model/common_product_model.dart';

class NewarrivalProvider with ChangeNotifier {
  final NewArrivalService _service = NewArrivalService();

  NewarrivalModel? _newArrivals;
  NewarrivalModel? get newArrivals => _newArrivals;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchNewArrivals() async {
    _isLoading = true;
    notifyListeners();

    _newArrivals = await _service.getNewArrivals();
    _isLoading = false;
    notifyListeners();
  }

  List<ProductModel> getList() {
    return _newArrivals?.data?.where((e) => e.mainImg != null).toList() ?? [];
  }

  void getNewArrivalAndRedirectToProductPage({
    required BuildContext context,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    String url =
        _newArrivals?.data
            ?.firstWhere((e) => e.navigateUrl != null)
            .navigateUrl ??
        "";
    ProductModel? product = await _service.getNewArrivalProduct(url: url);

    if (product != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProductDetailsScreen(
                productModel: product,
                url: _newArrivals?.url ?? "",
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }
}
