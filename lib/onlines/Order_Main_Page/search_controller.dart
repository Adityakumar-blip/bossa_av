import 'package:get/get.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/services/location/geolocation_service.dart';

import '../../model/restaurants_model.dart';

class SearchController2 extends GetxController {
  var isloading = false.obs;

  var location = Get.put(GeoLocationService());

  var search = false.obs;
  Api api = Api();

  Rx<Restaurants> res = Restaurants([]).obs;

  Future<void> find() async {
    search.value = true;
    isloading.value = true;
    update();

    var loc = await location.getMidAccPostion();

    final data = await api.search(
        loc.coords.latitude.toString(), loc.coords.longitude.toString());
    if (data != null) {
      if (data.res.isNotEmpty) {
        res.value.res = data.res;
      }
    }

    isloading.value = false;
    update();
  }
}
