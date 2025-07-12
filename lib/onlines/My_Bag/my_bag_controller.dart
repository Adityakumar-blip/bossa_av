import 'package:get/get.dart';
import 'package:Bossa/model/bag_model.dart';
import 'package:Bossa/model/cart.dart';
import 'package:Bossa/model/orders/items.dart';
import 'package:Bossa/onlines/Order_Main_Page/order_main_controller.dart';
import 'package:Bossa/services/storage/storage_service.dart';

import '../../routes.dart';
import '../Restuarent_Menu_Page/reasurant_menu_controller.dart';

class MyBagController extends GetxController {
  Rx<Cart>? cart = Cart().obs;

  var storage = Get.find<StorageService>();

  final ReasurantMenuController rest = Get.put(ReasurantMenuController());

  final OrderMainController main = Get.put(OrderMainController());

  @override
  void onInit() {
    super.onInit();
    getBagList();
  }

  void getBagList() {
    var item = storage.getCart();

    if (item != null) {
      cart?.value = item;
    } else {
      cart!.value.items = [];
      cart!.value.restaurantId = 0;
      cart!.value.deliveryFee = 0;
    }
  }

  void setBagList(BagModel data) {
    getBagList();
    storage.saveCart(cart!.value);
  }

  void removeBagItem(Item data) {
  
    cart!.value.items!.removeWhere((element) => element.itemId == data.itemId);
    cart!.value.updateSubTotal();

    // rest.cart.value.items!
    //     .removeWhere((element) => element.itemId == data.itemId);

    if (rest.cart.value.items!.isEmpty) {
      rest.cart.value = Cart();
      rest.cart.value.items = [];
      rest.cart.value.deliveryFee = rest.rest.value.deliveryFee;
    }

    if (cart!.value.items!.isEmpty) {
      cart!.value = Cart();
      cart!.value.deliveryFee = rest.rest.value.deliveryFee;
      cart!.value.items = [];
    }

    rest.NewCart(cart!.value);

    storage.saveCart(cart!.value);

    update();
  }

  void updateBagItem(Item data) {
    cart!.value.items!.remove(data);
    cart!.value.items!.add(data);
    storage.saveCart(cart!.value);

    rest.cart.value.items?.forEach((element) {
      if (element.itemId == data.itemId) {
        element.qantity = data.qantity;
      }
    });

    update();
  }

  double itemTotal(Item item) {
    return item.price * item.qantity;
  }

  void removeItem(int index) {
    if (cart!.value.items == null) {
      return;
    }

    var item = cart?.value.items?[index];

    item?.qantity--;

    if (item!.qantity <= 0) {
      removeBagItem(item);
      return;
    }

    item.hiddenPrice = item.price * item.qantity;

    cart!.value.updateSubTotal();

    rest.NewCart(cart!.value);

    storage.saveCart(cart!.value);
    update();
  }

  void addToItem(int index) {
    var item = cart?.value.items?[index];

    item!.qantity++;

    item.hiddenPrice = item.price * item.qantity;

    cart!.value.updateSubTotal();

    rest.NewCart(cart!.value);

    storage.saveCart(cart!.value);
    update();
  }

  void mainOrder() {
    main.selectedIndex.value = 0;
    Future.delayed(const Duration(seconds: 3),
        () => Get.offAndToNamed(Routes.ONLINEORDERMAIN));
  }
}
