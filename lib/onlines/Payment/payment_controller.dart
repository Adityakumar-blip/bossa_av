import 'package:get/get.dart';
import 'package:Bossa/model/cart.dart';
import 'package:Bossa/model/orders/send_order.dart';
import 'package:Bossa/onlines/Checkout/checkout_controller.dart';
import 'package:Bossa/onlines/My_Bag/my_bag_controller.dart';

import '../../services/storage/storage_service.dart';
import '../Restuarent_Menu_Page/reasurant_menu_controller.dart';

class PaymentController extends GetxController {
  var loading = true.obs;
  var clientID = "";
  Rx<String>? url = "".obs;
  var status = false;

  var storage = Get.find<StorageService>();
  final ReasurantMenuController rest = Get.put(ReasurantMenuController());
  final MyBagController bag = Get.put(MyBagController());
  final CheckOutController cart = Get.put(CheckOutController());

  Future<void> sendPayment(SendOrder data) async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 1), () {
      loading.value = false;
    });
    update();
  }

  void Success() {
    bag.cart = null;
    rest.cart.value = Cart();
    cart.cart.value = Cart();
    storage.saveCart(null);
  }
}
