import 'dart:io';

import 'package:Bossa/main.dart';
import 'package:Bossa/model/advertisement_model.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/model/specials_model.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/services/storage/storage_service.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/api.dart';
import '../util/common_methods.dart';

class HomeController extends GetxController {
  var scanResult = ''.obs;
  var result = ''.obs;
  var specialSelected = true.obs;
  var specialsLoading = true.obs;
  var restuarantLoading = true.obs;
  Restaurants? res = Restaurants([]).obs();
  var selectedIndex = 0.obs;
  var swiperIndex = 0.obs;
  var viewAllClicked = false.obs;
  late DateTime currentBackPressTime;
  var advertsLoading = true.obs;
  Adverts? adverts = Adverts([]).obs();
  Specials? specials = Specials([]).obs();
  int totalAd = 0;
  bool isLoading = false;
  final pagecontroller = PageController(viewportFraction: 1.0);
  final StorageService _storage = Get.put(StorageService());
  late ScrollController restaurantScroll = ScrollController();

  bool onload = true;

  @override
  void onInit() async {
    specials?.specials = [];
    adverts?.adverts = [];
    res?.res = [];
    super.onInit();
    onload = false;
    await getRestaurant();
    await getSpecails();
    await advertisementData();
    currentBackPressTime = DateTime.now();
    // Platform.isIOS ? initPlugin() : a();

    update();
  }

  dialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: const Column(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 80,
                ),
                Text(
                    'BOSSA REWARDS collects location data to send restaurant special even when app is closed or not in use.'),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                textStyle:
                    const TextStyle(color: Color.fromARGB(123, 244, 67, 54)),
                isDefaultAction: true,
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setString("pop", "true");
                  Navigator.pop(context);
                  main();
                },
                child: const Text("OK"),
              ),
              CupertinoDialogAction(
                textStyle:
                    const TextStyle(color: Color.fromARGB(123, 244, 67, 54)),
                isDefaultAction: true,
                onPressed: () async {
                  exit(0);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    });
  }

  a() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var p = preferences.getString("pop");
    print(p);
    if (p.toString().contains("false") || p == null) {
      dialog();
    }
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      /*   setState(() {
        auths = status.toString();
      }); */
      if (status == TrackingStatus.authorized) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("pop", "true");
        main();
      } else if (status == TrackingStatus.notDetermined) {
        // await showCustomTrackingDialog(context);
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        /*  setState(() {
          auths = status.toString();
        }); */
      } else {
        a();
      }
      //setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.denied) {
        /*if (status == TrackingStatus.denied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        a();
      } else if (status == TrackingStatus.notDetermined) {
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
      } else {
        a();
      }
      }*/
      }
    } on PlatformException {}

    // final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    // print("UUID: $uuid");
  }

/*   Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We require the tracking of the user to enhance the experience of the user. This is used for sending push notifications when entering a geofence. This is will display unique specials.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString("pop", "true");
                Navigator.pop(context);
                main();
                //
              },
              child: const Text('Ok'),
            ),
            /*  TextButton(
              onPressed: () async {
                exit(0);
                //
              },
              child: const Text('Cancel'),
            ), */
          ],
        ),
      );
   */
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  void updateScanResult(String result) {
    scanResult.value = result;
    _launchURL(result);
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      // Optionally show an alert or snackbar to the user
    }
  }

  void launchURL(url, context) async {
    try {
      await launch(url);
    } catch (e) {
      CommonMethods().showFlushBar("Invalid URL request", context);
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    updateScanResult(barcodeScanRes);
  }

  void updateResult(String newResult) {
    result.value = newResult;
  }

  getRestaurant() async {
    if (onload) {
      res = await _storage.getRestuarant();
      await Future.delayed(const Duration(seconds: 3), () async {
        res = await Api.getRestautantlist(newLocation: false);
      });
      update();
    } else {
      res = await Api.getRestautantlist(newLocation: true);
    }

    restuarantLoading.value = false;
    update();
  }

  getSpecails() async {
    if (onload) {
      specials = await _storage.getSpecials();
      await Future.delayed(const Duration(seconds: 3), () async {
        specials = await Api.getSpecials(newLocation: true);
      });
      update();
    } else {
      specials = await Api.getSpecials(newLocation: true);
      update();
    }
    specialsLoading.value = false;
    update();
  }

  advertisementData() async {
    if (onload) {
      adverts = await _storage.getAdverts();
      await Future.delayed(const Duration(seconds: 3), () async {
        adverts = await Api.advertisement(newLocation: false);
      });
      advertsLoading.value = false;
      update();
    } else {
      adverts = await Api.advertisement(newLocation: true);
      advertsLoading.value = false;
      update();
    }
  }

  Future gotTOProudPartners() async {
    await Get.toNamed(Routes.STOREPAGE,
        arguments: {"navId": NavConst.homeNav}, id: NavConst.homeNav);
  }
}
