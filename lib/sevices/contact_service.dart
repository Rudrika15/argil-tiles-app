import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/contact_model.dart';
import 'package:argil_tiles/model/contact_us_query_done_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';

class ContactService {
  Future<ContactUsQueryDone?> submitContact({
    required ContactModel contact,
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.contactUs,
        context: context,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contact),
      );
      if (response.isNotEmpty) {
        return ContactUsQueryDone.fromJson(response);
      }
      return null;
    } catch (e) {
      log('error while contact us => $e');
      return null;
    }
  }
}
