// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:Bossa/main.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../firebase_options.dart';

class FirebaseService extends GetxService {
  static FirebaseService get() => Get.find<FirebaseService>();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late FirebaseMessaging messaging;
  late AndroidNotificationChannel channel;

  Future<FirebaseService> init() async {
    await Firebase.initializeApp(
        name: 'bossa', options: DefaultFirebaseOptions.currentPlatform);
    await requestPermission();
    // Set the background messaging handler early on, as a named top-level function

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await _initAsyncService();

    return this;
  }

  Future<void> _initAsyncService() async {
    await registerNotificationListeners();
  }

  Future<String?> getMessageToken() async {
    if (Platform.isIOS) {
      String apnstoken = await FirebaseMessaging.instance.getToken() ?? "";
      print("APNSToken: $apnstoken");
      return apnstoken;
    }
    String fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    print(fcmToken);
    return fcmToken;
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );
      }
    }
  }

  registerNotificationListeners() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(message);
      }
    });

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        event.notification?.android?.imageUrl;
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description)));
      }
      var title = event.notification!.title;
      var body = event.notification!.body;
      var image = event.notification!.android!.imageUrl;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        _showFlutterNotification(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _showFlutterNotification(RemoteMessage message) {
    final data = message.data;
    var newId;
    print('MessageData___$data');
    if (data.isNotEmpty) {
      var routeName = data['pageName'] ?? "";

      if (routeName != "") {
        if (data.containsKey("newsID")) {
          newId = data["newsID"];
        } else {
          newId = "0";
        }
        if (Routes.pnPages.keys.contains(routeName)) {
          String name = Routes.pnPages.entries
              .where((element) => element.key == routeName)
              .first
              .value;

          if (newId != null) {
            Get.toNamed(name, arguments: newId);
          } else {
            Get.toNamed(name);
          }
        }
      } else {
        Get.toNamed(Routes.NEWS, arguments: "0");
        // Get.toNamed(Routes.NEWS,
        //     arguments: {'navId': NavConst.notifyNav, 'res': ""},
        //     id: NavConst.notifyNav);
      }
    }
  }

  //

  Future onDidRecieveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print("Inside this ---> $id");
    print("Inside this ---> $title");
    print("Inside this ---> $body");
    print("Inside this ---> $payload");
  }

  Future onSelectNotification(String? payload) async {
    print("payload-> $payload");
    if (payload != null) {
      print("payload ---> $payload");

      if (Routes.pnPages.keys.contains(payload)) {
        String name = Routes.pnPages.entries
            .where((element) => element.key == payload)
            .first
            .value;
        Get.toNamed(name);
      } else {
        Get.toNamed(Routes.NEWS, arguments: "0");
      }
    }
  }

  Future displayNotifiction(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics;

    if (message['data']['image'].toString().isNotEmpty) {
      print(message['data']['image']);
    }
    if (message['data']['image'] == null) {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'CHANNEL-ID',
        'CHANNEL-NAME',
        channelDescription: "Description",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: DefaultStyleInformation(true, true),
      );
      iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    } else {
      var attachmentPicturePath = await _downloadAndSaveFile(
          '${message['data']['image']}',
          '${message['data']['image'].split('/').last}');
      var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(attachmentPicturePath),
      );
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL-ID',
        'CHANNEL-NAME',
        channelDescription: 'Description',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
      );
      iOSPlatformChannelSpecifics = IOSNotificationDetails(
        attachments: [IOSNotificationAttachment(attachmentPicturePath)],
      );
    }
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: message['data']['newsID'].toString() != ""
          ? message['data']['newsID']
          : message['data']['pageName'],
    );
  }

  _downloadAndSaveFile(String url, String fileName) async {
    print("URL ---> $url");
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var uri = Uri.parse(url);
    var response = await http.get(uri);

    var file = File(filePath);
    print("File ---> ${file.path}");
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
