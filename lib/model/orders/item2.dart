class Item2 {
  late String name = "";
  late int itemId = 0;
  late int qantity = 0;
  late double price = 0;
  double? hiddenPrice = 0;
  int totalItems = 0;

  Item2({
    required this.name,
    required this.itemId,
    required this.qantity,
    required this.price,
    this.hiddenPrice,
  }) {
    hiddenPrice = (price);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['itemId'] = itemId;
    data['qantity'] = qantity;
    data['price'] = price;
    data['hiddenPrice'] = hiddenPrice;
    return data;
  }

  Item2.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    itemId = json['itemId'] as int;
    qantity = json['qantity'] as int;
    price = json['price'] as double;
    hiddenPrice = json['hiddenPrice'] as double;
  }
}
