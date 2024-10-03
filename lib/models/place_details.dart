class PlaceDetails {
  final String name;
  final String formattedAddress;
  final String phoneNumber;
  final List<String> photos;
  final String rating;
  final double latitude;
  final double longitude;

  PlaceDetails({
    required this.name,
    required this.formattedAddress,
    required this.phoneNumber,
    required this.photos,
    required this.rating,
    required this.latitude,
    required this.longitude,
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

    return PlaceDetails(
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      phoneNumber: json['formatted_phone_number'] ?? '',
      photos: photos,
      rating: json['rating'] ?? '',
      latitude: latitude,
      longitude: longitude,
    );
  }
}
