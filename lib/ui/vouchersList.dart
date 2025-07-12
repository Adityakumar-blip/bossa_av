import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/offer_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/voucherController.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/main_app_bar.dart';

class VoucherList extends StatefulWidget {
  String? points;
  String? uuid;
  var navId;

  VoucherList({Key? key, data}) : super(key: key) {
    points = data['points'];
    uuid = data['uuid'];
    navId = data["navId"] ?? NavConst.rewardnav;
  }

  @override
  _VoucherListState createState() => _VoucherListState();
}

class _VoucherListState extends State<VoucherList> {
  var streamBuilder;
  late List<OffersList> allData;
  TextEditingController membershipCode = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoucherController>(
      init: VoucherController(),
      builder: ((cont) => SafeArea(
            child: Scaffold(
              appBar: MainAppBar(
                  "BOSSA REWARDS", false, () => Get.back(id: widget.navId)),
              body: SizedBox(
                height: SizeConfig.screenHeight * 0.85,
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.95,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "You Have",
                                  style: TextStyle(
                                      fontFamily: 'Muli-SemiBold',
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.2,
                                      color: const Color(0xffEDCC40)),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 1,
                                ),
                                Container(
                                  height: 3,
                                  width: SizeConfig.blockSizeHorizontal * 55,
                                  color: const Color(0xffEDCC40),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text("${widget.points}",
                                            style: TextStyle(
                                              fontFamily: 'Muli-Bold',
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      5,
                                            )),
                                        SizedBox(
                                          width:
                                              SizeConfig.blockSizeVertical * 1,
                                        ),
                                        Text(
                                          "BOSSA REWARDS POINTS",
                                          style: TextStyle(
                                              fontFamily: 'Muli-SemiBold',
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 300.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                          child: Text(
                                        "Please Redeem In Store",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'Muli-Bold',
                                            fontWeight: FontWeight.bold),
                                      )),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "You Can Redeem",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Muli-Bold',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffEDCC40)),
                                        ),
                                      ),
                                      cont.isLoading.value
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(0xffEDCC40))),
                                            )
                                          : SizedBox(
                                              height: 200.h,
                                              // height: SizeConfig.blockSizeVertical*35,
                                              width:
                                                  SizeConfig.screenWidth * 0.90,
                                              child: cont.offers.value.offers
                                                          .length ==
                                                      0
                                                  ? Center(
                                                      child: Text(
                                                          'No Vouchers Available',style: TextStyle(fontSize:18),))
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemCount: cont.offers
                                                          .value.offers.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTileOffers(
                                                          allData: cont.offers
                                                              .value.offers,
                                                          index: index,
                                                          uuid: widget.uuid,
                                                        );
                                                      },
                                                    ),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 4),
                            child: TextFormField(
                              controller: membershipCode,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(' '),
                                LengthLimitingTextInputFormatter(6)
                              ],
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[a-zA-Z0-9]+\$')
                                        .hasMatch(value)) {
                                  return 'Enter a valid voucher code!';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  fontFamily: 'Muli-SemiBold',
                                  color: Color(0xff0E0B20)),
                              decoration: InputDecoration(
                                  hintText: 'Enter Code Here',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: Colors.white)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Muli-Light',
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.2,
                                      color: const Color(0xff0E0B20))),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 1,
                                bottom: SizeConfig.blockSizeVertical * 2),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 4),
                            child: CustomButton(
                              width: 200,
                              text: 'Next',
                              onTap: () async {
                                String voucherData = await Api.getVoucher(
                                    membershipCode.text.trim());
                                var voucher = jsonDecode(voucherData);
                                if (voucher['status'] == 'success') {
                                  // ignore: use_build_context_synchronously

                                  Get.snackbar("Code is submitted", "",
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.black,
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  Get.snackbar("Code is invalid!", "",
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.black,
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 1,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 4),
                            child: CustomButton(
                              width: 200,
                              text: 'Voucher History',
                              onTap: () {
                                Get.toNamed(Routes.REDEEMHISTORY,
                                    arguments: {"navId": widget.navId},
                                    id: widget.navId);
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
          )),
    );
  }
}

// ignore: must_be_immutable
class ListTileOffers extends StatefulWidget {
  late List<OffersList> allData;
  late int index;
  var uuid;

  ListTileOffers({required this.allData, required this.index, this.uuid});

  @override
  _ListTileOffersState createState() => _ListTileOffersState();
}

class _ListTileOffersState extends State<ListTileOffers> {
  late int index;

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.allData[index].id);
        print(index);
        // CommonMethods().offerDialog(context, widget.allData[index].id,
        //     widget.allData[index].name, widget.allData[index].voucherPoints, widget.uuid);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            // height: SizeConfig.blockSizeVertical*5,
            // margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  // color: Colors.blue,
                  width: SizeConfig.blockSizeHorizontal * 50,
                  child: Text(
                    widget.allData[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.4,
                        color: const Color(0xff0E0B20),
                        fontFamily: 'Muli-Bold'),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "R${widget.allData[index].voucherAmount} ",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.4,
                        color: const Color(0xffEDCC40),
                        fontFamily: 'Muli-Bold'),
                    // children: <InlineSpan>[
                    //   TextSpan(
                    //       text: 'Points',
                    //       style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.2,
                    //           color: Colors.black, fontFamily: 'Muli-Bold')
                    //   ),
                    // ]
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2.0,
          )
        ],
      ),
    );
  }
}
