import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/utils/enviorment%20helper/enviorment_helper.dart';
import 'package:argil_tiles/utils/shared_preference/shared_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static final client = RetryClient(http.Client());
  static bool isDebugMode = Environment.debugMode;
  // Generalized response handler
  static Future<Map<String, dynamic>> processResponse({
    required Response response,
    required BuildContext context,
  }) async {
    try {
      if (isDebugMode) {
        log(response.body);
      }
      Map<String, dynamic> data = jsonDecode(response.body);

      // Handle 500 Internal Server Error
      if (response.statusCode == 500) {
        log("response handle 500");
        // WidgetHelper.customSnackBar(
        //   isError: true,
        //   context: context,
        //   title: "Internal Server Error (500)",
        //   color: AppColors.errorColor,
        // );
        throw Exception("Server error");
      }

      // Handle unauthorized access (401)
      if (response.statusCode == 401) {
        // WidgetHelper.customSnackBar(
        //   isError: true,
        //   context: context,
        //   title: "Session expired. Please log in again.",
        //   color: AppColors.errorColor,
        // );
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        //   (route) => false,
        // );
        return {}; // Empty map since user is logged out
      }

      // Ensure status is 200 even for validation errors
      if (response.statusCode == 200) {
        if (data.containsKey('success') && !data['success']) {
          // WidgetHelper.customSnackBar(
          //   isError: true,
          //   context: context,
          //   title: data['message'] ?? "Something went wrong",
          //   color: AppColors.errorColor,
          // );
          return data; // Return data even if unsuccessful
        }
        return data; // If success is true, return the data
      }

      // Handle unexpected errors
      // WidgetHelper.customSnackBar(
      //   isError: true,
      //   context: context,
      //   title: "Unexpected Error",
      //   color: AppColors.errorColor,
      // );
      return {};
    } catch (e) {
      if (isDebugMode) {
        log("Error processing response: $e");
      }

      // WidgetHelper.customSnackBar(
      //   isError: true,
      //   context: context,
      //   title: "Something went wrong",
      //   color: AppColors.errorColor,
      // );
      return {};
    }
  }

  // GET method
  static Future<Map<String, dynamic>> get({
    required BuildContext context,
    required String uri,
    Map<String, String>? headers,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(uri);
      var response = await client.get(url, headers: headers ?? header);

      if (context.mounted) {
        return processResponse(response: response, context: context);
      }
    } catch (e) {
      if (isDebugMode) {
        log("GET request error: $e");
      }
      // log();
      // WidgetHelper.customSnackBar(
      //   context: context,
      //   isError: true,
      //   title: "Something went wrong!",
      //   color: AppColors.errorColor,
      // );
    }
    return {}; // Return an empty map on failure
  }

  // POST method
  static Future<Map<String, dynamic>> post({
    required String uri,
    Object? body,
    Map<String, String>? headers,
    required BuildContext context,
    Encoding? encoding,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};
      var url = Uri.parse(uri);
      var response = await client.post(
        url,
        body: body,
        headers: headers ?? header,
        encoding: encoding,
      );

      if (isDebugMode) {
        log('post ===> ${response.statusCode} && ${response.body}');
      }

      // if (context.mounted) {
      return processResponse(response: response, context: context);
      // } else {
      //   return processResponse(response: response, context: context);
      // }
    } catch (e) {
      isDebugMode ? log("POST request error: $e") : null;
    }
    return {};
  }

  // PUT method
  static Future<Map<String, dynamic>> put({
    required String uri,
    Object? body,
    Map<String, String>? headers,
    required BuildContext context,
    Encoding? encoding,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(uri);
      var response = await client.put(
        url,
        body: body,
        headers: headers ?? header,
        encoding: encoding,
      );

      if (context.mounted) {
        return processResponse(response: response, context: context);
      }
    } catch (e) {
      if (isDebugMode) {
        log("PUT request error: $e");
      }
    }
    return {};
  }

  // DELETE method
  static Future<Map<String, dynamic>> delete({
    required BuildContext context,
    required String uri,
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(uri);
      var response = await client.delete(
        url,
        headers: headers ?? header,
        body: body,
      );

      if (context.mounted) {
        return processResponse(response: response, context: context);
      }
    } catch (e) {
      if (isDebugMode) {
        log("DELETE request error: $e");
      }
    }
    return {};
  }

  // Multipart method
  static Future<MultipartRequest> multipart({required String uri}) async {
    try {
      var token = await SharedPrefs.getToken();
      Map<String, String> headers = {'Authorization': 'Bearer $token'};

      MultipartRequest request = http.MultipartRequest('POST', Uri.parse(uri));
      request.headers.addAll(headers);

      return request;
    } catch (e) {
      if (isDebugMode) {
        log("Multipart request error: $e");
      }
      throw Exception("Multipart request failed");
    }
  }
}
