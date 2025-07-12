import 'package:flutter/cupertino.dart';

class Specials {
  List<Special> specials = [];
  Specials(this.specials);

  Specials.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      for (var element in json) {
        specials.add(Special.fromJson(element));
      }
    } else {
      specials = [];
    }
  }

  List<Map<String, dynamic>> toJson() {
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < specials.length; ++i) {
      final d = specials[i].toJson();
      data.add(d);
    }
    return data;
  }
}

class Special {
  late String id;
  late String specialName;
  late String storename;
  late String distance;
  late String url;
  NetworkImage? specImage;

  Special(
      {required this.id,
      required this.specialName,
      required this.storename,
      required this.distance,
      required this.url});

  Special.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    storename = json["storeName"] ?? "";
    specialName = json['specialName'] ?? "";
    distance = json['distance'];
    url = json['url'] ?? "";

    if (url != "") {
      specImage = NetworkImage(url);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["storename"] = storename;
    data["id"] = id;
    data["specialName"] = specialName;
    data["distance"] = distance;
    data["url"] = url;
    return data;
  }
}
