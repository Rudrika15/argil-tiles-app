import 'dart:developer';
import 'package:argil_tiles/model/auth_model.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/http_helper/http_helper.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<LoginModel?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.login,
        context: context,
        body: {"email": email, "password": password},
      );
      if (response.isNotEmpty) {
        return LoginModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting auth credentials => $e");
      return null;
    }
  }
}
