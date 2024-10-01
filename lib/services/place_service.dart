import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceService {
  final String apiKey;

  PlaceService(this.apiKey);

  Future<List<dynamic>> searchPlaces(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data['predictions'] ?? [];
    } else {
      throw Exception('Failed to load places');
    }
  }
}
