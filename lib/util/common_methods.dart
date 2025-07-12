import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Bossa/ui/login.dart';
import 'package:Bossa/ui/redeem_restaurant.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commonWidgets/textField.dart';
import '../network/api.dart';
import '../ui/my_profile.dart';

class CommonMethods {
  showFlushBar(String value, BuildContext context) async {
    return Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.easeInOut,
      backgroundColor: Colors.black,
      boxShadows: const [
        BoxShadow(
            color: Color(0xffEDCC40), offset: Offset(0.0, 1.0), blurRadius: 1.0)
      ],
      // backgroundGradient: LinearGradient(colors: [Color(0xffEDCC40), Colors.white70]),
      isDismissible: false,
      duration: const Duration(seconds: 3),
      messageText: Text(
        value,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  customAlert(BuildContext context, Function onTap) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: const Color(0xffEDCC40), width: 8.0),
              ),
              alignment: Alignment.center,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Log Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEDCC40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffEDCC40),
                            ),
                            child: TextButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Muli-Bold'),
                              ),
                              onPressed: () {
                                onTap();
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffEDCC40),
                            ),
                            child: TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Muli-Bold'),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  enterReferal(BuildContext context, t) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: const Color(0xffEDCC40), width: 8.0),
              ),
              alignment: Alignment.center,
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ENTER REFERRAL CODE".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    CommonTextField(
                      obscureText: false,
                      hintText: "Enter code",
                      controller: t,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xffEDCC40),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'VERIFY',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontFamily: 'Muli-Bold'),
                                ),
                                onPressed: () async {
                                  Api api = Api();
                                  await api
                                      .enterReferral(t.text.toString())
                                      .then((value) async {
                                    print(value["status"]);
                                    await CommonMethods().showFlushBar(
                                        value["message"], context);
                                    if (value["message"]
                                        .toString()
                                        .toLowerCase()
                                        .contains("successfully")) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()),
                                                (route) => false);
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xffEDCC40),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontFamily: 'Muli-Bold'),
                                ),
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        (route) => false);
                                  });
                                  // Navigator.of(context).pop(context);
                                  // Get.offAndToNamed(Routes.LOGIN);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  customShare(BuildContext context, value) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: const Color(0xffEDCC40), width: 8.0),
              ),
              alignment: Alignment.center,
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Share Referral Code".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text(
                        "REFER & EARN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEDCC40),
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical *
                          (SizeConfig.isDeviceLarge ? 6.5 : 7.5),
                      width: SizeConfig.blockSizeHorizontal * 88,
                      margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: SizeConfig.blockSizeVertical * 2,
                          bottom: SizeConfig.blockSizeVertical * 2),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x23000000),
                                offset: Offset(0, 5),
                                blurRadius: 13,
                                spreadRadius: 0)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(
                              color: const Color(0xff0E0B20),
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical * 2.3,
                              fontFamily: 'Muli-Bold'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xffEDCC40),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'SHARE',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontFamily: 'Muli-Bold'),
                                ),
                                onPressed: () {
                                  Share.share(
                                    "BOSSA REWARDS! Your friend has shared the BOSSA REWARDS locals app with you, click https://onelink.to/rpxc37 to download now and enter referral code $value on registration!",
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xffEDCC40),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontFamily: 'Muli-Bold'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  customAlertDelete(BuildContext context, Function onTap) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: const Color(0xffEDCC40), width: 8.0),
              ),
              alignment: Alignment.center,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Delete profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEDCC40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffEDCC40),
                            ),
                            child: TextButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Muli-Bold'),
                              ),
                              onPressed: () {
                                onTap();
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffEDCC40),
                            ),
                            child: TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Muli-Bold'),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: currentDate);
    if (pickedDate != null && pickedDate != currentDate) {
      currentDate = pickedDate;
    }
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    return formattedDate;
  }

  void customDialog(BuildContext context,
      {required String msg, required Function onTap}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: const Color(0xffEDCC40), width: 8.0),
              ),
              alignment: Alignment.center,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color(0xffEDCC40),
                        ),
                        child: TextButton(
                          child: const Text(
                            'RETURN',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontFamily: 'Muli-Bold'),
                          ),
                          onPressed: () {
                            onTap();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  loader({bool white = false}) {
    final color = white ? Colors.white : const Color(0xffEDCC40);
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  void offerDialog(
    BuildContext context,
    var rewardId,
    var name,
    var points,
    var uuid,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: const Color(0xffEDCC40), width: 8.0),
              ),
              alignment: Alignment.center,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You are about to redeem $name for $points points",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Muli-Bold',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEDCC40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffEDCC40),
                            ),
                            child: TextButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Muli-Bold'),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RedeemRestaurant(
                                          uuid: uuid,
                                          voucherName: name,
                                          voucherPrice: points,
                                          rewardId: rewardId,
                                        )));
                                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RedeemCode(
                                //    itemName: name, price: points,rewardId: index,)));
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xffEDCC40),
                            ),
                            child: TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Muli-Bold'),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
