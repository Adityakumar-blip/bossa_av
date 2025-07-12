import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

import '../util/NavConst.dart';

class JohnClubCard extends StatefulWidget {
  String? firstName;
  String? lastName;
  var navId;
  JohnClubCard({Key? key, data}) : super(key: key) {
    firstName = data["firstName"];
    lastName = data["lastName"];
    navId = data["navId"] ?? NavConst.profile;
  }
  @override
  _JohnClubCardState createState() => _JohnClubCardState();
}

class _JohnClubCardState extends State<JohnClubCard> {
  bool isLoading = false;
  TextEditingController johnClubNumber = TextEditingController();
  bool verify = false;
  String errorMessage = "";
  Api api = Api();
  String? memberNumber;
  bool showMessage = false;

  @override
  void initState() {
    isLoading = true;
    getMembershipNumber();
    super.initState();
  }

  getMembershipNumber() async {
    var res = await api.userSpurInfo();
    Map valueMap = jsonDecode(res);
    print("Points Data ---> $valueMap");
    memberNumber = valueMap['data']['johns_club_card_number'];
    setState(() {
      isLoading = false;
    });
  }

  membershipApi(String johnClubNumber) async {
    var res = await Api.setjohnClubNumber(johnClubNumber);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      setState(() {
        memberNumber = johnClubNumber;
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = valueMap['message'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "John's Club Card", false, () => Get.back(id: widget.navId)),
        body: isLoading == true
            ? Center(child: CommonMethods().loader())
            : SafeArea(
                bottom: false,
                child: SizedBox(
                  height: SizeConfig.screenHeight * 0.85,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Container(
                              height: SizeConfig.screenHeight * 0.52,
                              width: SizeConfig.screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: memberNumber != null
                                          ? const Text(
                                              "Your John's Club Card Number is",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Muli-Bold',
                                                  color: Color(0xffEDCC40)))
                                          : const Text("John's Club Card",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Muli-Bold',
                                                  color: Color(0xffEDCC40))),
                                    ),
                                    memberNumber != null
                                        ? Text(
                                            '$memberNumber',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Muli-Bold',
                                                color: Color(0xff0E0E0E)),
                                          )
                                        : const Text(
                                            "Please enter John's Club card Number",
                                            style: TextStyle(
                                                fontFamily: 'Muli-Bold')),
                                    memberNumber != null
                                        ? Container()
                                        : Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 30.0,
                                                    bottom: 15.0,
                                                    left: 20,
                                                    right: 20),
                                                child: Text(
                                                    "Please enter your John's Club Card number that begins with 3858",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Muli-Bold')),
                                              ),
                                              errorMessage == ""
                                                  ? verify == true
                                                      ? johnClubNumber
                                                                  .text.length <
                                                              6
                                                          ? const Text(
                                                              'Please Enter at least 6 digits.',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily:
                                                                      'Muli-Bold'),
                                                            )
                                                          : const Text('')
                                                      : const Text('')
                                                  : Text(
                                                      errorMessage,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                              'Muli-Bold',
                                                          color: Colors.red),
                                                    ),
                                              Column(
                                                children: [
                                                  showMessage
                                                      ? const Text(
                                                          "please make sure number start with 3858",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Muli-SemiBold',
                                                              color: Color(
                                                                  0xffFF0000)),
                                                        )
                                                      : Container(),
                                                  TextFormField(
                                                    controller: johnClubNumber,
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .deny(' ')
                                                    ],
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'Muli-SemiBold',
                                                        color:
                                                            Color(0xff0E0B20)),
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            'Enter Number Here',
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                'Muli-Light',
                                                            fontSize: SizeConfig
                                                                    .blockSizeVertical *
                                                                2.2,
                                                            color: const Color(
                                                                0xff0E0B20))),
                                                  ),
                                                  const SizedBox(
                                                    height: 35.0,
                                                  ),
                                                  CustomButton(
                                                    width: 150,
                                                    text: 'Submit',
                                                    onTap: () {
                                                      setState(() {
                                                        errorMessage = "";
                                                        verify = true;
                                                        isLoading = true;
                                                      });
                                                      if (johnClubNumber.text
                                                              .startsWith(
                                                                  "3858", 0) ||
                                                          johnClubNumber.text
                                                              .startsWith(
                                                                  "4858", 0)) {
                                                        membershipApi(
                                                            johnClubNumber
                                                                .text);
                                                        setState(() {
                                                          showMessage = false;
                                                        });
                                                        // Navigator.pop(context);
                                                      } else {
                                                        setState(() {
                                                          showMessage = true;
                                                          isLoading = false;
                                                        });
                                                        print(
                                                            "please make sure number start with 3858");
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ],
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
    );
  }
}
