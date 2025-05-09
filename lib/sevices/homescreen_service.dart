import 'dart:developer';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:argil_tiles/model/homescreen_model.dart';

class HomeScreenService {
  Future<HomeSliderModel?> fetchHomeScreenData({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getSliders,
      );
      if (response.isNotEmpty) {
        return HomeSliderModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log('error while getting home sliders ====> $e');
      return null;
    }
  }
}
