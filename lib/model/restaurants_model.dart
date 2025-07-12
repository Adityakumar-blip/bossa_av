import 'package:flutter/material.dart';

class Restaurants {
  late List<Restaurant> res = [];

  Restaurants(this.res);

  Restaurants.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      for (var element in json) {
        res.add(Restaurant.fromJson(element));
      }
    } else {
      res = [];
    }
  }

  List<Map<String, dynamic>> toJson() {
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < res.length; ++i) {
      final d = res[i].toJson();
      data.add(d);
    }
    return data;
  }
}

class Restaurant {
  late int? id;
  late String resName;
  late String distance;
   late String latitude;
  late String longitude;
  late String url;
  late String resArea;
  late int deliveryFee;
  late String distance_0_12_price;
  late String distance_13_18_price;
  Image? image;
 late String whatsapp;
  Restaurant(
      {required this.id,
      required this.resName,
      required this.distance,
      required this.url,
      required this.latitude,required this.longitude,
      required this.resArea,
      required this.distance_0_12_price,required this.distance_13_18_price,
      required this.deliveryFee,required this.whatsapp});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    resName = json['specialName'] ?? "";
    latitude=json['location_lat']??"";
    longitude=json["location_long"]??"";
    distance_0_12_price=json['distance_0_12_price']??"";
    distance_13_18_price=json['distance_13_18_price']??"";
    distance = json['distance'] ?? "";
    whatsapp=json['whatsapp_number']??"";
    if (json['url'] != null) {
      url = json['url'];
    } else if (json['logo'] != null) {
      url = json['logo'];
    } else {
      url = "";
    }

    if (url != "") {
      image = Image.network(url, fit: BoxFit.fill, height: 80);
    }

    resArea = json['area'];
    deliveryFee = json['delivery_price'] != null && json['delivery_price'] != ""
        ? int.tryParse(json['delivery_price'].toString())!
        : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["id"] = id;
    data["location_lat"]=latitude;
    data["location_long"]=longitude;
    data["specialName"] = resName;
    data["distance"] = distance;
    data["url"] = url;
    data["distance_0_12_price"]=distance_0_12_price;
    data["distance_13_18_price"]=distance_13_18_price;
    data['area'] = resArea;
    data['delivery_price'] = deliveryFee;
    data['whatsapp_number']=whatsapp;
    return data;
  }
}
