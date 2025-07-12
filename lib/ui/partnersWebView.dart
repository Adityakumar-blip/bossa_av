import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/main_app_bar.dart';

class PartnerswebView extends StatefulWidget {
  String url = "";
  PartnerswebView({Key? key, newUrl}) : super(key: key) {
    url = newUrl;
  }

  @override
  State<PartnerswebView> createState() => _PartnerswebViewState();
}

class _PartnerswebViewState extends State<PartnerswebView> {
  final Completer<WebViewController> _webCont = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar("Proud Partners", false, () => Get.back()),
        body: SafeArea(
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webCont.complete(webViewController);
            },
          ),
        ),
      ),
    );
  }
}
