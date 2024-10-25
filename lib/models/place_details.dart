class PlaceDetails {
  final String name;
  final String formattedAddress;
  final String phoneNumber;
  final List<String> photos;
  final String rating;
  final double latitude;
  final double longitude;
  final String longName; // long_name 추가

  PlaceDetails({
    required this.name,
    required this.formattedAddress,
    required this.phoneNumber,
    required this.photos,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.longName, // long_name 초기화
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    List<String> photos = [];
    if (json['photos'] != null) {
      photos = (json['photos'] as List)
          .map((photo) => photo['photo_reference'] as String)
          .toList();
    }

    // geometry에서 latitude와 longitude 추출
    double latitude = 0.0;
    double longitude = 0.0;
    if (json['geometry'] != null && json['geometry']['location'] != null) {
      latitude = json['geometry']['location']['lat'] ?? 0.0;
      longitude = json['geometry']['location']['lng'] ?? 0.0;
    }

    // address_components에서 long_name 추출
    String longName = '';
    if (json['address_components'] != null) {
      for (var component in json['address_components']) {
        print("Address Component: $component"); // 각 주소 컴포넌트 출력
        if (component['types'].contains('locality') ||
            component['types'].contains('administrative_area_level_1')) {
          longName = component['long_name'];
          break; // 찾으면 반복문 종료
        }
      }
    }

    return PlaceDetails(
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      phoneNumber: json['formatted_phone_number'] ?? '',
      photos: photos,
      rating: json['rating'] ?? '',
      latitude: latitude,
      longitude: longitude,
      longName: longName, // long_name 전달
    );
  }
}
