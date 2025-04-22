import 'dart:convert';
import 'dart:developer';
import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:http/http.dart' as http;

class NewArrivalService {
  final String baseUrl = 'https://dev.argiltiles.com/api'; // Replace with actual URL

  Future<NewarrivalModel?> getNewArrivals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/newarrivals'));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        log("===================== > $jsonBody");
        return NewarrivalModel.fromJson(jsonBody);
      } else {
        print('Error: Status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
}
