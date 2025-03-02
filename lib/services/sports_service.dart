import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class SportsService {
  Future<List<dynamic>> fetchUpcomingEvents() async {
    final url = "${AppConstants.SPORTS_API_BASE_URL}events?apikey=YOUR_SPORTS_API_KEY";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)["data"];
    } else {
      throw Exception("Failed to fetch sports events");
    }
  }
}
