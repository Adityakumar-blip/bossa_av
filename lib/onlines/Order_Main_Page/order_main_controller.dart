import 'package:get/get.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/model/specials_model.dart';
import 'package:Bossa/network/api.dart';

class OrderMainController extends GetxController {
  var selectedIndex = 0.obs;
  var specialsLoading = true.obs;
  var restuarantLoading = true.obs;
  var restHasValue = true.obs;
  var specialHasValue = true.obs;
  Restaurants res = Restaurants([]).obs();
  Specials? specials = Specials([]).obs();
  @override
  void onInit() async {
    super.onInit();

    await getRestaurant();
    await getSpecails();
  }

  getRestaurant() async {
    res = await Api.getRestautantlist(fromOrders: true);

    restuarantLoading.value = false;

    if (res.res.isEmpty) {
      restHasValue.value = false;
    }

    update();
  }

  getSpecails() async {
    specials = await Api.getSpecials(fromOrders: true);

    if (specials?.specials == null) {
      specialHasValue.value = false;
    } else if (specials!.specials.isEmpty) {
      specialHasValue.value = false;
    }

    specialsLoading.value = false;
    update();
  }
}
