import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;


import '../model/common_product_model.dart';

class QuartzproductsService {
  final String baseUrl = 'https://dev.argiltiles.com/api';

  Future<List<ProductModel>?> fetchSpcProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quartzproduct'));

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        return null;
      }
    } catch (e) {
      log("error while => $e");
      return null;
    }
  }
}
