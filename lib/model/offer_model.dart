class Offers {
  late List<OffersList> offers;
  Offers({required this.offers});

  Offers.fromJson(Map<String, dynamic> json) {
    List offersList = json['data'] as List;

    offers = offersList.map((item) => OffersList.fromJson(item)).toList();

    print("list");
  }
}

class OffersList {
  late String id;
  late String? code;
  late String name;
  late String voucherAmount;
  late String voucherPoints;

  OffersList(
      {required this.id,
      required this.name,
      required this.voucherAmount,
      required this.voucherPoints,
      this.code});

  OffersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    voucherAmount = json['voucher_value'];
    voucherPoints = json['voucher_point'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['voucherAmount'] = voucherAmount;
    data['voucherPoints'] = voucherPoints;
    data['code'] = code;
    return data;
  }
}
