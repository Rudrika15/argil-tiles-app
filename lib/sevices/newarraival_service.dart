import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/common_product_model.dart';
import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

class NewArrivalService {
  Future<NewArrivalModel?> getNewArrivals({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.newArrival,
      );

      if (response.isNotEmpty) {
        return NewArrivalModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log('error while getting new arrvials => $e');
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
