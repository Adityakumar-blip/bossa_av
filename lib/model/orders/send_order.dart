import 'items.dart';

class SendOrder {
  late String uuid;
  late int restaurantId;
  late int deliveryFee;
  late String notes;
  late String deliverynotes;
  late String deliveryAddress;
  late String longitude;
  late String latitude;
  late List<Item> items;
  late double subTotal;
  late double discount;
  late double total;
  late double promo;
  late String promoCode;
  late int tip;
  late String dropzone_id;
  SendOrder(
      {required this.uuid,
      required this.restaurantId,
      required this.deliveryFee,
      required this.deliveryAddress,
      required this.longitude,
      required this.dropzone_id,
      required this.latitude,
      required this.deliverynotes,
      required this.notes,
      required this.items,
      required this.subTotal,
      required this.discount,
      required this.promo,
      required this.promoCode,
      required this.tip,
      required this.total});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['res_id'] = restaurantId;
    data['delivery_address'] = deliveryAddress;
    data['longitude'] = longitude;
    data['delivery_note'] = deliverynotes;
    data['latitude'] = latitude;
    data['dropzone_id'] = dropzone_id;
    data["notes"] = notes;
    data['orders'] = items.map((e) => e.toJson()).toList();
    data['total_amount'] = subTotal;
    data['discount'] = discount;
    data['total_paid'] = total;
    data['promo'] = promo;
    data['promoCode'] = promoCode;
    data['tip_amount'] = tip;
    data['action'] = "CREATE_ORDER";
    return data;
  }
}
