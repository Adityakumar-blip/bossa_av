import '../services/services.dart';
import 'orders/items.dart';

class Cart {
  Cart({
    this.restaurantId,
    this.deliveryFee,
    this.total,
    this.items,
  });
  RxBool? checked = false.obs;
  int totalItems = 0;
  RxString notes = "".obs;
  RxString deliverynotes = "".obs;

  int? restaurantId;
  int? deliveryFee = 0;
  RxInt? nd = 0.obs;
  double subTotal = 0;
  double discount = 0;
  double? total = 0;
  List<Item>? items = [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantId'] = restaurantId;
    data['deliveryFee'] = deliveryFee ?? 0;
    data['subTotal'] = subTotal;
    data['total'] = total;
    data['items'] = items?.map((e) => e.toJson()).toList();
    data['totalItems'] = totalItems;
    return data;
  }

  Cart.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'] != null ? json['totalItems'] as int : 0;
    restaurantId =
        json['restaurantId'] != null ? json['restaurantId'] as int : null;
    deliveryFee = json['deliveryFee'] != null ? json['deliveryFee'] as int : 0;
    subTotal = json['subTotal'] != null ? json['subTotal'] as double : 0.0;
    total = json['total'] != null ? json['total'] as double : 0.0;
    items = json['items'] != null
        ? json['items']?.map<Item>((e) => Item.fromJson(e))?.toList()
        : [];
  }

  void updateSubTotal() {
    subTotal = 0;
    if (items!.isNotEmpty) {
      items?.forEach((el) {
        subTotal += (el.hiddenPrice)!;
      });
    }
  }

  updateSubTotal2(double a) {
    print(a);
    subTotal = 0;

    items?.forEach((el) {
      print(subTotal);
      subTotal += (el.hiddenPrice)!;
    });
    subTotal += a;

    print(subTotal);
    return subTotal;
  }

  double getTotalOfData() {
    deliveryFee ??= 0;

    total = subTotal + deliveryFee! - discount;
    return total!;
  }
}
