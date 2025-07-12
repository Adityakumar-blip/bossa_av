import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/model/address_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/onlines/Address/address_list.dart';
import 'package:Bossa/onlines/Checkout/checkout_controller.dart';
import 'package:Bossa/services/session/session_service.dart';
import 'package:Bossa/services/storage/storage_service.dart';

import '../Checkout/checkout_screen.dart';

class AddressController extends GetxController {
  final address =
      TextEditingController(text: "25 old main road, Hillcrest, Durban").obs();
       final name =
      TextEditingController(text: "").obs();
  final flat = TextEditingController(text: "Flat number and building").obs();
  final road = TextEditingController(text: "Road name").obs();
  final business =
      TextEditingController(text: "Business ( Or ) Building Name*").obs();
  final area = TextEditingController(text: "Area / District*").obs();
  final postalCode = TextEditingController(text: "Postal code").obs();
  final _api = Api();
  final _storage = Get.put(StorageService());
  final _session = Get.put(SessionService());

  final _checkout = Get.put(CheckOutController());

  var isloading = false.obs;
  var loadAddress = false.obs;

  Rx<Address>? addr = Address(
    name:"",
  address_id:"",
          address: "",
          apart: "",
          road: "",
          business: "",
          area: "",
          postalCode: "")
      .obs;
  String? uuid;
  int? user_id;

  @override
  Future<void> onInit() async {
    loadAddress.value = true;
    update();
    super.onInit();
    uuid = await _session.getUuid();
    await getUserAddress();
    update();
  }

  Future<void> getUserAddress() async {
    update();
    var val = await _api.getUserAddress();

    if (val != null) {
      addr!.value = val;

      user_id = addr!.value.uuid;

      _loadData(addr!.value);
      loadAddress.value = false;
      update();
    } else {
      _loadData(null);
      loadAddress.value = false;
    }

    update();
  }

  void _loadData(Address? address) {
    name.text=address?.name??"";
    this.address.text = address?.address ?? "";
    flat.text = address?.apart ?? "";
    road.text = address?.road ?? "";
    business.text = address?.business ?? "";
    area.text = address?.area ?? "";
    postalCode.text = address?.postalCode ?? "";
    update();
  }

  Future<void> validate(String id,bool c,String dn,BuildContext context) async {
    if (address.text.isEmpty) {
      Get.rawSnackbar(
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          message: "Please enter address.",
          title: "Miss info");
      isloading.value = false;
      update();
      return;
    }
if (name.text.isEmpty) {
      Get.rawSnackbar(
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          message: "Please enter nickname.",
          title: "Miss info");
      isloading.value = false;
      update();
      return;
    }
    if (road.text.isEmpty) {
      Get.rawSnackbar(
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          message: "Please enter road name.",
          title: "Miss info");
      isloading.value = false;
      update();
      return;
    }
  bool? ans=  await save(id);
  if(ans==true){
    if(c==true){
      Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => CheckOutScreen(dn:dn),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
     
    }else{
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddressList(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));}
  }
  }

  Future<bool> save(String id) async {
    final value = Address(
      address_id: id,
      name: name.text,
        address: address.text,
        apart: flat.text,
        road: road.text,
        business: business.text,
        area: area.text,
        postalCode: postalCode.text,
        uuid: user_id);
    final saved = await _api.saveAddress(value);

    if (saved) {
      _checkout.updateAddress(value);
      _storage.setAddress(value);
      Get.rawSnackbar(
          backgroundColor: Colors.green,
          title: "Success",
          message: "Address saved.",
          duration: const Duration(seconds: 3));
      isloading.value = false;
      
      update();
      return true;
    }

    Get.rawSnackbar(
        backgroundColor: Colors.red,
        title: "Error",
        message: "Unable to save  your address.",
        duration: const Duration(seconds: 3));
    isloading.value = false;
    update();
    return false;
  }
}
