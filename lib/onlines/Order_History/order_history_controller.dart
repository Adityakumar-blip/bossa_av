import 'dart:async';

import 'package:get/get.dart';
import 'package:Bossa/model/order_history.dart';
import 'package:Bossa/network/api.dart';

class OrderHistoryController extends GetxController {
  var hasOrder = false.obs;
  var loading = true.obs;
  var _runner = true;
  OrderHistoy? history;
  final _api = Api();
  @override
  Future<void> onInit() async {
    super.onInit();
    await getHistoy();
    runner();
  }

  void runner() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_runner) {
        timer.cancel();
        return;
      }
      await getHistoy();
    });
  }

  Future<void> getHistoy() async {
    history = await _api.getOrderHistory();
    hasOrder.value = history?.histories.isNotEmpty ?? false;
    loading.value = false;
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _runner = false;
    super.onClose();
  }
}
