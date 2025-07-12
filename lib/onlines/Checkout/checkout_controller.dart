import 'package:Bossa/model/address_model.dart';
import 'package:Bossa/model/cart.dart';
import 'package:Bossa/model/orders/return_order.dart';
import 'package:Bossa/model/orders/send_order.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/services/location/geolocation_service.dart';
import 'package:Bossa/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Restuarent_Menu_Page/reasurant_menu_controller.dart';

class CheckOutController extends GetxController {
  var loading = false.obs;

  RxDouble promo = RxDouble(-1.0);
  double _finalPromo = 0.0;

  var promoCode = "".obs;
  var total = 0.0.obs;
  var discount = 0.0.obs;
  var tip = 0.obs;
  var delivery = 0.obs;

  var cart = Cart().obs;
  var promoController = TextEditingController().obs;

  var tipController = TextEditingController().obs;
  Rx<String> addrtype = "".obs;
  Rx<String> addr = "".obs;
  RxBool dropvisible = false.obs;
  Rx<String> select = "Delivered".obs;
  Rx<String> loc = "Saved".obs;
  void onClickRadioButton(value) {
    print(value);

    select.value = value;
    cart.value.deliveryFee = delivery.value;
    if (value != "Delivered") {
      cart.value.deliveryFee = 0;
    }
    getTotal();
    update();
  }

  void dropChanged(val) {
    cart.value.deliveryFee = val;
    getTotal();
    update();
  }

  final _storage = Get.find<StorageService>();
  final _location = Get.find<GeoLocationService>();
  var user = Address(
          name: "",
          address: "",
          apart: "",
          road: "",
          business: "",
          area: "",
          postalCode: "")
      .obs;
  final _api = Api();

  @override
  Future<void> onInit() async {
    cart.value.deliveryFee = 0;
    // TODO: implement onInit
    super.onInit();
    await getAddress();
    await getCart();
  }

  Future<void> getAddress() async {
    var data = await _api.getUserAddress();
    if (data != null) {
      user.value = data;
      update();
    }
  }

  Future<void> getCart() async {
    final data = _storage.getCart();
    if (data != null) {
      cart.value = data;
      delivery.value = cart.value.deliveryFee ?? 0;
      getTotal();
    }
    update();
  }

  Future<ReturnOrder> saveOrder() async {
    print(cart.value.deliverynotes.toString());
    final location = await _location.getLowAccPostion();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    if (promo.value > 0.0) {
      _finalPromo = promo.value;
    }
    print(cart.value.deliverynotes.toString());
    final data = SendOrder(
        deliverynotes: cart.value.deliverynotes.toString(),
        notes: cart.value.notes.toString(),
        uuid: uuid ?? "",
        deliveryAddress:
            select.value == "Collect" ? "Collected" : user.value.address,
        dropzone_id: user.value.dropzone_id,
        deliveryFee: select.value == "Collect" ? 0 : cart.value.deliveryFee!,
        latitude: location!.coords.latitude.toString(),
        longitude: location.coords.longitude.toString(),
        restaurantId: cart.value.restaurantId!,
        subTotal: cart.value.subTotal - _finalPromo,
        promo: _finalPromo,
        promoCode: promoCode.value,
        total: select.value == "Collect"
            ? cart.value.subTotal - _finalPromo
            : cart.value.getTotalOfData(),
        tip: int.parse(tip.value.toString()),
        discount: cart.value.discount,
        items: cart.value.items!);

    return await _api.saveOrder(data);
  }

  void updateLoader(bool value) {
    loading.value = value;
    update();
  }

  void updateAddress(Address address) {
    user.value = address;
    update();
  }

  Future<void> getPromo(String code) async {
    final value = await Api.checkPromo(code, cart.value.restaurantId);
    print(value);
    if (value != null && value["value"] != "") {
      String amt = await Api.checkValid(code);
      discount.value = double.parse(amt);
      print(amt);
      if (double.parse(cart.value.getTotalOfData().toString()) >=
          double.parse(amt)) {
        promo.value = double.tryParse(value["value"]) ?? 0.0;
        promoCode.value = value["code"];
        getTotal();
      } else {
        Get.rawSnackbar(
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          message: "Minimum amount to use this promocode is $amt",
        );
      }
      update();
    }
    if (value["value"].toString().isEmpty) {
      print("k");
      Get.rawSnackbar(
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        message: "Invalid Promocode",
      );
    }
  }

  Future<void> tipUpdate(String amt) async {
    if (amt == "") {
      tip.value = 0;
    } else {
      tip.value = int.parse(amt);
    }
    getTotal();
    update();
  }

  Future<void> price(int deliveryFee) async {
    final rescontrol = Get.put(
      ReasurantMenuController(),
    );
    if (deliveryFee < 12000) {
      cart.value.deliveryFee =
          int.parse(rescontrol.rest.value.distance_0_12_price);
      cart.value.nd = 0.obs;
      update();
      getTotal();
    } else if (deliveryFee >= 12000 && deliveryFee <= 18000) {
      cart.value.deliveryFee =
          int.parse(rescontrol.rest.value.distance_13_18_price);
      cart.value.nd = 0.obs;
      update();

      getTotal();
    } else {
      cart.value.nd = 1.obs;
      //cart.value.deliveryFee = 1;
      Fluttertoast.showToast(
          msg:
              "Unable to deliver at this location. Please select drop off zone!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      update();
    }

    update();
  }

  void getTotal() {
    if (promo.value > 0.0) {
      _finalPromo = promo.value;
    }
    total.value =
        cart.value.getTotalOfData() - _finalPromo + tip.value - discount.value;
    update();
  }
}
