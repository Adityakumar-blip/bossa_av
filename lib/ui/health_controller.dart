import 'dart:convert';

import 'package:get/get.dart';
import 'package:Bossa/network/api.dart';

class HealthController extends GetxController {
  RxBool isloading = true.obs;
  String webUrl = "";
  String errorMessage = "";

  @override
  void onInit() async {
    await getHealthApi();
    super.onInit();
  }

  getHealthApi() async {
    var res = await Api.getHealthUrl();
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      webUrl = valueMap['URL'];
      print(webUrl);
      isloading.value = false;
    } else {
      errorMessage = valueMap['message'];
      isloading.value = false;
    }
    update();
  }
}
