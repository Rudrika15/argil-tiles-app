import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:http/http.dart' as http;

import '../model/common_product_model.dart';

class QuartzproductsService {
  

  Future<List<ProductModel>?> fetchSpcProducts() async {
    try {
      final response = await http.get(Uri.parse(ApiHelper.quartzProduct));

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
