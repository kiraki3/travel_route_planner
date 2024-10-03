import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_route_planner/models/place_details.dart';

class PlaceDetailService {
  final String apiKey;

  PlaceDetailService(this.apiKey);

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // API 호출 성공 시, JSON 파싱
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        // 장소 세부 정보를 모델로 변환
        print(data);
        return PlaceDetails.fromJson(data['result']);
      } else {
        throw Exception('Failed to fetch place details: ${data['status']}');
      }
    } else {
      throw Exception('Failed to connect to the API');
    }
  }
}
