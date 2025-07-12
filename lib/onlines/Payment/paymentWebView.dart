import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/onlines/Payment/payment_controller.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends GetView<PaymentController> {
  final int amount;
  const PaymentWebView({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (controller) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              appBar("Payment", false, () => Get.back()),
              const WebView()
            ],
          ),
        ),
      ),
    );
  }
}
