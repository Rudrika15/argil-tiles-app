import 'dart:convert';
import 'package:argil_tiles/model/contact_model.dart';
import 'package:http/http.dart' as http;

class ContactService {
  final String _baseUrl = 'https://dev.argiltiles.com/api'; 

  Future<bool> submitContact(ContactModel contact) async {
    final url = Uri.parse('$_baseUrl/contactus');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contact.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
