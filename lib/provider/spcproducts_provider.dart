import 'package:flutter/material.dart';
import 'package:argil_tiles/sevices/spcproducts_service.dart';
import '../model/spcproduct_model.dart';


class SpcProductProvider with ChangeNotifier {
  final SpcProductService _service = SpcProductService();

  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SpcProductModel? _spcProductModel;
  SpcProductModel? get spcProductModel => _spcProductModel;

  Future<void> loadSpcProducts({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    _spcProductModel = await _service.fetchSpcProducts(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
