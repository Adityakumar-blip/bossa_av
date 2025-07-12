import 'package:flutter/material.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

// import 'package:social_share/social_share.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({Key? key}) : super(key: key);

  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
  List<Color> borderColor = [
    const Color(0xff1bd741),
    const Color(0xff1977f3),
    Colors.black
  ];
  List<String> icon = [
    "whatsapp_icon.png",
    "facebook_icon.png",
    "sms_icon.png"
  ];
  bool platform = false;
  // String message =
  //     "Get rewarded when visiting participating restaurants, receive 10 points on registration.\n\nClick to the given link.\n\nhttps://luna9.co.za/";
  String message =
      "Get rewarded when visiting participating restaurants, receive a R20 Voucher when registering. Download now, click here. https://onelink.to/rpxc37";

  shareSMS() async {
    // SocialShare.shareSms(message)
    // .then((value) => CommonMethods().showFlushBar("$value", context));
  }

  shareWatsapp() async {
    // SocialShare.shareWhatsapp(
    // message,
    // ).then((value) => CommonMethods().showFlushBar("$value", context));
  }

  shareOnFacebook() async {
    // final FlutterShareMe flutterShareMe = FlutterShareMe();
    // flutterShareMe
    // .shareToFacebook(msg: message, url: "https://luna9.co.za/")
    // .then((value) => CommonMethods().showFlushBar("$value", context));
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      platform = false;
    }
    if (Platform.isIOS) {
      platform = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Share App", false, () => Get.back(id: NavConst.notifyNav)),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: SizedBox(
                    height: height * 0.52,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thank you for wanting to share our app!!",
                          style: TextStyle(
                              fontFamily: 'Muli-SemiBold',
                              fontSize: 15.0,
                              color: Color(0xffEDCC40)),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 3,
                          width: width * 0.6,
                          color: const Color(0xffEDCC40),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text(
                          "How would you like to share it?",
                          style: TextStyle(
                              fontFamily: 'Muli-SemiBold',
                              fontSize: 15.0,
                              color: Colors.black),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          height: height * 0.42,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10,
                                            bottom: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // FlutterShareMe().shareToWhatsApp(msg: message);
                                            // _sendWhatsApp();
                                            shareWatsapp();
                                          },
                                          child: Container(
                                            height: height * 0.2,
                                            width: width * 0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: const Color(0xff1bd741),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff1bd741),
                                                  width: 10),
                                            ),
                                            child: Image.asset(
                                                'assets/images/whatsapp_icon.png',
                                                scale: 2.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10,
                                            bottom: 10.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            shareOnFacebook();
                                          },
                                          child: Container(
                                            height: height * 0.2,
                                            width: width * 0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff1977f3),
                                                  width: 10),
                                            ),
                                            child: Image.asset(
                                                'assets/images/facebook_icon.png',
                                                scale: 2.5),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    platform
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10,
                                                  top: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  shareSMS();
                                                },
                                                child: Container(
                                                  height: height * 0.2,
                                                  width: width * 0.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 10),
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/sms_icon.png',
                                                    scale: 2.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10, top: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: message))
                                                .then((result) {
                                              CommonMethods().showFlushBar(
                                                  "Copied to Clipboard",
                                                  context);
                                            });
                                          },
                                          child: Container(
                                            height: height * 0.2,
                                            width: width * 0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/images/copylink_icon.png',
                                                    scale: 2.5),
                                                const Text(
                                                  "Copy Link",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: 'Muli-Bold',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 2,
                      bottom: SizeConfig.blockSizeVertical),
                  child: CustomButton(
                    text: 'Go Back',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
