import 'dart:async';

import 'package:Bossa/model/orders/return_order.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  @override
  var controller = Get.put(PaymentController());

  final Completer<WebViewController> _webCont = Completer<WebViewController>();

  late ReturnOrder returnOrder;
  late String url;

  PaymentScreen({super.key, ReturnOrder? data}) {
    returnOrder = data!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(" Payment", false, () => Get.back()),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.screenHeight,
            child: SafeArea(
              child: WebView(
                // ignore: prefer_collection_literals
                javascriptChannels: <JavascriptChannel>{
                  _toasterJavascriptChannel()
                },
                onPageFinished: (url) {},
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: returnOrder.paymentLink,

                onWebViewCreated: (WebViewController webViewController) {
                  _webCont.complete(webViewController);
                },
                onProgress: (int progress) {
                  print('WebView is loading (progress : $progress%)');
                },

                gestureNavigationEnabled: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPageTitle() {
    _webCont.future.then((webViewController) {
      webViewController
          .runJavascript('TopBarJsChannel.postMessage(document.title);');
    });
  }

  JavascriptChannel _toasterJavascriptChannel() {
    return JavascriptChannel(
        name: 'PaymentCallback',
        onMessageReceived: (JavascriptMessage message) {
          print(" PaymentCallback - ${message.message}");
          if (message.message == "success") {
            //controller.Success();
            print("success payment");
            Get.toNamed(Routes.PAYMENTSUCCES);
          } else {
            print("failed payment");
            Get.toNamed(Routes.PAYMENTFAIL);
            //Future.delayed(const Duration(seconds: 3), () => Get.back());
            // Get.snackbar("Payment", "Failed to Process",
            //     duration: const Duration(seconds: 2));
          }
        });
  }
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 25.h,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(200);
}
