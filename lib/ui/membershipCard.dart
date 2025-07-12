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

class MembershipCard extends StatefulWidget {
  String? firstName;
  String? lastName;
  var navId;
  MembershipCard({Key? key, data}) : super(key: key) {
    firstName = data["firstName"];
    lastName = data["lastName"];
    navId = data["navId"] ?? NavConst.profile;
  }
  @override
  _MembershipCardState createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  bool isLoading = false;
  TextEditingController membershipNumber = TextEditingController();
  bool verify = false;
  String errorMessage = "";
  Api api = Api();
  String? memberNumber;

  @override
  void initState() {
    isLoading = true;
    getMembershipNumber();
    super.initState();
  }

  getMembershipNumber() async {
    var res = await api.userPointInfo();
    Map valueMap = jsonDecode(res);
    print("Points Data ---> $valueMap");
    memberNumber = valueMap['membership_number'];
    setState(() {
      isLoading = false;
    });
  }

  membershipApi(String membershipNumber) async {
    var res = await Api.setMembership(membershipNumber);
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
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Membership Number", false, () => Get.back(id: widget.navId)),
        body: isLoading == true
            ? Center(child: CommonMethods().loader())
            : ListView(
                children: [
                  SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Container(
                                height: SizeConfig.screenHeight * 0.52,
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Text('Membership Number',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Muli-Bold',
                                                color: Color(0xffEDCC40))),
                                      ),
                                      memberNumber != null
                                          ? Text(
                                              memberNumber!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Muli-Bold',
                                                  color: Color(0xffEDCC40)),
                                            )
                                          : const Text(
                                              'Please enter a membership number',
                                              style: TextStyle(
                                                  fontFamily: 'Muli-Bold')),
                                      memberNumber != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SizedBox(
                                                    // height: height * 0.4,
                                                    width:
                                                        SizeConfig.screenWidth,
                                                    child: Image.asset(
                                                        'assets/images/LoyaltyCard.png'),
                                                  ),
                                                  Text(memberNumber!,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Muli-Bold')),
                                                  Positioned(
                                                    bottom: 30,
                                                    left: 32,
                                                    child: Text(
                                                        '${widget.firstName} ${widget.lastName}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Muli-Bold')),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.0,
                                                      bottom: 15.0,
                                                      left: 20,
                                                      right: 20),
                                                  child: Text(
                                                      'Please enter any number that is at least 6 digits to use as your membership number',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Muli-Bold')),
                                                ),
                                                errorMessage == ""
                                                    ? verify == true
                                                        ? membershipNumber.text
                                                                    .length <
                                                                6
                                                            ? const Text(
                                                                'Please Enter at least 6 digits.',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
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
                                                    TextFormField(
                                                      controller:
                                                          membershipNumber,
                                                      textAlign:
                                                          TextAlign.center,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .deny(' ')
                                                      ],
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Muli-SemiBold',
                                                          color: Color(
                                                              0xff0E0B20)),
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Enter Number Here',
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          16),
                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          30),
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  fontFamily:
                                                                      'Muli-Light',
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .blockSizeVertical *
                                                                          2.2,
                                                                  color: const Color(
                                                                      0xff0E0B20))),
                                                    ),
                                                    const SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    CustomButton(
                                                      text: 'Submit',
                                                      onTap: () {
                                                        setState(() {
                                                          errorMessage = "";
                                                          verify = true;
                                                          isLoading = true;
                                                        });
                                                        membershipApi(
                                                            membershipNumber
                                                                .text);
                                                        // Navigator.pop(context);
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
                ],
              ),
      ),
    );
  }
}
