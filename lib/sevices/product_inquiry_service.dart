import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/inquiry_request_done_model.dart';
import 'package:argil_tiles/model/product_inquiry_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';

class ProductInquiryService {
  Future<InquiryRequestDoneModel?> submitInquiry({
    required ProductInquiryModel inquiry,
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        context: context,
        uri: ApiHelper.inquiry,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inquiry),
      );

      if (response.isNotEmpty) {
        return InquiryRequestDoneModel.fromJson(response);
      }

      return null;
    } catch (e) {
      log("Error during inquiry submission: $e");
      return null;
    }
  }
}
