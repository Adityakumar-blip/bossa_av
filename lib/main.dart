import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Bossa/onlines/My_Bag/my_bag_screen.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/services/services.dart';
import 'package:Bossa/ui/home_view.dart';
import 'package:Bossa/ui/news_screen.dart';
import 'package:Bossa/ui/splash_screen.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // _showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(() async {
    await Hive.initFlutter();
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();

    Hive.init(directory.path);
    await Hive.openBox("userData");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var p = preferences.getString("pop");
    await Get.putAsync<FirebaseService>(() => FirebaseService().init());
    if (p.toString().contains("true")) {
      await AppServices.init();

      // bg.BackgroundGeolocation.registerHeadlessTask(
      //     backgroundGeolocationHeadlessTask);
    }
    //   //Get.off(MyBagScreen());
    // runApp(
    //   Phoenix(
    //     child: App(),

    // );
    runApp(const App());
  }, ((error, stack) {
    print([error, stack]);
  }));
}

void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch (headlessEvent.name) {
    /*  case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print(location);
      break; */
    /*   case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print(geofenceEvent);
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print('SCHEDULE' + state.toString());
      break; */
    /*  case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print(event);
      break; */
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => GetMaterialApp(
              navigatorKey: navigatorKey,
              getPages: AppPages.routes,
              debugShowCheckedModeBanner: false,
              title: 'BOSSA REWARDS',
              home: const LoginCheck(),
            ));
  }
}

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  String auths = "Unknown";

  late double latitude;
  late double longitude;
  late double radius;
  late String lastAndroidNotiID;
  late String lastiOSNotiID;
  late SharedPreferences sharedPreferences;
  dialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Column(
              children: const [
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
                textStyle: TextStyle(color: Color.fromARGB(123, 244, 67, 54)),
                isDefaultAction: true,
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setString("pop", "true");
                  Navigator.pop(context);
                  main();
                },
                child: Text("OK"),
              ),
              CupertinoDialogAction(
                textStyle: TextStyle(color: Color.fromARGB(123, 244, 67, 54)),
                isDefaultAction: true,
                onPressed: () async {
                  exit(0);
                },
                child: Text("Cancel"),
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
      setState(() {
        auths = status.toString();
      });
      if (status == TrackingStatus.authorized) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("pop", "true");
        main();
      } else if (status == TrackingStatus.notDetermined) {
        await showCustomTrackingDialog(context);
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
      
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

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
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
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   dialog();
    // });
    Platform.isIOS ? initPlugin() : a();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   dialog(context);
    // });
    //getGeoFencesApi();
    // _calculateDistance();
    _checkSlider().then((value) {
      if (value) {
        _checkLogin();
      } else {
        showSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/pmck_logo2.png"),
      ),
    );
  }

  // Future<bool> _getPop() async {
  //   final pop = preferences?.getBool('pop') ?? false;
  //   return pop;
  // }

  Future _checkSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool? checkslide;
    try {
      // ignore: await_only_futures
      checkslide = await preferences.getBool("isViewSlider");
      if (checkslide == null || checkslide == false) {
        return false;
      } else {
        return checkslide;
      }
    } catch (e) {
      return false;
    }
  }

  showSlider() {
    Get.off(SplashScreen());
  }

  _checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // navigate to login screen

    final login = preferences.getBool("isLogin") ?? false;
    print("check login >>>>>> ${preferences.getBool("isLogin")}");
    if (login) {
      //await Get.putAsync<SessionService>(() => SessionService().init());
      Get.offAndToNamed(Routes.ROOT);
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
