import 'package:flutter/material.dart';

class Adverts {
  List<Advert> adverts = [];

  Adverts(this.adverts);

  Adverts.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      for (var element in json) {
        adverts.add(Advert.fromJson(element));
      }
    } else {
      adverts = [];
    }
  }

  List<Map<String, dynamic>> toJson() {
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < (adverts.length); ++i) {
      final d = adverts[i].toJson();
      data.add(d);
    }
    return data;
  }
}

class Advert {
  String image = "";
  String link = "";
  Image? advImage;

  Advert({required this.image, required this.link});

  Advert.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    link = json['link'] ?? "";
    if (image != "") {
      advImage = Image.network(
        image,
        fit: BoxFit.fill,
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["image"] = image;
    data["link"] = link;
    return data;
  }
}
