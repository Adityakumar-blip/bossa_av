import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:Bossa/model/address_model.dart';
import 'package:Bossa/model/advertisement_model.dart';
import 'package:Bossa/model/bag_model.dart';
import 'package:Bossa/model/cart.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/model/specials_model.dart';
import 'package:Bossa/model/user_model.dart';
import 'package:Bossa/services/services.dart';

import '../../network/api.dart';

class StorageService extends GetxService {
  static StorageService get() => Get.find<StorageService>();

  Future<StorageService> init() async {
    clearData();
    return this;
  }

  void clearData() {
    try {
      final box = Hive.box("userData");
      box.put('res', null);
      box.put('cart', null);
      box.put("adverts", null);
      box.put('specials', null);
    } catch (e) {}
  }

  UserModel getUserData() {
    final userDate = Hive.box("userData").get('data');

    return UserModel.fromJson(userDate['data']);
  }

  void setUserData(data) {
    final userBox = Hive.box('userData');
    userBox.put('data', data);
  }

  void setBagModel(List<BagModel> data) {
    final bagBox = Hive.box('bagData');
    bagBox.put('cart', data);
  }

  List<BagModel> getBagModel() {
    final bagBox = Hive.box('bagData');
    return bagBox.get('cart');
  }

  Future<void> setUserAddress(Address? data) async {
    final userBox = Hive.box('userData');

    userBox.put('address', data!.toJson());
  }

  Future<Address?> getUserAddress() async {
    try {
      final userAddress = Hive.box('userData').get("address");

      if (userAddress == null) {
        Api api = Api();
        var addr = await api.getUserAddress();
        setAddress(addr);
        return addr;
      }
      final address = Map<String, dynamic>.from(userAddress);

      var data = Address.fromJson(address);

      return data;
    } catch (e) {
      return null;
    }
  }

  void setSpecials(Specials? specials) {
    final box = Hive.box("userData");
    box.put("specials", specials!.toJson());
  }

  void setRestaurant(Restaurants? res) {
    final box = Hive.box("userData");

    box.put("res", res!.toJson());
  }

  void setAddress(Address? address) {
    final box = Hive.box("userData");
    box.put("address", address?.toJson());
  }

  void setAdvert(Adverts? adverts) {
    final box = Hive.box("userData");
    box.put("adverts", adverts!.toJson());
  }

  Future<Specials?> getSpecials() async {
    try {
      final specials =
          Hive.box('userData').get("specials") as List<Map<String, dynamic>>;

      if (specials.isEmpty) {
        final specials = await Api.getSpecials();
        setSpecials(specials);
        return specials;
      }

      return Specials.fromJson(specials);
    } catch (e) {
      final specials = await Api.getSpecials();
      setSpecials(specials);
      return specials;
    }
  }

  Future<Restaurants?> getRestuarant() async {
    try {
      var res = Hive.box('userData').get("res") as List<Map<String, dynamic>>;

      if (res.isEmpty) {
        var data = await Api.getRestautantlist();
        setRestaurant(data);
        return data;
      }

      return Restaurants.fromJson(res);
    } catch (e) {
      final res = await Api.getRestautantlist();
      setRestaurant(res);
    }
    return null;
  }

  Future<Adverts?> getAdverts() async {
    try {
      final adverts =
          Hive.box('userData').get("adverts") as List<Map<String, dynamic>>;

      if (adverts.isEmpty) {
        final adverts = await Api.advertisement();
        setAdvert(adverts);
        return adverts;
      }

      return Adverts.fromJson(adverts);
    } catch (e) {
      final adverts = await Api.advertisement();
      setAdvert(adverts);
      return adverts;
    }
  }

  void saveCart(Cart? cart) {
    final box = Hive.box("userData");
    if (cart == null) {
      box.put("cart", null);
    } else if (cart.items == null || cart.items!.isEmpty) {
      box.put("cart", null);
    } else {
      box.put("cart", cart.toJson());
    }
  }

  Cart? getCart() {
    final box = Hive.box("userData");

    var data = box.get("cart");
    if (data == null) {
      return null;
    }

    var hash = jsonEncode(data);
    var dec = jsonDecode(hash);
    return Cart.fromJson(dec);
  }
}
