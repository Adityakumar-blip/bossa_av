import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String aboutUsText = "";
  String dummyText =
      "Hello User,\nThankyou for using our application. If you like our application then please don't forgot to rate us 5 star.\n\n Thank you";
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    aboutUSData();
    super.initState();
  }

  aboutUSData() async {
    var res = await Api.aboutUS();
    // print(res);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      aboutUsText = valueMap['data']['page_content'];
      if (aboutUsText == "") {
        setState(() {
          aboutUsText = dummyText;
        });
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        aboutUsText = dummyText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    var one = Get.arguments ?? "";
    var bar = const MainAppBar("About Us", false, null);
    if (one != "") {
      bar = MainAppBar("About Us", false, () => Get.back());
    }

    return SafeArea(
      child: Scaffold(
        appBar: bar,
        body: Container(
          child: isLoading == true
              ? Center(child: CommonMethods().loader())
              : Center(
                  child: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Container(
                                height: height * 0.52,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      aboutUsText,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontFamily: 'Muli-Bold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
