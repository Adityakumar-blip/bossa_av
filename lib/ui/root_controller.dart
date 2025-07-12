import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/home_controller.dart';
import 'package:Bossa/ui/reward_dashboard.dart';

import 'about_us.dart';
import 'home_view.dart';
import 'my_profile.dart';
import 'notification_screen.dart';

class RootControler extends GetxController {
  late DateTime currentBackPressTime;
  var selectedNav = 0.obs;
  final home = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    currentBackPressTime = DateTime.now();
    update();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    } else {
      Get.offAndToNamed(Routes.DASHBOARD);
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  Future<void> onTapNav(int idx) async {
    /// only for VENTA we make a special case...

    selectedNav.value = idx;
    update();

    if (idx == 0) {
      update();
      await home.getSpecails();
      await home.getRestaurant();
      Get.back(id: 1);
    } else if (idx == 1) {
    } else if (idx == 2) {
    } else if (idx == 4) {
      Get.back(id: 4);
    }
    update();
  }

  List<Widget> pages = [
    HomeView(),
    const NotificationScreen(),
    RewardsDashboard(),
    const AboutUs(),
    MyProfile()
  ];
}
