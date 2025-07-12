import 'bag_model.dart';

class DishCategory {
  late String name;
  bool isOpened = true;
  int count = 0;
  late List<BagModel> items;

  DishCategory(this.name, this.items, this.isOpened);

  DishCategory.fromJson(Map<String, dynamic> json) {
    name = json['category'];
    items = (json['items'] as List)
        .map((e) => e == null ? null : BagModel.fromJson(e))
        .cast<BagModel>()
        .toList();
  }
}
