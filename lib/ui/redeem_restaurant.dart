import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/store_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/ui/reward_dashboard.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/top_part.dart';

// ignore: must_be_immutable
class RedeemRestaurant extends StatefulWidget {
  var uuid;
  String? voucherName;
  String? voucherPrice;
  String? rewardId;
  RedeemRestaurant(
      {Key? key, this.uuid, this.voucherName, this.voucherPrice, this.rewardId})
      : super(key: key);
  @override
  _RedeemRestaurantState createState() => _RedeemRestaurantState();
}

class _RedeemRestaurantState extends State<RedeemRestaurant> {
  var streamBuilder;
  var searchBuilder;
  late List<StoresList> allVData;
  late String tempName;
  late String tempID;
  late int selectedIndex;
  double height = SizeConfig.screenHeight;
  double width = SizeConfig.screenWidth;
  var uuid;
  TextEditingController searchEditingController = TextEditingController();
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    streamBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allVData = snapshot.data!.stores;

          return SizedBox(
            height: SizeConfig.blockSizeVertical *
                (SizeConfig.isDeviceLarge ? 38 : 35),
            width: double.infinity,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: allVData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tempName = allVData[index].name;
                      tempID = allVData[index].id;
                      selectedIndex = index;
                      print("Res Name ---> $tempName");
                      print("Index ---> $selectedIndex");
                      loadData();
                    });
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 9,
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical * 2),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${allVData[index].name} "
                              "(${allVData[index].location})",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.2,
                                  color: const Color(0xff0E0B20),
                                  fontFamily: 'Muli'),
                            ),
                          ),
                        ),
                        index == selectedIndex
                            ? const SizedBox(
                                width: 50,
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xffEDCC40),
                                  size: 30,
                                ))
                            : Container(width: 50),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (snapshot.hasError) {
          return Container();
        }
        return const Center(
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
        );
      },
    );
  }

  searchData(String value) {
    searchBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        return SizedBox(
          height: SizeConfig.blockSizeVertical *
              (SizeConfig.isDeviceLarge ? 38 : 35),
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allVData.length,
            itemBuilder: (context, index) {
              if (allVData[index]
                  .name
                  .toLowerCase()
                  .contains(value.toLowerCase())) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tempName = allVData[index].name;
                      tempID = allVData[index].id;
                      selectedIndex = index;
                      print("Res Name ---> $tempName");
                      print("Index ---> $selectedIndex");
                      searchData(value);
                    });
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 9,
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical * 2),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${allVData[index].name} "
                              "(${allVData[index].location})",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.2,
                                  color: const Color(0xff0E0B20),
                                  fontFamily: 'Muli'),
                            ),
                          ),
                        ),
                        index == selectedIndex
                            ? const SizedBox(
                                width: 50,
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xffEDCC40),
                                  size: 30,
                                ))
                            : Container(width: 50),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
        if (snapshot.hasError) {
          return Container();
        }
        return const Center(
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
        );
      },
    );
  }

  Widget searchBar() {
    return Container(
      // height: height * 0.12,
      width: 150.h,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextField(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        controller: searchEditingController,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        cursorWidth: 2.5,
        onChanged: (value) {
          setState(() {
            searchData(value);
          });
        },
        onEditingComplete: () {
          setState(() {
            FocusScope.of(context).unfocus();
          });
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: 'search',
          hintStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.only(left: 40),
        ),
      ),
    );
  }

  redeemVoucherApi(String rewardId, String restaurantId) async {
    var res = await Api.redeemVoucher(rewardId, restaurantId);
    print("Redeem Voucher Response ---> $res");
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      Get.to(() => RedeemSuccess(
          itemName: widget.voucherName, price: widget.voucherPrice));
    } else {
      print("ValueMap ---> $valueMap");
      CommonMethods().showFlushBar("${valueMap['message']}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = SizeConfig.screenHeight;
    width = SizeConfig.screenWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: SizeConfig.blockSizeVertical * 25,
                  width: SizeConfig.blockSizeHorizontal * 70,
                  child: Image.asset('assets/images/pmck_logo.png'),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical,
              ),
              Text(
                "Select Store",
                style: TextStyle(
                    color: const Color(0xff0E0B20),
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockSizeVertical * 5,
                    fontFamily: 'Muli-Bold'),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical,
              ),
              Text(
                "Please select the store you would like to use this voucher at",
                style: TextStyle(
                    color: const Color(0xff0E0B20),
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockSizeVertical * 2,
                    fontFamily: 'Muli-Bold'),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              searchBar(),
              searchEditingController.text.isNotEmpty
                  ? searchBuilder
                  : streamBuilder,
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1.5,
              ),
              Center(
                child: CustomButton(
                  text: "CONFIRM",
                  onTap: () {
                    if (tempName != null) {
                      redeemVoucherApi(widget.rewardId!, tempID);
                    } else {
                      CommonMethods()
                          .showFlushBar("Please Select Restaurant", context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RewardsDashboard()));
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
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TopPart(title: "Redeem"),
              ),
              SizedBox(
                height: height * 0.4,
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
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                      child: Text(
                        'Please give your membership number to the store you have selected next time you visit!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Muli-Bold',
                            color: Colors.black),
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
                          Get.back();
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
