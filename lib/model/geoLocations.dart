class GeoLocations {
  late List<GeoLocation> geoLocations;

  GeoLocations.fromJson(Map<String, dynamic> json) {
    List geoLocationsList = json['data'] as List;

    geoLocations =
        geoLocationsList.map((item) => GeoLocation.fromJson(item)).toList();
  }
}

class GeoLocation {
  late int restaurantId;
  late double radius;
  late double latitude;
  late double longitude;

  GeoLocation.fromJson(Map<String, dynamic> json) {
    restaurantId = int.parse(json['restaurant_id']);
    radius = double.parse(json['kilometer']);
    latitude = double.parse(json['latitude']);
    longitude = double.parse(json['longitude']);
  }
}
