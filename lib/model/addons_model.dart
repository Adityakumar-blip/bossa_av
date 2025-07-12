import 'package:Bossa/services/services.dart';

class AddOnsModel {
  String? status;
  List<Data>? data;

  AddOnsModel({this.status, this.data});

  AddOnsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? restaurantId;
  String? nameOfAddon;
  String? createdAt;
  List<Addons>? addons;

  Data(
      {this.id,
      this.restaurantId,
      this.nameOfAddon,
      this.createdAt,
      this.addons});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    nameOfAddon = json['name_of_addon'];
    createdAt = json['created_at'];
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['name_of_addon'] = nameOfAddon;
    data['created_at'] = createdAt;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addons {
  String? id;
  String? itemAddonId;
  String? nameOfItem;
  String? description;
  String? cost;
  String? createdAt;
  RxBool? checked = false.obs;
  Addons(
      {this.id,
      this.itemAddonId,
      this.nameOfItem,
      this.description,
      this.cost,
      this.createdAt});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemAddonId = json['item_addon_id'];
    nameOfItem = json['name_of_item'];
    description = json['description'];
    cost = json['cost'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_addon_id'] = itemAddonId;
    data['name_of_item'] = nameOfItem;
    data['description'] = description;
    data['cost'] = cost;
    data['created_at'] = createdAt;
    return data;
  }
}
