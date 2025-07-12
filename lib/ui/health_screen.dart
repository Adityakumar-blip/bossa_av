import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/ui/health_controller.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HealthScreen extends GetView<HealthController> {
  final cont = Get.put(HealthController());

  HealthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var one = Get.arguments ?? "";

    var bar = MainAppBar(
        "Whatsapp Support", false, () => Get.back(id: NavConst.homeNav));
    if (one != "") {
      bar = MainAppBar("Whatsapp Support", false, () => Get.back());
    }

    return GetBuilder(
      init: cont,
      builder: (_) => SafeArea(
        child: Scaffold(
          appBar: bar,
          body: SizedBox(
            height: SizeConfig.screenHeight,
            child: (cont.webUrl == "")
                ? Center(child: CommonMethods().loader())
                : SafeArea(
                    child: WebView(
                      initialUrl: cont.webUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        // _controller.complete(webViewController);
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
