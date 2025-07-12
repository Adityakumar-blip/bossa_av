import 'package:get/get.dart';

import 'firebase/firebase_service.dart';
import 'location/geolocation_service.dart';
import 'session/session_service.dart';
import 'storage/storage_service.dart';

export 'package:get/get.dart';
export 'firebase/firebase_service.dart';
export 'location/geolocation_service.dart';
export 'session/session_service.dart';
export 'storage/storage_service.dart';

abstract class AppServices {
  static Future<void> init() async {
    await Get.putAsync<GeoLocationService>(() => GeoLocationService().init());

    await Get.putAsync<FirebaseService>(() => FirebaseService().init());
    await Get.putAsync<StorageService>(() => StorageService().init());
    await Get.putAsync<SessionService>(() => SessionService().init());
  }
}
