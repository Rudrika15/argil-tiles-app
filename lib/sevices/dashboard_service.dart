import 'dart:developer';
import 'package:argil_tiles/model/dashboard_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:flutter/material.dart';
import '../utils/http_helper/http_helper.dart';

class DashboardService {
  /// get dashboard data
  Future<DashboardModel?> getDashBoard({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.dashboard,
      );
      if (response.isNotEmpty) {
        return DashboardModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting dashboard => $e");
      return null;
    }
  }
}
