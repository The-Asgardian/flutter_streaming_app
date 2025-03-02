import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class AllDebridService {
  Future<String?> resolveMagnet(String magnetLink) async {
    final url = "https://api.alldebrid.com/v4/magnet/upload?apikey=${AppConstants.ALLDEBRID_API_KEY}&magnet=$magnetLink";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["data"]["id"];
    }
    return null;
  }

  Future<String?> getStreamUrl(String magnetId) async {
    final url = "https://api.alldebrid.com/v4/magnet/status?apikey=${AppConstants.ALLDEBRID_API_KEY}&id=$magnetId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["data"]["links"][0]["link"];
    }
    return null;
  }
}
