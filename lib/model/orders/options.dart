class Options {
  int? id;
  String? plu;
  String? item;
  int? price;

  Options({this.id, this.plu, this.item, this.price});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plu = json['plu'];
    item = json['item'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plu'] = plu;
    data['item'] = item;
    data['price'] = price;
    return data;
  }
}
