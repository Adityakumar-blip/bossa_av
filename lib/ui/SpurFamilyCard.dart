import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

class SpurFamilyCard extends StatefulWidget {
  String? firstName;
  String? lastName;
  var navId;
  SpurFamilyCard({Key? key, data}) : super(key: key) {
    firstName = data["firstName"];
    lastName = data["lastName"];
    navId = data["navId"] ?? NavConst.profile;
  }

  @override
  _SpurFamilyCardState createState() => _SpurFamilyCardState();
}

class _SpurFamilyCardState extends State<SpurFamilyCard> {
  bool isLoading = false;
  TextEditingController spurFamilyNumber = TextEditingController();
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
    memberNumber = valueMap['data']['spur_family_card_number'] ?? "";
    setState(() {
      isLoading = false;
    });
  }

  membershipApi(String membershipNumber) async {
    var res = await Api.setSpurFamilyCard(membershipNumber);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      setState(() {
        memberNumber = membershipNumber;
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Spur Family Card", false, () => Get.back(id: widget.navId)),
        body: SizedBox(
          height: SizeConfig.screenHeight * 0.8,
          child: isLoading == true
              ? Center(child: CommonMethods().loader())
              : SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Container(
                              height: height * 0.52,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                          'Your Spur Family Card Number is',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Muli-Bold',
                                              color: Color(0xffEDCC40))),
                                    ),
                                    memberNumber != null
                                        ? Text(
                                            memberNumber ?? "",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Muli-Bold',
                                                color: Color(0xff0E0E0E)),
                                          )
                                        : const Text(
                                            'Please enter spur family card',
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
                                                    'Please enter your Spur Family Card number that begins with 6787',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Muli-Bold')),
                                              ),
                                              errorMessage == ""
                                                  ? verify == true
                                                      ? spurFamilyNumber
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
                                                          "please make sure number start with 6787",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Muli-SemiBold',
                                                              color: Color(
                                                                  0xffFF0000)),
                                                        )
                                                      : Container(),
                                                  TextFormField(
                                                    controller:
                                                        spurFamilyNumber,
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

                                                      if (spurFamilyNumber.text
                                                          .startsWith(
                                                              "6787", 0)) {
                                                        membershipApi(
                                                            spurFamilyNumber
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
                                                            "please make sure number start with 6787");
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
