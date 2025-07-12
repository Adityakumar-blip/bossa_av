import 'package:get/get.dart';
import 'package:Bossa/model/user_model.dart';

import '../../services/storage/storage_service.dart';

class ProfileController extends GetxController {
  final _storage = Get.find<StorageService>();

  var user = UserModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    user.value = _storage.getUserData();

    update();
  }
}
