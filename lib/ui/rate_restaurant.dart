import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/ui/restaurants_page.dart';

import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class RateRestaurant extends StatefulWidget {
  var navkey = Get.key;
  String? name;
  String? title;
  String? location;
  var id;
  var image;
  String? rateLink;
  var navId;
  RateRestaurant({Key? key, data}) : super(key: key) {
    id = data[0];
    name = data[1];
    location = data[2];
    image = data[3];
    rateLink = data[4];
    navId = data[5];
    title = data[6];
  }
  @override
  _RateRestaurantState createState() => _RateRestaurantState();
}

class _RateRestaurantState extends State<RateRestaurant> {
  TextEditingController message = TextEditingController();
  double starRating = 1;
  bool loading = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            MainAppBar(widget.title!, false, () => Get.back(id: widget.navId)),
        body: Scaffold(
          body: WebView(
            initialUrl: '${widget.rateLink}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
      ),
    );
  }

  reviewApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");

    Map<String, dynamic> body = {
      "action": "RATING_SUBMIT",
      "rating": starRating,
      "review": message.text,
      "restaurant_id": widget.id,
      "uuid": uuid
    };
    print("review body $body");
    var res = await Api.reviewRestaurant(body);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });
      CommonMethods().customDialog(context, msg: "Thanks for your rating.",
          onTap: () {
        Get.to(() => RestaurantsPage());
      });
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'][0], context);
    }
  }
}
