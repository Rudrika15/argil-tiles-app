import 'package:argil_tiles/model/product_inquiry_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductInquiryService {
  final String _baseUrl = 'https://dev.argiltiles.com/api';

  Future<bool> submitInquiry(ProductInquiryModel inquiry) async {
    final url = Uri.parse('$_baseUrl/inquiry'); 

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inquiry.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Failed to submit inquiry: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during inquiry submission: $e");
      return false;
    }
  }
}
