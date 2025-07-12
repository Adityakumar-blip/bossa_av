import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/offer_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:Bossa/util/top_part.dart';

String membershipNumber = '';

class RewardsDashboard extends StatefulWidget {
  @override
  _RewardsDashboardState createState() => _RewardsDashboardState();
}

class _RewardsDashboardState extends State<RewardsDashboard> {
  TextEditingController enterCode = TextEditingController();

  Api api = Api();
  var streamBuilder;
  late List<OffersList> allData;
  bool loading = false;
  late String firstName, lastName;

  late String uuid;
  String? tierName;
  Color? tierBackgroundColor;

  Future<void> getUserData() async {
    try {
      var userData = await api.fetchUserDetails();
      setState(() {
        firstName = userData.data!.name;
        lastName = userData.data!.lastName ?? '';
        uuid = userData.data!.uuid;
      });

      var tierData = await api.getTierInfo(uuid);
      if (tierData != null && tierData.isNotEmpty) {
        try {
          Map tierValueMap = jsonDecode(tierData);
          if (tierValueMap['status'] == "success" &&
              tierValueMap['data'] != null) {
            setState(() {
              tierName = "${tierValueMap['data']['tier_name']} Member";
              String hexColor =
                  tierValueMap['data']['card_color']?.replaceAll('#', '') ??
                      '808080';
              tierBackgroundColor = Color(int.parse('0xFF$hexColor'));
            });
          }
        } catch (e) {
          print('Error parsing tier data: $e');
        }
      }
    } catch (e) {
      print('Error fetching user or tier data: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getUserData();
  }

  Future<bool> _onWillPop() async {
    Get.back(id: NavConst.rewardnav);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var one = Get.arguments ?? "";
    var bar = const MainAppBar("BOSSA REWARDS", false, null);
    if (one != "") {
      bar = MainAppBar("BOSSA REWARDS", false, () => Get.back());
    }
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    return SafeArea(
      child: Scaffold(
        appBar: bar,
        body: ListView(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            loading == true
                ? Center(child: CommonMethods().loader())
                : SafeArea(
                    bottom: false,
                    child: FutureBuilder(
                      future: api.userPointInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map valueMap = jsonDecode(snapshot.data as String);

                          membershipNumber = valueMap['membership_number'];
                          print(
                              'get membership number===>>>>>$membershipNumber');
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      width: SizeConfig.screenWidth,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.blockSizeHorizontal *
                                                  2),
                                      child: valueMap['membership_number'] !=
                                              null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "You Have",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Muli-SemiBold',
                                                      fontSize: SizeConfig
                                                              .blockSizeVertical *
                                                          2.2,
                                                      color: const Color(
                                                          0xffEDCC40)),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      1,
                                                ),
                                                Container(
                                                  height: 3,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      55,
                                                  color:
                                                      const Color(0xffEDCC40),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      children: [
                                                        Text(
                                                            valueMap[
                                                                'user_point'],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Muli-Bold',
                                                              fontSize: SizeConfig
                                                                      .blockSizeVertical *
                                                                  5,
                                                            )),
                                                        SizedBox(
                                                          width: SizeConfig
                                                                  .blockSizeVertical *
                                                              1,
                                                        ),
                                                        Text(
                                                          "BOSSA REWARDS POINTS",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Muli-SemiBold',
                                                              fontSize: SizeConfig
                                                                      .blockSizeVertical *
                                                                  2.2),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      children: [
                                                        Text(
                                                          "Membership Number -  ${valueMap['membership_number']}",
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Muli-SemiBold',
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xffEDCC40)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      2.2,
                                                ),
                                                // Replace the Stack widget section (around line 185-230) with this fixed version:
// Replace the Stack widget section (around line 185-230) with this fixed version:

                                                // Replace the Stack widget section (around line 185-230) with this fixed version:

                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: width,
                                                      child: Image.asset(
                                                          'assets/images/LoyaltyCard.png'),
                                                    ),
                                                    Text(
                                                        "${valueMap['membership_number']}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Muli-Bold')),
                                                    // Name section positioned on the left
                                                    Positioned(
                                                      bottom:
                                                          ('$firstName $lastName')
                                                                      .length >
                                                                  20
                                                              ? 15
                                                              : 30,
                                                      left: 25,
                                                      child:
                                                          ('$firstName $lastName')
                                                                      .length >
                                                                  20
                                                              ? Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        firstName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Muli-Bold'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      Text(
                                                                        lastName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Muli-Bold'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Text(
                                                                  '$firstName $lastName',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Muli-Bold'),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                    ),
                                                    // Tier name section positioned on the right
                                                    Positioned(
                                                      bottom: 30,
                                                      right: 32,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: tierName !=
                                                                  null
                                                              ? tierBackgroundColor
                                                              : null,
                                                          border: tierName ==
                                                                  null
                                                              ? Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1)
                                                              : null,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Text(
                                                          tierName ??
                                                              'Standard Member',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Muli-Bold',
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: height * 0.5,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'No Membership Number',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xffEDCC40)),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 3.0,
                                                        left: width / 6,
                                                        right: width / 6),
                                                    child: const Divider(
                                                      thickness: 3,
                                                      height: 0,
                                                      color: Color(0xffEDCC40),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20.0,
                                                        bottom: 20.0),
                                                    child: Text(
                                                      'Please create a Membership Number',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Color(
                                                              0xff222222)),
                                                    ),
                                                  ),
                                                  CustomButton(
                                                    width: 200.w,
                                                    text:
                                                        'Click Here to Create',
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes.PROFILE,
                                                          arguments: {
                                                            "navId": NavConst
                                                                .rewardnav
                                                          },
                                                          id: NavConst
                                                              .rewardnav);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )),
                                  valueMap['membership_number'] != null
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              top:
                                                  SizeConfig.blockSizeVertical *
                                                      6),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4),
                                          child: CustomButton(
                                            width: 200.w,
                                            text: 'Available Vouchers',
                                            onTap: () {
                                              Get.toNamed(Routes.VOUCHERLIST,
                                                  arguments: {
                                                    "uuid": uuid,
                                                    "points":
                                                        valueMap['user_point'],
                                                    "navId": NavConst.rewardnav
                                                  },
                                                  id: NavConst.rewardnav);
                                            },
                                          ),
                                        )
                                      : Container(),
                                  valueMap['membership_number'] != null
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              top:
                                                  SizeConfig.blockSizeVertical *
                                                      6),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4),
                                          child: CustomButton(
                                            width: 200.w,
                                            text: 'Transaction History',
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes.TRANSACTIONHISTORY,
                                                  arguments: {
                                                    "uuid": uuid,
                                                    "points":
                                                        valueMap['user_point'],
                                                    "navId": NavConst.rewardnav
                                                  },
                                                  id: NavConst.rewardnav);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xffEDCC40)),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffEDCC40)),
                          ),
                        );
                      },
                    )),
          ],
        ),
      ),
    );
  }

  enterPoints() async {
    var res = await Api.getPoints(enterCode.text);
    Map valueMap = jsonDecode(res);
    print("response of points :  $valueMap");
    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EarnPoints()));
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'], context);
    }
  }
}

class EarnPoints extends StatefulWidget {
  var navId = NavConst.rewardnav;
  EarnPoints({Key? key, data}) : super(key: key) {
    navId = data['navId'];
  }

  @override
  _EarnPointsState createState() => _EarnPointsState();
}

class _EarnPointsState extends State<EarnPoints> {
  Future<bool> _onWillPop() {
    Get.offAndToNamed(Routes.REWARDDASH);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopPart(title: "Redeem"),
              SizedBox(
                height: height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text(
                        "Thank you. You have successfully earned loyalty points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Muli-Bold',
                            fontWeight: FontWeight.bold,
                            color: Color(0xffEDCC40)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3,
                          bottom: SizeConfig.blockSizeVertical * 1),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 4),
                      child: CustomButton(
                        text: 'Check Balance',
                        onTap: () {
                          Get.offAndToNamed(Routes.REWARDDASH);
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
  }
}
