import 'dart:developer';
import 'package:argil_tiles/model/common_product_model.dart';
import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';

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
  Future<ProductModel?> getNewArrivalProduct({
    required BuildContext context,
    required String url,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: url,
      );

      if (response.isNotEmpty) {
        return ProductModel.fromJson(response['data']);
      } else {
        return null;
      }
    } catch (e) {
      log('error while getting new arrival product from $url => $e');
      return null;
    }
  }
}
