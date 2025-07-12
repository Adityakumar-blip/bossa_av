class Stores {
  late List<StoresList> stores;
  Stores({required this.stores});

  Stores.fromJson(Map<String, dynamic> json) {
    List preferredStores = json['data'] as List;

    stores = preferredStores.map((item) => StoresList.fromJson(item)).toList();

    print("list");
    print(stores);
  }
}

class StoresList {
  late String id;
  late String name;
  late String location;
  late bool isSelect;

  StoresList(
      {required this.id,
      required this.name,
      required this.location,
      required this.isSelect});

  StoresList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    isSelect = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['location'] = location;
    data['isSelect'] = isSelect;

    return data;
  }
}
