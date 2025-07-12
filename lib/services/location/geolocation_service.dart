import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:Bossa/ui/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/geoLocations.dart';
import '../services.dart';
import 'package:Bossa/network/api.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeoLocationService extends GetxService {
  static GeoLocationService get() =>
      Get.put<GeoLocationService>(GeoLocationService());
  HomeController home = Get.put(HomeController(), permanent: true);
  ReceivePort port = ReceivePort();
  late double latitude;
  late double longitude;
  late double radius;
  late Api api;

  Future<GeoLocationService> init() async {
    super.onInit();

    // _startGeofence();
    _configure();

    return this;
  }

  /// Receive events from BackgroundFetch in Headless state.

  void _configure() async {
    //bg.BackgroundGeolocation.onGeofence(_onGeofence);
    // bg.BackgroundGeolocation.onMotionChange(_onMotionChange);

   /*  bg.BackgroundGeolocation.ready(bg.Config(
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 1.0,
            stopOnTerminate: false,
            geofenceInitialTriggerEntry: true,
            geofenceModeHighAccuracy: true,
            isMoving: true,
            startOnBoot: true,
            enableHeadless: true,
            foregroundService: true,
            reset: true,
            locationUpdateInterval: 500,
            backgroundPermissionRationale: bg.PermissionRationale(
                title:
                    "Allow {applicationName} to access this device's location even when the app is closed or not in use.",
                message:
                    "BOSSA REWARDS collects location data to send restaurant special even when the app is closed or not in use.",
                positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
                negativeAction: 'Cancel')))
        .then((bg.State state) async {
      if (state.isFirstBoot) {
        var state = await bg.BackgroundGeolocation.start();
        if (state.enabled) {}
      } else {
        if (!state.enabled) {
          bg.BackgroundGeolocation.start();
        }
      }

      await getInitLocation();
    }); */
  }

  Future<void> getInitLocation() async {
    final result = await getLowAccPostion();
    String Lat = "-33.908201", long = "25.3912843";
    if (result != null) {
      Lat = result.coords.latitude.toString();
      long = result.coords.longitude.toString();
    }
    final per = await SharedPreferences.getInstance();
    per.setString("lat", Lat);
    per.setString("long", long);
  }

  Future<void> _onMotionChange(bg.Location location) async {
    print('[${bg.Event.MOTIONCHANGE}] - $location');
    postNotificationApi(
        lat: location.coords.latitude.toString(),
        long: location.coords.longitude.toString());

    await home.getRestaurant();
    await home.getSpecails();
  }

  // void _startGeofence() async {
  //   var data = await getGeoFence();

  //   bg.BackgroundGeolocation.removeGeofences();

  //   List<Geofence> geoFences = [];

  //   for (var geoLocation in data.geoLocations) {
  //     geoFences.add(bg.Geofence(
  //       identifier: geoLocation.restaurantId.toString(),
  //       latitude: geoLocation.latitude,
  //       longitude: geoLocation.longitude,
  //       radius: geoLocation.radius,
  //       notifyOnEntry: true,
  //     ));
  //   }

  //   bg.BackgroundGeolocation.addGeofences(geoFences);
  // }

  // void _onGeofence(bg.GeofenceEvent event) async {
  //   if (event.action == "ENTER") {
  //     postNotificationApi();
  //     _startGeofence();
  //   } else if (event.action == "DWELL") {
  //     postNotificationApi();
  //   }

  //   Get.snackbar("Motion Change", event.action);
  // }

  void postNotificationApi({String lat = "", String long = ""}) async {
    if (lat != "" && long != "") {
      var data = await getMidAccPostion();
      lat = data.coords.latitude.toString();
      long = data.coords.longitude.toString();
    }

    var response = await Api.getNotification(
      latitude: lat,
      longitude: long,
    );
    print(response);
  }

  Future<GeoLocations> getGeoFence() async {
    var res = await Api.getGeoFence();
    final valueMap = jsonDecode(res);

    return GeoLocations.fromJson(valueMap);
  }

  Future<Location> getCurrentPosition() async {
    return await bg.BackgroundGeolocation.getCurrentPosition(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH);
  }

  Future<Location?> getLowAccPostion() async {
    try {
      return await bg.BackgroundGeolocation.getCurrentPosition(
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_LOW);
    } catch (ex) {
      return null;
    }
  }

  Future<Location> getMidAccPostion() async {
    return await bg.BackgroundGeolocation.getCurrentPosition(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_MEDIUM);
  }

  void clearAllGeofence() {
    bg.BackgroundGeolocation.removeGeofences();
  }

  void dispose() {
    port.close();

    super.onClose();
  }
}
