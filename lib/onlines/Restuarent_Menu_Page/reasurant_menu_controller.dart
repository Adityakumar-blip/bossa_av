// ignore_for_file: list_remove_unrelated_type

import 'package:Bossa/model/bag_model.dart';
import 'package:Bossa/model/cart.dart';
import 'package:Bossa/model/dish_catergory.dart';
import 'package:Bossa/model/orders/category.dart';
import 'package:Bossa/model/orders/items.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/services/services.dart';

class ReasurantMenuController extends GetxController {
  var dishCategories = <DishCategory>[].obs;

  RxBool tempNoStorehit = false.obs;
  CategoryListModel categoryListModel = CategoryListModel();
  int? tempIndex;
  String? tempName;
  var tempDish = <DishCategory>[];
  Rx<Restaurant> rest = Restaurant(
          distance: '',
          latitude: '',
          longitude: '',
          distance_0_12_price: '',
          distance_13_18_price: '',
          id: 0,
          resArea: '',
          resName: '',
          whatsapp: '',
          url: '',
          deliveryFee: 0)
      .obs;
  var cart = Cart().obs;

  late int resid = 0;

  var storage = Get.find<StorageService>();

  Future<void> setRes(int id) async {
    resid = id;
    await getStoreItems(id);
    await getRestaurant(id);

    compareCartToItems();
    update();
  }

  Future<void> getCategorylist(String id) async {
    categoryListModel = await Api.categoryListApi(id);
    print('savan get list ++++++++>${categoryListModel.data?.length}');
    update();
  }

  void compareCartToItems() {
    cart.value.items ??= [];

    if (cart.value.items!.isEmpty) {
      return;
    }

    for (var item in cart.value.items!) {
      for (var dish in dishCategories.value) {
        dish.items
            .where((element) => element.id == item.itemId)
            .toList()
            .forEach((element) {
          dish.count++;
        });
      }
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    // getCategorylist();
    var storageCart = storage.getCart();
    if (storageCart != null) {
      cart.value = storageCart;
    } else {
      cart.value.items = [];
    }

    if (cart.value.items != null && cart.value.items!.isEmpty) {
      cart.value.items = [];
    }

    cart.value.deliveryFee = 0;
  }

  getRestaurant(int id) async {
    Api api = Api();
    rest.value = await api.GetRestaurantById(id);
    print(rest.value.whatsapp);
    cart.value.deliveryFee = rest.value.deliveryFee;
    update();
  }

  Future<void> getStoreItems(int id) async {
    Api api = Api();
    if (dishCategories.isNotEmpty) {
      dishCategories.clear();
    }

    tempDish.clear();
    var list = await api.getStoreItems(id);

    if (list.categories!.isEmpty) {
      return;
    }
    tempDish.addAll(list.categories!.reversed);
    dishCategories.addAll(list.categories!.reversed);
    updateOpen("PROMOTIONS");
  }

  void addToCart(BagModel item, int quantity, int restaurantId) {
    var newItem = Item(
        name: item.dishName,
        itemId: item.id,
        qantity: quantity,
        price: item.price,
        catorgoryId: item.catorgoryId,
        isFromAddons: 'right');

    cart.value.items!.add(newItem);

    cart.value.restaurantId = restaurantId;
    cart.value.updateSubTotal();
    storage.saveCart(cart.value);
    update();
  }

  void addToCart2(BagModel item, int quantity, int restaurantId, double price,
      String name, int itemid) {
    var newItem = Item(
        name: name,
        itemId: item.id,
        qantity: quantity,
        price: price,
        catorgoryId: item.catorgoryId);

    cart.value.items!.add(newItem);

    cart.value.restaurantId = restaurantId;
    cart.value.updateSubTotal();
    storage.saveCart(cart.value);
    update();
  }

  void removeFromCart(BagModel index) {
    if (cart.value.items!.isEmpty) {
      return;
    }

    cart.value.items!.remove(index);
    //cart.value.items!.remove((item) => item.itemId == index.id);
    cart.value.updateSubTotal();
    storage.saveCart(cart.value);
    update();
  }

  void updateCart(BagModel index, int quantity) {
    if (cart.value.items!.any((element) => element.itemId == index.id)) {
      cart.value.items?.forEach((element) {
        if (element.itemId == index.id) {
          element.qantity = quantity;
          element.hiddenPrice = (element.price * quantity);
        }
      });

      cart.value.updateSubTotal();
      storage.saveCart(cart.value);
      update();
    } else {
      addToCart(index, quantity, resid);
      storage.saveCart(cart.value);
    }
  }

  void updateCart2(BagModel item, int quantity, int restaurantId, double price,
      String name, int itemid) {
    if (cart.value.items!.any((element) => element.itemId == itemid)) {
      cart.value.items?.forEach((element) {
        if (element.itemId == itemid) {
          element.qantity = quantity;
          element.hiddenPrice = (element.price * quantity);
        }
      });

      cart.value.updateSubTotal();
      storage.saveCart(cart.value);
      update();
    } else {
      BagModel bg = BagModel(name, quantity, price, itemid, "");
      addToCart2(item, quantity, restaurantId, price, name, itemid);
      storage.saveCart(cart.value);
    }
  }

  void removeCount(int index) {
    // ignore: invalid_use_of_protected_member\
    if (dishCategories.value[index].count > 0) {
      dishCategories.value[index].count--;
    }

    if (cart.value.totalItems > 0) {
      cart.value.totalItems--;
    }
  }

  void addCount(int index) {
    // ignore: invalid_use_of_protected_member
    dishCategories.value[index].count++;
    cart.value.totalItems++;
  }

  void updateOpen(String index) {
    final newTemp = tempDish;

    try {
      dishCategories.value.clear();
      dishCategories.addAll(tempDish);

      if (tempName == null) {
        tempName = index;

        var temp = dishCategories
            .where((x) => x.name.toLowerCase().trim() == index.toLowerCase())
            .toList();
        dishCategories.value.clear();
        if (temp.isNotEmpty) {
          dishCategories.addAll(temp);
          update();
        }
      } else if (tempName == index) {
        tempName = null;
      } else if (tempName != index) {
        tempName = index;

        var temp = dishCategories
            .where((x) => x.name.toLowerCase().trim() == index.toLowerCase())
            .toList();
        dishCategories.value.clear();
        if (temp.isNotEmpty) {
          dishCategories.addAll(temp);
          update();
        }
      }

      // if (dishCategories.value.length - 1 >= index) {
      //   if (dishCategories.value[index].isOpened == true) {
      //     dishCategories.value[index].isOpened = false;
      //     update();
      //     //dishCategories.addAll(tempDish);
      //   } else {
      //     dishCategories.value[index].isOpened = true;
      //     var temp = dishCategories.value[index];
      //     dishCategories.value.clear();
      //     dishCategories.add(temp);
      //     update();
      //   }
      // } else {
      //   if (dishCategories.value.length - 1 < index) {
      //     if (tempNoStorehit.value == false) {
      //       tempIndex = index;
      //       tempNoStorehit.value = true;
      //       dishCategories.value.clear();
      //     } else if (tempIndex == index) {
      //       tempIndex = null;
      //       tempNoStorehit.value = false;
      //       dishCategories.value.clear();
      //       dishCategories.addAll(tempDish);
      //     } else {
      //       dishCategories.value.clear();
      //     }
      //     update();
      //   }
      // }
    } catch (ex) {
      dishCategories.addAll(newTemp);
      updateOpen(index);
      update();
    }
  }

  bool CheckCount(BagModel index) {
    if (cart.value.items != null && cart.value.items!.isNotEmpty) {
      var item = cart.value.items
          ?.firstWhere((element) => element.itemId == index.id)
          .qantity;

      if (item != null && item > 1) {
        return true;
      }
    }

    return false;
  }

  double amount(BagModel index) {
    var amount = index.price;

    if (cart.value.items != null && cart.value.items!.isNotEmpty) {
      cart.value.items?.forEach((element) {
        if (element.itemId == index.id) {
          amount = index.price * element.qantity;
        }
      });
    }

    return amount;
  }

  void NewCart(Cart newCart) {
    cart.value = newCart;
    compareCartToItems();
    update();
  }
}
