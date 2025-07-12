import 'package:get/get.dart';
import 'package:Bossa/model/favourites_model.dart';
import 'package:Bossa/network/api.dart';

class OrderFavouriteController extends GetxController {
  var hasOrder = false.obs;
  var is_loading = true.obs;
  Favourites? fav;
  final _api = Api();
  @override
  Future<void> onInit() async {
    super.onInit();

    update();
    await getFav();
  }

  Future<void> getFav() async {
    fav = await _api.getFavourites();
    if (fav!.fav.isNotEmpty) {
      hasOrder.value = true;
    }
    is_loading.value = false;
    update();
  }
}
