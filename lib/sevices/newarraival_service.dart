import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/common_product_model.dart';
import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

class NewArrivalService {


  Future<NewarrivalModel?> getNewArrivals() async {
    try {
      Response response = await http.get(Uri.parse(ApiHelper.newArrival));

      if (response.statusCode == 200) {
        return NewarrivalModel.fromJson(jsonDecode(response.body));
      } else {
        log('Error: Status code ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception occurred: $e');
      return null;
    }
  }

  ///
  Future<ProductModel?> getNewArrivalProduct({required String url}) async {
    try {
      Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      } else {
        log('Error: Status code ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception occurred: $e');
      return null;
    }
  }
}
