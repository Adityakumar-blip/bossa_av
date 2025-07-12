class Address {
  String? name = "";
  int? uuid = 0;
  String address = "";
  String dropzone_id = "";
  String apart = "";
  String road = "";
  String business = "";
  String area = "";
  String postalCode = "";
  String? latitude = "";
  String? longitude = "";
  String? address_id = "";
  Address(
      {this.address_id,
      required this.name,
      required this.address,
      required this.apart,
      required this.road,
      required this.business,
      required this.area,
      required this.postalCode,
      this.latitude,
      this.longitude,
      this.uuid});

  Address.fromJson(Map<String, dynamic> data) {
    address = data['address'] ?? "";
    address_id = data['id'] ?? "";
    name = data['nickname'] ?? "";
    apart = data['apart'] ?? "";
    road = data['road'] ?? "";
    business = data['business'] ?? "";
    area = data['area'] ?? "";
    postalCode = data['postal_code'] ?? "";
    latitude = data['latitude'] ?? "";
    longitude = data['longitude'] ?? "";
    //name = data['name'] ?? "";
    if (data['user_id'] != null) {
      if (data['user_id'] is int) {
        uuid = data['user_id'];
      } else {
        uuid = int.parse(data['user_id']);
      }
    } else {
      uuid = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['id'] = address_id;
    data["nickname"] = name;
    data['apart'] = apart;
    data['road'] = road;
    data['business'] = business;
    data['area'] = area;
    data['postal_code'] = postalCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['user_id'] = uuid;
    data['name'] = name;
    return data;
  }
}
