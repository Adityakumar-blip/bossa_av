import 'package:Bossa/model/bag_model.dart';

import 'dish_catergory.dart';

class DishCategories {
  List<DishCategory>? categories = [];

  DishCategories() {
    categories = [];
  }

  DishCategories.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      categories!.add(DishCategory(
          key,
          (json[key] as List)
              .map((e) => e == null ? null : BagModel.fromJson(e))
              .cast<BagModel>()
              .toList(),
          false));
    });
  }
}
