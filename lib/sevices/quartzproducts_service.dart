import 'dart:developer';
import 'package:argil_tiles/model/quartzproduct_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';

class QuartzproductsService {
  Future<QuartzProductModel?> fetchSpcProducts({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.quartzProduct,
      );

      if (response.isNotEmpty) {
        return QuartzProductModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while Quartz Products => $e");
      return null;
    }
  }
}
