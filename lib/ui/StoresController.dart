import 'package:get/get.dart';
import 'package:Bossa/model/partners.dart';
import 'package:Bossa/network/api.dart';

class StoresController extends GetxController {
  final Rx<Partners> res = Partners([]).obs;

  var showWeb = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await getStoreList();
  }

  Future<void> getStoreList() async {
    Api api = Api();
    final data = await api.getPartners();

    res.value = data;
    update();
  }
}
