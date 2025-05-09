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

  Future<void> sendInquiry({
    required String productName,
    required String url,
    required int id,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    /// send inquiry
    _inquiryRequestDoneModel = await _service.submitInquiry(
      inquiry: ProductInquiryModel(
        id: id,
        productName: productName,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: contactController.text.trim(),
        message: messageController.text.trim(),
        subject: "Product Inquiry",
        details: "$url _ $productName",
        requestSample: _requestSample,
      ),
      context: context,
    );
    _isLoading = false;
    notifyListeners();

    if (_inquiryRequestDoneModel?.success == true) {
      resetController();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inquiry submitted successfully!")),
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            inquiryRequestDoneModel?.message ?? "Something Went Wrong",
          ),
        ),
      );
    }
  }

  void resetController() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    messageController.clear();
    notifyListeners();
  }
}
