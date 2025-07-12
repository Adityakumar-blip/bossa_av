import 'package:get/get.dart';
import 'dart:convert';

import '../model/news_model.dart';
import '../network/api.dart';

class NewsController extends GetxController {
  late News newsList = News([]);
  RxBool isLoading = true.obs;
  String? resId;
  String? selectedType;

  @override
  Future<void> onInit() async {
    await fetchPromotions(null);
    super.onInit();
  }


  Future<void> fetchPromotions(String? type) async {
  print(selectedType);
    isLoading.value = true;
    selectedType = type;
    try {
      var response = await Api.getPromotionType(type ?? '');
      var data = jsonDecode(response);
      if (data['status'] == 'success') {
        newsList = News(data['data']);
      }
    } catch (e) {
      print("Error fetching promotions: $e");
    }
    isLoading.value = false;
    update();
  }

  void filter() {
    if (resId != null) {
      var list = newsList.newsData
          .where((element) => element.restaurant == resId)
          .toList();
      newsList.newsData = list;
    }
  }

  void setRestId(String? id) {
    resId = id;
    fetchPromotions(selectedType); // Refresh data when restaurant ID changes
  }

  void setFilterType(String? type) {
    selectedType = type;
    fetchPromotions(type); // Fetch promotions based on selected type
  }
}
