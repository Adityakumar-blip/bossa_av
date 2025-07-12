import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import '../../util/app_bar.dart';
import 'add_address_screen.dart';
import 'address_controller.dart';
import 'package:Bossa/util/global_text.dart';

import 'address_screen.dart';

class AddressList extends StatefulWidget {
  AddressList({Key? key}) : super(key: key);

  @override
  State<AddressList> createState() => _AddAddressScreenState();
}

bool loading = true;
List? result;

class _AddAddressScreenState extends State<AddressList> {
  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
  }

  fetch() async {
    List res = await Api().getUserAddressList();
    setState(() {
      result = res;
      // print(result![0]["address"]);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return WillPopScope(
      onWillPop: () {
        //   Navigator.pushReplacement(
        // context,
        // PageRouteBuilder(
        //   pageBuilder: (context, animation1, animation2) => AddressScreen(),
        //   transitionDuration: Duration.zero,
        //   reverseTransitionDuration: Duration.zero,
        // ));
        return Future.value(true);
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: const Color(0xfff2f6f9),
              appBar: appBar("My Address", false, () => Get.back()),
              body: SafeArea(
                bottom: false,
                child: SizedBox(
                  child: loading
                      ? Center(child: CommonMethods().loader())
                      : Column(
                          children: [
                            Expanded(
                              child: result!.isEmpty
                                  ? Container()
                                  : SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Column(children: [
                                          for (int i = 0;
                                              i < result!.length;
                                              i++)
                                            Column(
                                              children: [
                                                Container(
                                                    height: 1.h,
                                                    width: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xffEDCC40),
                                                      /*  gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xffed2024),
                                                                Color(
                                                                    0xfff47729),
                                                                Color(
                                                                    0xfffbb042)
                                                              ],
                                                              stops: [
                                                                0,
                                                                0.4827589988708496,
                                                                1
                                                              ],
                                                              begin: Alignment(
                                                                  -1.00, 0.00),
                                                              end: Alignment(
                                                                  1.00, -0.00),
                                                              // angle: 90,
                                                              // scale: undefined,
                                                            ) */
                                                    )),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GlobalText(
                                                            result![i][
                                                                    "nickname"] ??
                                                                "",
                                                            color: Colors.black,
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                          SizedBox(
                                                            height: 1.5.h,
                                                          ),
                                                          GlobalText(
                                                            result![i]
                                                                    ["apart"] +
                                                                "," +
                                                                result![i]
                                                                    ["address"],
                                                            color: Color(
                                                                0xff888E94),
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                          GlobalText(
                                                            result![i]["road"],
                                                            color: Color(
                                                                0xff888E94),
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                          GlobalText(
                                                            result![i]["area"] +
                                                                "," +
                                                                result![i][
                                                                    "postal_code"],
                                                            color: Color(
                                                                0xff888E94),
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            AddAddressScreen(
                                                                result: result,
                                                                index: i,
                                                                c: false,
                                                                dn: ""));
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15),
                                                          width: 103.w,
                                                          height: 40.h,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                               color: Color(0xffEDCC40),
                                                                /*   gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xffffb401),
                                                                      Color(
                                                                          0xfff32a34)
                                                                    ],
                                                                    stops: [
                                                                      0,
                                                                      1
                                                                    ],
                                                                    begin: Alignment(
                                                                        -1.00,
                                                                        0.00),
                                                                    end: Alignment(
                                                                        1.00,
                                                                        -0.00),
                                                                    // angle: 90,
                                                                    // scale: undefined,
                                                                  ) */),
                                                          child: Center(
                                                              child: GlobalText(
                                                            "Edit",
                                                            fontSize: 15.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ))),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Container(
                                                    height: 1.h,
                                                    width: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xffEDCC40),
                                                                
                                                          /*   gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xffed2024),
                                                                Color(
                                                                    0xfff47729),
                                                                Color(
                                                                    0xfffbb042)
                                                              ],
                                                              stops: [
                                                                0,
                                                                0.4827589988708496,
                                                                1
                                                              ],
                                                              begin: Alignment(
                                                                  -1.00, 0.00),
                                                              end: Alignment(
                                                                  1.00, -0.00),
                                                              // angle: 90,
                                                              // scale: undefined,
                                                            ) */)),
                                              ],
                                            ),
                                          //const Spacer(flex: 1),
                                        ]),
                                      ),
                                    ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Get.to(() => AddAddressScreen(
                                    result: [], index: 0, c: false, dn: ""));
                                //    Get.to(() => AddAddressScreen(result: result,index: i,));
                                //                     cont.addr == null?Get.to(() => AddAddressScreen()): Navigator.push(
                                // context,
                                // PageRouteBuilder(
                                //   pageBuilder: (context, animation1, animation2) => AddressList(),
                                //   transitionDuration: Duration.zero,
                                //   reverseTransitionDuration: Duration.zero,
                                // ));
                              },
                              child: Container(
                                  height: 59.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 37.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                       color: Color(0xffEDCC40),
                                     /*  gradient: const LinearGradient(
                                        colors: [
                                          Color(0xfffe7500),
                                          Color(0xffe41b00)
                                        ],
                                        stops: [0, 1],
                                        begin: Alignment(-1.00, 0.00),
                                        end: Alignment(1.00, -0.00),
                                        // angle: 90,
                                        // scale: undefined,
                                      ) */),
                                  alignment: Alignment.center,
                                  child: GlobalText("Add Address",
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.sp)),
                            )
                          ],
                        ),
                ),
              ))),
    );
  }
}
