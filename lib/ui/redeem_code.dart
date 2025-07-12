import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/reward_dashboard.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

// ignore: must_be_immutable
class RedeemCode extends StatefulWidget {
  var itemName;
  var price;
  var rewardId;
  RedeemCode({Key? key, this.itemName, this.price, this.rewardId})
      : super(key: key);
  @override
  _RedeemCodeState createState() => _RedeemCodeState();
}

class _RedeemCodeState extends State<RedeemCode> {
  TextEditingController enterCode = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar("To Redeem", false, () => Get.back()),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: SizeConfig.screenHeight * 0.52,
                  width: SizeConfig.screenWidth,
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To Redeem "${widget.itemName}" for ${widget.price} points',
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Muli-Bold',
                            fontWeight: FontWeight.bold,
                            color: Color(0xffEDCC40)),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 3,
                        width: SizeConfig.screenWidth * 0.6,
                        color: const Color(0xffEDCC40),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Please ask your waiter or waitress to enter there code",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Muli-Bold',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffEDCC40)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                controller: enterCode,
                                decoration: const InputDecoration(
                                  hintText: "#####",
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Muli-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 10.0),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 3),
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 4),
                              child: loading
                                  ? CommonMethods().loader()
                                  : CustomButton(
                                      text: 'Submit',
                                      onTap: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        if (enterCode.text == "") {
                                          setState(() {
                                            loading = false;
                                          });
                                          CommonMethods().showFlushBar(
                                              "Please enter code", context);
                                        } else {
                                          enterPoints();
                                        }
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 3,
                      bottom: SizeConfig.blockSizeVertical * 2),
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 4),
                  child: CustomButton(
                    text: 'Go Back',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RewardsDashboard()));
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

  enterPoints() async {
    var res = await Api.redeemPoints(enterCode.text, widget.rewardId);
    Map valueMap = jsonDecode(res);
    print("response of points :  $valueMap");
    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });

      Get.to(() => RedeemSuccess(
            itemName: widget.itemName,
            price: widget.price,
          ));
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'], context);
    }
  }
}

// ignore: must_be_immutable
class RedeemSuccess extends StatefulWidget {
  var itemName;
  var price;
  RedeemSuccess({Key? key, this.itemName, this.price}) : super(key: key);
  @override
  _RedeemSuccessState createState() => _RedeemSuccessState();
}

class _RedeemSuccessState extends State<RedeemSuccess> {
  Future<bool> _onWillPop() {
    Get.offNamed(Routes.REWARDDASH);

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar("", false, () => Get.offNamed(Routes.REWARDDASH)),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: SizedBox(
                height: SizeConfig.screenHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text(
                        "Thank you. You have successfully redeemed \"${widget.itemName}\" for ${widget.price} points",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Muli-Bold',
                            fontWeight: FontWeight.bold,
                            color: Color(0xffEDCC40)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 4),
                      child: CustomButton(
                        text: 'Return',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RewardsDashboard()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
