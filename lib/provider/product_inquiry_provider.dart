import 'package:argil_tiles/model/product_inquiry_model.dart';
import 'package:argil_tiles/sevices/product_inquiry_service.dart';
import 'package:flutter/material.dart';

class ProductInquiryProvider with ChangeNotifier {
  final ProductInquiryService _service = ProductInquiryService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> sendInquiry(ProductInquiryModel inquiry) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    final result = await _service.submitInquiry(inquiry);
    _isLoading = false;
    _isSuccess = result;

    if (!result) {
      _errorMessage = "Failed to send inquiry";
    }

    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}
