import 'package:argil_tiles/model/product_inquiry_model.dart';
import 'package:argil_tiles/sevices/product_inquiry_service.dart';
import 'package:flutter/material.dart';
import '../model/inquiry_request_done_model.dart';

class ProductInquiryProvider with ChangeNotifier {
  /// text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool _requestSample = false;
  bool get requestSample => _requestSample;
  set setRequestSample(bool b) {
    _requestSample = b;
    notifyListeners();
  }

  final ProductInquiryService _service = ProductInquiryService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  InquiryRequestDoneModel? _inquiryRequestDoneModel;
  InquiryRequestDoneModel? get inquiryRequestDoneModel =>
      _inquiryRequestDoneModel;

  Future<bool> sendInquiry({
    required String productName,
    required String url,
  }) async {
    _isLoading = true;
    notifyListeners();

    /// send inquiry
    _inquiryRequestDoneModel = await _service.submitInquiry(
      ProductInquiryModel(
        productName: productName,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: contactController.text.trim(),
        message: messageController.text.trim(),
        subject: "Product Inquiry",
        details: "$url _ $productName",
        requestSample: _requestSample,
      ),
    );
    _isLoading = false;
    notifyListeners();
    return _inquiryRequestDoneModel?.status == true;
  }

  void resetController() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    messageController.clear();
    notifyListeners();
  }
}
