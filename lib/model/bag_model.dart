class BagModel {
  late String dishName;
  late String desc;
  int? count;
  dynamic? isSpecial;
  late String picture;
  late double price;
  late int id;
  late int catorgoryId;
  int? resId;

  BagModel(this.dishName, this.count, this.price, this.id, this.desc);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = dishName;
    data['quanitiy'] = count;
    data['price'] = price;
    data['id'] = id;
    data['description'] = desc;
    data['is_special'] = isSpecial;
    data['picture'] = picture;
    data['category_id'] = catorgoryId;
    data['restaurant_id'] = resId;
    return data;
  }

  BagModel.fromJson(Map<String, dynamic> json) {
    dishName = json['name'];
    price = double.parse(json['price']);
    id = int.parse(json['id']);
    desc = json['description'];
    isSpecial = json['is_special'];
    picture = json['picture'] ?? "";
    catorgoryId = int.parse(json['category_id']);
    resId = int.parse(json['restaurant_id']);
  }
}
