import 'dart:developer';
import 'package:argil_tiles/model/inquiry_request_done_model.dart';
import 'package:argil_tiles/model/product_inquiry_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductInquiryService {
  final String _baseUrl = 'https://dev.argiltiles.com/api';

  Future<InquiryRequestDoneModel?> submitInquiry(
    ProductInquiryModel inquiry,
  ) async {
    final url = Uri.parse('$_baseUrl/inquiry');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inquiry.toJson()),
      );

      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return InquiryRequestDoneModel.fromJson(jsonDecode(response.body));
      } else {
        log("Failed to submit inquiry: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Error during inquiry submission: $e");
      return null;
    }
  }
}
