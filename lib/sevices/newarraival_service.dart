import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

class NewArrivalService {
  final String baseUrl =
      'https://dev.argiltiles.com/api'; // Replace with actual URL

  Future<NewarrivalModel?> getNewArrivals() async {
    try {
      Response response = await http.get(Uri.parse('$baseUrl/newarrivals'));

      if (response.statusCode == 200) {
        return NewarrivalModel.fromJson(jsonDecode(response.body));
      } else {
        log('Error: Status code ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception occurred: $e');
      return null;
    }
  }
}
