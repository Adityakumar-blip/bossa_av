// To parse this JSON data, do
//
//     final categoryListModel = categoryListModelFromJson(jsonString);

import 'dart:convert';

CategoryListModel categoryListModelFromJson(String str) => CategoryListModel.fromJson(json.decode(str));

String categoryListModelToJson(CategoryListModel data) => json.encode(data.toJson());

class CategoryListModel {
    String? status;
    List<Datum>? data;

    CategoryListModel({
        this.status,
        this.data,
    });

    factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? name;
    String? restaurantId;

    Datum({
        this.id,
        this.name,
        this.restaurantId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        restaurantId: json["restaurant_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "restaurant_id": restaurantId,
    };
}
