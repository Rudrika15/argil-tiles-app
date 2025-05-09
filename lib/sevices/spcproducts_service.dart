import 'dart:developer';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';
import '../model/spcproduct_model.dart';

class SpcProductService {
  Future<SpcProductModel?> fetchSpcProducts({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.spcProduct,
      );
      if (response.isNotEmpty) {
        return SpcProductModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting spc products => $e");
      return null;
    }
  }
}
