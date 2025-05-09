import 'package:argil_tiles/model/quartzproduct_model.dart';
import 'package:argil_tiles/sevices/quartzproducts_service.dart';
import 'package:flutter/material.dart';

class QuartzproductsProvider with ChangeNotifier {
  final QuartzproductsService _service = QuartzproductsService();

  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  QuartzProductModel? _quartzProductModel;
  QuartzProductModel? get quartzProductModel => _quartzProductModel;

  Future<void> loadQuartzProducts({required BuildContext context}) async {
    _isLoading = true;

    notifyListeners();

    _quartzProductModel = await _service.fetchSpcProducts(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
