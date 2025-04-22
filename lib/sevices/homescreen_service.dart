import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:argil_tiles/model/homescreen_model.dart';
import 'package:http/http.dart';

class HomeScreenService {
  final String baseUrl =
      'https://dev.argiltiles.com/api'; // Replace with your real API base URL

  Future<List<HomescreenModel>?> fetchHomeScreenData() async {
    try {
      Response response = await http.get(Uri.parse('$baseUrl/slider'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => HomescreenModel.fromJson(item)).toList();
      } else {
        return null;
      }
    } catch (e) {
      log('error while ====> $e');
      return null;
    }
  }
}
