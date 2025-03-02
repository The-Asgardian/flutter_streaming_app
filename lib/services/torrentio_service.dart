import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class TorrentioService {
  Future<List<String>> fetchTorrentLinks(String imdbId) async {
    final url = "${AppConstants.TORRENTIO_BASE_URL}movie/$imdbId.json";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data["streams"].map((e) => e["url"]));
    } else {
      throw Exception("Failed to fetch torrents");
    }
  }
}
