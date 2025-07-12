import 'dart:convert';

import 'package:Bossa/model/addons_model.dart';
import 'package:Bossa/model/address_model.dart';
import 'package:Bossa/model/advertisement_model.dart';
import 'package:Bossa/model/base_api_model.dart';
import 'package:Bossa/model/dish_categories.dart';
import 'package:Bossa/model/favourites_model.dart';
import 'package:Bossa/model/news_model.dart';
import 'package:Bossa/model/notifications_model.dart';
import 'package:Bossa/model/offer_model.dart';
import 'package:Bossa/model/order_history.dart';
import 'package:Bossa/model/orders/category.dart';
import 'package:Bossa/model/orders/orderCallback.dart';
import 'package:Bossa/model/orders/order_model.dart';
import 'package:Bossa/model/orders/return_order.dart';
import 'package:Bossa/model/orders/send_order.dart';
import 'package:Bossa/model/partners.dart';
import 'package:Bossa/model/redeem_history_model.dart';
import 'package:Bossa/model/restaurant_model.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/model/specials_model.dart';
import 'package:Bossa/model/store_model.dart';
import 'package:Bossa/model/store_models.dart';
import 'package:Bossa/model/user_model.dart';
import 'package:Bossa/services/firebase/firebase_service.dart';
import 'package:Bossa/services/location/geolocation_service.dart';
//import 'package:Bossa/services/location/geolocation_service.dart';
import 'package:Bossa/util/resource.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static final url = Uri.parse('http://pmckadmin.co.za/bossa-api-portal/');

  static const pilotUrl = 'https://pilot-openapi-qa.azurewebsites.net/';

  static String apiKey = "f9caf517-84ce-4626-85b6-9586b33ed6ce";
  static String username = 'apiportal';
  static String password = 'secret';
  static String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  static Future login(
      String email, String password, String? deviceToken) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    deviceToken ??= await FirebaseService().getMessageToken();
    print(deviceToken);
    Map<String, dynamic> body = {
      "action": "LOGIN_NEW",
      "email": email,
      "password": password,
      "device_token": deviceToken,
    };

    print("body=====${json.encode(body)}");
    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    final data = json.decode(response.body);
    print(data);
    if (data['status'] == 'success') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var lat = preferences.getString("lat");
      var long = preferences.getString('long');

      if (lat == null && long == null) {
        Location? location = await GeoLocationService.get().getLowAccPostion();
        if (location != null) {
          preferences.setString("lat", location.coords.latitude.toString());
          preferences.setString("long", location.coords.longitude.toString());
        }
      }
    }
    print("login data");
    print(response.body);

    await Future.delayed(const Duration(seconds: 5));
    return response.body;
  }

  static Future verifyOTP(Map body) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");
    Response response = await post(
      url, headers: headers,
      //headers: <String, String>{'Authorization': basicAuth},
      body: json.encode(body),
    );
    print("verify data");

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future registration(Map body) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");
    Response response = await post(
      url, headers: headers,
      //headers: <String, String>{'Authorization': basicAuth},
      body: json.encode(body),
    );
    print("registration data");

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future resendOtp(Map body) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");
    Response response = await post(
      url, headers: headers,
      //headers: <String, String>{'Authorization': basicAuth},
      body: json.encode(body),
    );
    print("registration data");

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

static Future forgotPassword(String email, String countryCode, String uuid) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': basicAuth,
    };

    Map<String, dynamic> body = {
      "action": "FORGOT_PASSWORD",
      "email": email,
      "country_code": countryCode,
      "uuid": uuid,
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("forgot password data");
    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future changePassword(Map body) async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    return response.body;
  }

  dropzones(Map body) async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print(response.body);
    return json.decode(response.body);
  }

  static Future<Stores> preferredStore() async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Location? location = await GeoLocationService.get().getLowAccPostion();

    Map<String, dynamic> body = {
      "action": "GET_ALL_BOSSA_RESTAURANTS",
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("stores data");

    var valueMap = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);

    return Stores.fromJson(valueMap);
  }

  Future<Map> geturl(id) async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "GET_BOOKING_URL_BY_RES",
      "restaurant_id": id,
      "uuid": uuid
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("stores data");

    var valueMap = jsonDecode(response.body);
    // print(response.body);
    print(response.body);

    return valueMap;
  }

  Future<Map<dynamic, dynamic>> enterReferral(code) async {
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "REEDEM_REFEREL",
      "uuid": uuid,
      "referel_code": code,
      "is_new": 1
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    var valueMap = jsonDecode(response.body);
    // print(response.body);
    print(response.body);

    return valueMap;
  }

  Future<Map<dynamic, dynamic>> shareReferral() async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {"action": "REFEREL_AND_EARN", "uuid": uuid};

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    var valueMap = jsonDecode(response.body);
    // print(response.body);
    print(response.body);

    return valueMap;
  }

  Future<Map> getpopup(id) async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "GET_POPUPS",
      "restaurant_id": id,
      "uuid": uuid
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("stores data");

    var valueMap = jsonDecode(response.body);
    // print(response.body);
    print(response.body);

    return valueMap;
  }

  Future<Resource<UserModel>> fetchUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var uuid = preferences.getString("uuid");
    print("uuid in api $uuid");
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };

    Map<String, dynamic> body = {"action": "EDIT_PROFILE", "uuid": uuid};

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print("user response ${jsonDecode(response.body)}");

    final data = jsonDecode(response.body);
    preferences.setString("uid", data['data']['id'].toString());

    var baseApiModel = BaseApiModel.fromJson(jsonDecode(response.body));

    if (baseApiModel.status == "success") {
      final userBox = Hive.box('userData');

      userBox.put('data', data);

      return Resource.success(UserModel.fromJson(baseApiModel.data!));
    } else {
      return Resource.error(null);
    }
  }

  static Future<Notifications> getNotificationList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    print("uuid in notification list $uuid");

    Map<String, String> headers = {'Authorization': basicAuth};
    Map<String, dynamic> body = {"action": "GET_NOTIFICATIONS", "uuid": uuid};

    print("body of Notification List ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    final valueMap = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);
    return Notifications.fromJson(valueMap);
  }

  static Future editProfile(Map body) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");
    Response response = await post(
      url, headers: headers,
      //headers: <String, String>{'Authorization': basicAuth},
      body: json.encode(body),
    );
    print("edit Profile data");

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  Future<Resource<RestaurantModel>> restaurantDetails(var id) async {
    Map<String, String> headers = {
      //'content-type': 'application/json',
      'Authorization': basicAuth
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "READ",
      "table": "restaurants",
      "id": id,
      "uuid": uuid
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("response of restaurant detail ${response.body}");
    var baseApiModel = BaseApiModel.fromJson(jsonDecode(response.body));
    print("ksdfslkfjlskjd ${baseApiModel.data}");
    if (baseApiModel.status == "success") {
      return Resource.success(RestaurantModel.fromJson(baseApiModel.data!));
    } else {
      return Resource.error(null);
    }
  }

  static Future reviewRestaurant(Map body) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("review restaurant data");

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future contactRestaurant(Map body) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': basicAuth
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("contact restaurant data");

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future viewNotification(String id) async {
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {"action": "READ_NOTIFICATION", "id": id};

    print("View Notification Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("View Notificaion Data");
    print(response.body);
    print(response.statusCode);

    return response.body;
  }

  static Future aboutUS() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "READ",
      "table": "cms",
      "id": 1,
      "uuid": uuid
    };

    print("About US API Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("About US Data");
    print(response.body);
    print(response.statusCode);

    return response.body;
  }

  static Future<Adverts> advertisement({bool newLocation = false}) async {
    Map<String, String> headers = {'Authorization': basicAuth};

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final uuid = preferences.getString('uuid');
    var latitude = preferences.getString('lat');
    var longitude = preferences.getString('long');
    if (latitude == null && longitude == null) {
      var location = await GeoLocationService.get().getLowAccPostion();
      latitude = location!.coords.latitude.toString();
      longitude = location.coords.longitude.toString();
    }

    if (newLocation) {
      var location = await GeoLocationService.get().getLowAccPostion();
      latitude = location!.coords.latitude.toString();
      longitude = location.coords.longitude.toString();
    }

    Map<String, dynamic> body = {
      "action": "GET_RESELLER_ADVERTISEMENTS",
      "lat": latitude,
      "long": longitude,
      "uuid": uuid,
    };

    print("Advertisement API Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Advertisement Data");
    // print(response.body);
    print(response.statusCode);
    final data = jsonDecode(response.body);

    if (data['data'] == null) {
      return Adverts.fromJson([]);
    }

    return Adverts.fromJson(data['data']);
  }

  static Future<News> newsPromotion() async {
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    Map<String, dynamic> body = {
      "action": "READ",
      "table": "news_promotion",
      "uuid": uuid
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    Logger.info(response.body);

    Logger.info(response.statusCode.toString());

    final valueMap = jsonDecode(response.body);
    return News.fromJson(valueMap);
  }

  static Future<Offers> getRewardsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_REWARDS_ALL",
      "uuid": uuid,
    };

    print("Rewards List API Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    final valueMap = jsonDecode(response.body);
    print(response.body);
    print(response.statusCode);
    return Offers.fromJson(valueMap);
  }

  static Future getPoints(var pin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_POINTS",
      "uuid": uuid,
      "pin": pin
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("get points data");

    print(response.body);
    return response.body;
  }

  static Future redeemPoints(var pin, var rewardId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "REDEEM_POINTS",
      "uuid": uuid,
      "code": pin,
      "reward_id": rewardId
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("get points data");

    print(response.body);
    return response.body;
  }

  static Future redeemVoucher(var rewardId, var resID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "SET_USER_REWARDS",
      "uuid": uuid,
      "reward_id": rewardId,
      "restaurant_id": resID
    };

    print("Redeem Coucher Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Redeem Voucher data");

    print(response.body);
    return response.body;
  }

  static Future getVoucher(String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('uid');
    print('Uid --> $userId');

    print('Url --> $url');

    Map<String, String> headers = {'Authorization': basicAuth};
    print('Header --> $headers');

    Map<String, dynamic> body = {
      "action": "GET_VOUCHER_VALUE",
      "code": code,
      "table": 'communities_initiatives',
      "user_id": userId
    };

    print("Get Voucher Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Get Voucher data");

    print(response.body);
    return response.body;
  }

  static Future setCovidData(var resID, var ans1, var ans2, var ans3) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "SET_COVID_DATA",
      "uuid": uuid,
      "restaurant_id": resID,
      "answer_1": ans1,
      "answer_2": ans2,
      "answer_3": ans3
    };

    print("Covid API Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Covid API Data data");

    print(response.body);
    return response.body;
  }

  static Future setMembership(var membershipNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "SET_MEMBERSHIP",
      "uuid": uuid,
      "membership_number": membershipNumber
    };

    print("Membership Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter Membership Data");

    print(response.body);
    return response.body;
  }

  static Future<RedeemHistoryModel> redeemHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "REDEEMED_HISTORY",
      "uuid": uuid,
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    final valueMap = jsonDecode(response.body);
    // print(response.body);
    return RedeemHistoryModel.fromJson(valueMap);
  }

  Future userPointInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};
    print(basicAuth);
    Map<String, dynamic> body = {
      "action": "USER_POINTS_INFO",
      "uuid": uuid,
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print("response of user get point : ${response.body}");

    return response.body;
  }

  static Future<Offers> allOffers() async {
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    Map<String, dynamic> body = {
      "action": "READ",
      "table": "rewards",
      "uuid": uuid
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print("all offers : ${response.body}");

    final valueMap = jsonDecode(response.body);
    return Offers.fromJson(valueMap);
  }

  static Future setSpurFamilyCard(var spurFamilyCardNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "UPDATE_SPUR_FAMILY_CARD",
      "uuid": uuid,
      "spur_family_card_number": spurFamilyCardNumber
    };

    print("SpurFamilyCard Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter SpurFamilyCard Data");

    print(response.body);
    return response.body;
  }

  static Future setpanarottisCard(var panarottisNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "UPDATE_PANAROTTIS_REWARDS_CARD",
      "uuid": uuid,
      "panarottis_rewards_card_number": panarottisNumber
    };

    print("SpurFamilyCard Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter panarottisCard Data");

    print(response.body);
    return response.body;
  }

  Future userSpurInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_CARD_NUMBER_BY_UUID",
      "uuid": uuid,
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print("response of user get point : ${response.body}");

    return response.body;
  }

  static Future setjohnClubNumber(var johnClubNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "JOHNS_CLUB_CARD",
      "uuid": uuid,
      "johns_club_card_number": johnClubNumber
    };

    print("SpurFamilyCard Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter Johns family card Data");

    print(response.body);
    return response.body;
  }

  static Future setRocoLoveNumber(var rocoLoveNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "ROCO_LOVE_CARD",
      "uuid": uuid,
      "roco_love_card_number": rocoLoveNumber
    };

    print("SpurFamilyCard Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter Roco Love Card Data");

    print(response.body);
    return response.body;
  }

  static Future getHealthUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_HEALTH_URL",
      "uuid": uuid,
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("get health url");

    print(response.body);
    return response.body;
  }

  static Future getNotification({latitude, longitude}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uid = preferences.getString('uid');
    print('Uid --> $uid');

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "SEND_NOTIFICATION_TO_USER",
      "latitude": latitude,
      "longitude": longitude,
      "user_id": uid
    };

    print('headers --> $headers');
    print('Body --> $body');

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print('Response --> ${response.body}');
    print('Response --> ${response.statusCode}');
    print("getNotification");
    return response.body;
  }

  static Future getGeoFence() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_GEO_FANCES",
      "uuid": uuid,
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("getGeoFence");

    print(response.body);
    return response.body;
  }

  static Future<Specials> getSpecials(
      {bool newLocation = false, bool fromOrders = false}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(
        'NEWLOCATION :::::::getSpecials::::::::FLAG ::::::::::::$newLocation');
    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};
    var latitude = preferences.getString('lat');
    var longitude = preferences.getString('long');
    if (latitude == null && longitude == null) {
      var location = await GeoLocationService.get().getLowAccPostion();
      latitude = location!.coords.latitude.toString();
      longitude = location.coords.longitude.toString();
    }

    if (newLocation) {
      var location = await GeoLocationService.get().getLowAccPostion();
      latitude = location!.coords.latitude.toString();
      longitude = location.coords.longitude.toString();
    }

    Map<String, dynamic> body = {
      "action": "GET_RES_SPECIALS",
      "uuid": uuid,
      "index": 'special',
      "lat": latitude,
      "long": longitude,
      "fromOrders": fromOrders
    };
    print("SPECIALS Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print(response.body);
    final valueMap = jsonDecode(response.body);
    return Specials.fromJson(valueMap);
  }

  static Future<Restaurants> getRestautantlist(
      {bool newLocation = false, bool fromOrders = false}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(
        'NEWLOCATION :::::::getRestautantlist::::::::FLAG ::::::::::::$newLocation');
    var latitude = preferences.getString('lat');
    var longitude = preferences.getString('long');
    if (latitude == null && longitude == null) {
      var location = await GeoLocationService.get().getLowAccPostion();
      latitude = location!.coords.latitude.toString();
      longitude = location.coords.longitude.toString();
    }

    if (newLocation) {
      var location = await GeoLocationService.get().getLowAccPostion();
      latitude = location!.coords.latitude.toString();
      longitude = location.coords.longitude.toString();
    }

    var uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_RES_SPECIALS",
      "uuid": uuid,
      "index": 'restaurant',
      "lat": latitude,
      "long": longitude,
      "fromOrders": fromOrders
    };

    print("SPECIALS Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter Roco Love Card Data");

    print(response.body);
    final valueMap = jsonDecode(response.body);
    return Restaurants.fromJson(valueMap);
  }

  Future<String> getTierInfo(String userId) async {
    final response = await post(
      Uri.parse('http://pmckadmin.co.za/bossa-api-portal/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"action": "GET_TIER_USER_INFO", "user_id": userId}),
    );
    print(response.body);
    return response.body;
  }

  static Future<String> getPromotionType(String promotionType) async {
    final response = await post(
      Uri.parse('http://pmckadmin.co.za/bossa-api-portal/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "action": "GET_PROMOTIONS_BY_TYPE",
        "promotion_type": promotionType
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to fetch promotions: ${response.statusCode}');
    }
  }

  Future<Map> deleteaddr(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "DELETE_USER_ADDRESS",
      "uuid": uuid,
      "id": id
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print(response.body);
    return json.decode(response.body);
  }

  Future<List> getUserAddressList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_USER_ADDRESS",
      "uuid": uuid,
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print(response.body);
    return json.decode(response.body);
  }

  getDropZones(restid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_DROPZONES",
      "uuid": uuid,
      "restaurant_id": restid
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print(response.body);
    return json.decode(response.body);
  }

  getCustomerCare() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_CARE_WHATSAPP_NUMBER",
      "uuid": uuid,
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print(response.body);
    return json.decode(response.body);
  }

  Future<Address?> getUserAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_USERADDRESS_BY_ID",
      "uuid": uuid,
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    print(response.body);
    final valueMap = jsonDecode(response.body);
    if (valueMap['status'] == "failed" || valueMap['data'] == null) {
      return null;
    }

    return Address.fromJson(valueMap['data']);
  }

  Future<bool> saveAddress(Address address) async {
    Map<String, String> headers = {'Authorization': basicAuth};

    var location = await GeoLocationService.get().getLowAccPostion();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uid = preferences.getString("uid");
    final uuid = preferences.getString("uuid");

    address.latitude = location!.coords.latitude.toString();
    address.longitude = location.coords.longitude.toString();
    address.uuid = uid != null ? int.parse(uid) : 0;
    print(address.address_id);
    Map<String, dynamic> body = {
      "action": "SAVE_ADDRESS",
      "uuid": uuid,
      "nickname": address.name,
      "address": address.address,
      "apart": address.apart,
      'road': address.road,
      'business': address.business,
      'area': address.area,
      'postal_code': address.postalCode,
      'latitude': address.latitude,
      'longitude': address.longitude,
      "address_id": address.address_id
    };

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final j = jsonDecode(response.body);
    return j['status'] == 'success';
  }

  Future<Favourites> getFavourites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_USER_FAVOURITES",
      "uuid": uuid,
    };

    final resp = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final value = jsonDecode(resp.body);
    return Favourites.fromJsonList(value['data']);
  }

  Future<OrderHistoy> getOrderHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_USER_HISTORY",
      "uuid": uuid,
    };

    final resp = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final value = jsonDecode(resp.body);

    return OrderHistoy.fromJsonList(value);
  }

  Future<bool> saveUserOrder(Order order) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_USER_HISTORY",
      "uuid": uuid,
      "order": order
    };
    final resp = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final value = jsonDecode(resp.body);

    return success(value['status']);
  }

  Future<OrderCallback> createOrderPilot(Order order) async {
    var url = Uri.parse("${pilotUrl}OnlineOrder/Create");

    Map<String, String> headers = {'Authorization': basicAuth};

    final resp = await post(
      url,
      headers: headers,
      body: json.encode(order),
    );

    final value = jsonDecode(resp.body);
    return OrderCallback.fromJson(value);
  }

  Future<Store> getStore() async {
    Map<String, String> headers = {'Authorization': basicAuth};

    final resp = await get(
      url,
      headers: headers,
    );

    final value = jsonDecode(resp.body);
    return Store.fromJson(value);
  }

  Future<Partners> getPartners() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_RESELLER_PARTNERS",
      "uuid": uuid
    };
    print('URL : $body');
    final resp = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final value = jsonDecode(resp.body);
    return Partners.fromJson(value);
  }

  Future<DishCategories> getStoreItems(int? id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_STORE_ITEMS",
      "uuid": uuid,
      'restaurant_id': id
    };

    final resp = await post(url, headers: headers, body: json.encode(body));
    print(resp);
    final value = jsonDecode(resp.body);

    if (value['data'] != null) {
      print(value['data']);
      final data = value['data'];
      if (data is Map) {
        return DishCategories.fromJson(value['data']);
      }
    }

    return DishCategories();
  }

  Future<Restaurant> GetRestaurantById(int? id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_RESTAURANT_BY_ID",
      "uuid": uuid,
      'restaurant_id': id
    };
    final resp = await post(url, headers: headers, body: json.encode(body));

    final value = jsonDecode(resp.body);
    print(resp.body);
    return Restaurant.fromJson(value['data']);
  }

  Future<AddOnsModel> GetAddOns(int? id, int itemId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final uuid = preferences.getString("uuid");
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_RESTAURANT_ADDONS",
      'restaurant_id': id,
      "item_id": itemId,
      "uuid": uuid
    };
    final resp = await post(url, headers: headers, body: json.encode(body));

    //var value = jsonDecode(resp.body);

    final value = jsonDecode(resp.body);
    return (AddOnsModel.fromJson(value));
  }

  Future<ReturnOrder> saveOrder(SendOrder data) async {
    Map<String, String> headers = {'Authorization': basicAuth};

    final jsonValue = data.toJson();

    final resp =
        await post(url, headers: headers, body: json.encode(jsonValue));

    final value = jsonDecode(resp.body);
    print((jsonValue));
    return ReturnOrder.fromJson(value);
  }

  Future<Restaurants?> search(String lat, String long) async {
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final uuid = preferences.getString("uuid");
    Map<String, dynamic> body = {
      "action": "SEARCH_RES",
      "lat": lat,
      "long": long,
      "uuid": uuid
    };

    print("Search Data Body --->${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("Enter Roco Love Card Data");

    print(response.body);
    final valueMap = jsonDecode(response.body);
    if (valueMap['status'] == "failed") {
      return null;
    }

    return Restaurants.fromJson(valueMap['data']);
  }

  static Future<bool> delete() async {
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {"action": "DELETE_USER", "uuid": uuid};
    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final valueMap = jsonDecode(response.body);

    if (valueMap['status'] == "failed") {
      return false;
    }

    return true;
  }

  static Future<dynamic> checkPromo(String code, int? res) async {
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "CHECK_PROMO",
      "uuid": uuid,
      "code": code,
      "res": res
    };
    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final valueMap = jsonDecode(response.body);

    if (valueMap['status'] == "failed") {
      return null;
    }

    return valueMap['data'];
  }

  static Future<dynamic> checkValid(
    String code,
  ) async {
    print("Code$code");
    Map<String, String> headers = {'Authorization': basicAuth};
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "USER_DIGITAL_VOUCHER_AVAILIBITY",
      "uuid": uuid,
      "code": code,
    };
    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final valueMap = jsonDecode(response.body);

    if (valueMap['status'] == "failed") {
      return null;
    }
    print(valueMap['voucher']['min_voucher_amount']);
    return valueMap['voucher']['min_voucher_amount'] ?? "0.0";
  }

  // Future<Resource<DigitalVoucherModel>> getDigitalVoucher() async {
  //   var url = Uri.parse(pilotUrl + "USER_DIGITAL_VOUCHER_AVAILIBITY");

  //   Map<String, String> headers = {
  //     'ApiKey': apiKey,
  //     'accept': 'application/json',
  //     'Content-Type': 'application/json'
  //   };

  // }

  bool validateStatus(int status) => (status > 200 && 300 < status);

  bool emptyBody(String body) => (body != "");

  bool success(String status) => (status == "S");

  static Future<CategoryListModel> categoryListApi(String id) async {
    Map<String, String> headers = {'Authorization': basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_CATEGORY_BY_RES",
      "restaurant_id": id
    };

    print("View categoryListApi Body ---> ${json.encode(body)}");

    Response response = await post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    print("View categoryListApi Data");
    print(response.body);
    print(response.statusCode);

    return CategoryListModel.fromJson(jsonDecode(response.body));
  }
}
