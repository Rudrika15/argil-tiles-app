import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/contact_model.dart';
import 'package:argil_tiles/model/contact_us_query_done_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

class ContactService {
  final String _baseUrl = 'https://dev.argiltiles.com/api';

  Future<ContactUsQueryDone?> submitContact({
    required ContactModel contact,
  }) async {
    Uri url = Uri.parse('$_baseUrl/contactus');
    try {
      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contact.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ContactUsQueryDone.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      log('error while contact us => $e');
      return null;
    }
  }
}
