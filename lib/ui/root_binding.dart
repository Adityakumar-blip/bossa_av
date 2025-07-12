import 'package:get/instance_manager.dart';
import 'package:Bossa/ui/root_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RootControler>(RootControler());
  }
}
