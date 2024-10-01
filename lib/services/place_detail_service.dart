import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceDetailService {
  final String apiKey;

  PlaceDetailService(this.apiKey);

  Future<Map<String, dynamic>> fetchPlaceDetail(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        print(data);
        return data['predictions'] ?? [];
      } else {
        throw Exception('Failed to load places');
      }
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
