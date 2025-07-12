import 'package:Bossa/onlines/Payment/payment_screen.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../network/api.dart';
import '../Address/add_address_screen.dart';
import '../Address/address_controller.dart';
import '../Restuarent_Menu_Page/reasurant_menu_controller.dart';
import 'checkout_controller.dart';

class CheckOutScreen extends GetView<CheckOutController> {
  @override
  final controller = Get.put(CheckOutController(), tag: 'total');
  final rescontrol = Get.put(
    ReasurantMenuController(),
  );

  TextEditingController promo = TextEditingController();

  TextEditingController tip = TextEditingController();
  RxList res2 = [].obs;
  RxMap drop = {}.obs;
  RxString address = "0".obs;
  final String dn;
  CheckOutScreen({super.key, required this.dn});
  fetch() async {
    List res = await Api().getUserAddressList();
    res2 = res.obs;
    Future.delayed(const Duration(milliseconds: 1000))
        .then((value) => dropzone());
  }

  dropzone() async {
    print("id");
    print(controller.cart.value.restaurantId);

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    String day = now.weekday.toString();
    print(day);

    String time = now.hour.toString() + now.minute.toString();
    try {
      Map<String, dynamic> body = {
        "action": "AVAILABLE_DROPZONE",
        "date": formattedDate,
        "time": time,
        "restaurant_id": controller.cart.value.restaurantId
      };
      drop.value = await Api().dropzones(body);
      print("drop");
      print(dn);
      controller.cart.value.deliverynotes.value = dn;
      print(drop);
      if (drop["status"] == "success") {
        print("inside");
        if (drop["data"].length >= 1) {
          print(drop["data"]);
          print("hi");
          controller.dropvisible.value = true;
        }
      }
// String day2="";
//    if(day=="1"){
//     day2="Monday";
//    }
//    if(day=="2"){
//     day2="Tuesday";
//    }
//    if(day=="3"){
//     day2="Wednesday";
//    }
//    if(day=="4"){
//     day2="Thursday";
//    }
//    if(day=="5"){
//     day2="Friday";
//    }
//    if(day=="6"){
//     day2="Saturday";
//    }
//    if(day=="7"){
//     day2="Sunday";
//    }
// print(day2);
// print(res["data"][0]["cutoffTimes"][day2]["openingTime"]);

// String ot=res["data"][0]["cutoffTimes"][day2]["openingTime"].toString().replaceAll(":","");
// String ct=res["data"][0]["cutoffTimes"][day2]["closingTime"].toString().replaceAll(":","");
// if(int.parse(time)>=int.parse(ot) && int.parse(time)<=int.parse(ct)){
//   controller.dropvisible.value=true;
// }
      print(controller.dropvisible);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    fetch();

    return Scaffold(
      backgroundColor: const Color(0xfff2f6f9),
      body: GetBuilder(
          init: controller,
          builder: ((conx) => SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBar("Checkout", false, () => Get.back()),
                        Container(
                            margin: EdgeInsets.only(top: 28.h, bottom: 10.h),
                            decoration:
                                const BoxDecoration(color: Color(0xffffffff)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 19.h, left: 24.w),
                                      child: GlobalText("Items Total",
                                          color: const Color(0xff111c26),
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 17.sp)),
                                  Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: controller
                                                  .cart.value.items?.length ??
                                              0,
                                          itemBuilder: (context, index) =>
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 19.h,
                                                    left: 24.w,
                                                    right: 25.w),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: GlobalText(
                                                          controller
                                                              .cart
                                                              .value
                                                              .items![index]
                                                              .name,
                                                        ),
                                                      ),
                                                      GlobalText(
                                                        ("R${double.parse((controller.cart.value.items![index].price * controller.cart.value.items![index].qantity).toString()).toStringAsFixed(2)}"),
                                                      )
                                                    ]),
                                              ))),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 68.h, left: 25.w, right: 25.w),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GlobalText("Promo Code",
                                              color: const Color(0xff141f29),
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 17.sp),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff9b9b9b)),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color: Color(0xff9b9b9b),
                                                    //     blurRadius: 8,
                                                    //     spreadRadius: 0,
                                                    //     offset: const Offset(0, 4),
                                                    //   ),
                                                    // ],
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(4),
                                                  ),
                                                  child: Center(
                                                    child: TextFormField(
                                                      obscureText: false,
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xff9b9b9b),
                                                          fontFamily:
                                                              'Work Sans',
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      enableSuggestions: false,
                                                      autocorrect: false,
                                                      controller: promo,
                                                      onChanged: (val) {
                                                        // setState(() {
                                                        //   emailtxt = val;
                                                        // });
                                                        // bool email = checkempty(val);
                                                        // if (email == false) {
                                                        //   setState(() {
                                                        //     emailerror = "Please enter your email/phone";
                                                        //   });
                                                        // } else {
                                                        //   setState(() {
                                                        //     emailerror = "";
                                                        //   });
                                                        // }
                                                      },
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        // suffixIcon: IconButton(
                                                        //   onPressed: () {},
                                                        //   icon: Container(
                                                        //     height: 17.h,
                                                        //     width: 17.w,
                                                        //     child: SvgPicture.asset(
                                                        //       widget.suffixImg,
                                                        //       height: 17.h,
                                                        //       width: 17.w,
                                                        //     ),
                                                        //   ),
                                                        // ),

                                                        errorMaxLines: 3,
                                                        // errorText: validtion ? errorMSg : "",
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 11.w),
                                                        filled: false,
                                                        hintText: "",

                                                        hintStyle: TextStyle(
                                                            color: const Color(
                                                                0xff9b9b9b),
                                                            fontFamily:
                                                                'Work Sans',
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      cursorColor: const Color(
                                                          0xff9b9b9b),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  await controller.getPromo(
                                                      promo.text.toString());
                                                },
                                                child: Container(
                                                    width: 80.w,
                                                    height: 50.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      color: const Color(
                                                          0xffEDCC40),
                                                      /*  gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            Color(0xfffe7500),
                                                            Color(0xffe41b00)
                                                          ],
                                                          stops: [0, 1],
                                                          begin: Alignment(
                                                              -1.00, 0.00),
                                                          end: Alignment(
                                                              1.00, -0.00),
                                                          // angle: 90,
                                                          // scale: undefined,
                                                        ) */
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: GlobalText("Apply",
                                                        color: const Color(
                                                            0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 18.sp)),
                                              )
                                            ],
                                          ),

                                          //   SizedBox(
                                          //     width: 120.w,
                                          //     child: TextField(
                                          //       onSubmitted: (value) async {
                                          //         await controller
                                          //             .getPromo(value);
                                          //       },
                                          //     ),
                                          //   )
                                        ]),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 20.h, left: 25.w, right: 25.w),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GlobalText("Add Tip",
                                                color: const Color(0xff141f29),
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 17.sp),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 50.h,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff9b9b9b)),
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //     color: Color(0xff9b9b9b),
                                                      //     blurRadius: 8,
                                                      //     spreadRadius: 0,
                                                      //     offset: const Offset(0, 4),
                                                      //   ),
                                                      // ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .circular(4),
                                                    ),
                                                    child: Center(
                                                      child: TextFormField(
                                                        obscureText: false,
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xff9b9b9b),
                                                            fontFamily:
                                                                'Work Sans',
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        enableSuggestions:
                                                            false,
                                                        autocorrect: false,
                                                        controller: tip,
                                                        onChanged: (val) async {
                                                          await controller
                                                              .tipUpdate(val
                                                                  .toString());
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          // suffixIcon: IconButton(
                                                          //   onPressed: () {},
                                                          //   icon: Container(
                                                          //     height: 17.h,
                                                          //     width: 17.w,
                                                          //     child: SvgPicture.asset(
                                                          //       widget.suffixImg,
                                                          //       height: 17.h,
                                                          //       width: 17.w,
                                                          //     ),
                                                          //   ),
                                                          // ),

                                                          errorMaxLines: 3,
                                                          // errorText: validtion ? errorMSg : "",
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 11.w),
                                                          filled: false,
                                                          hintText: "",

                                                          hintStyle: TextStyle(
                                                              color: const Color(
                                                                  0xff9b9b9b),
                                                              fontFamily:
                                                                  'Work Sans',
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        cursorColor:
                                                            const Color(
                                                                0xff9b9b9b),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ])),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 15.h, left: 25.w, right: 25.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GlobalText("Sub Total",
                                              color: const Color(0xff141f29),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                          GlobalText(
                                              "R${controller.cart.value.subTotal.toStringAsFixed(2)}",
                                              color: const Color(0xff111c26),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 15.h, left: 25.w, right: 25.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GlobalText("Discount",
                                              color: const Color(0xff141f29),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                          GlobalText(
                                              "R${controller.discount.toStringAsFixed(2)}",
                                              color: const Color(0xff111c26),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 15.h, left: 25.w, right: 25.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GlobalText("Tip",
                                              color: const Color(0xff141f29),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                          GlobalText(
                                              "R${controller.tip.toStringAsFixed(2)}",
                                              color: const Color(0xff111c26),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 23.h, left: 25.w, right: 25.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GlobalText("Delivery Fee",
                                              color: const Color(0xff141f29),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                          GlobalText(
                                              controller.select.value ==
                                                      "Collect"
                                                  ? "R0.00"
                                                  : "R${controller.cart.value.deliveryFee}",
                                              color: const Color(0xffEDCC40),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp),
                                        ],
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 22.h,
                                          bottom: 21.h,
                                          left: 25.w,
                                          right: 25.w),
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xffe0e0e0),
                                              width: 1.w))),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 25.w,
                                          right: 25.w,
                                          bottom: 23.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GlobalText("Total",
                                              color: const Color(0xff111c26),
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20.sp),
                                          GlobalText(
                                              "R${controller.total.toStringAsFixed(2)}",
                                              color: const Color(0xffEDCC40),
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20.sp),
                                        ],
                                      )),
                                ])),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffffffff)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 24.w, top: 15.h, right: 27.w),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 30.h),
                                              GlobalText(
                                                  "Select Delivery Option",
                                                  color:
                                                      const Color(0xff111c26),
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 19.sp),
                                              SizedBox(height: 10.h),
                                              Row(children: [
                                                SizedBox(
                                                  width: 20.w,
                                                  child: Radio(
                                                      autofocus: true,
                                                      activeColor: const Color(
                                                          0xffEDCC40),
                                                      value: "Delivered",
                                                      groupValue: controller
                                                          .select.value,
                                                      onChanged: (value) =>
                                                          controller
                                                              .onClickRadioButton(
                                                                  value)),
                                                ),
                                                SizedBox(width: 10.w),
                                                GlobalText("Delivery",
                                                    color:
                                                        const Color(0xff111c26),
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.sp)
                                              ]),
                                              SizedBox(width: 30.h),
                                              Row(children: [
                                                SizedBox(
                                                  width: 20.w,
                                                  child: Radio(
                                                      activeColor: const Color(
                                                          0xffEDCC40),
                                                      value: "Collect",
                                                      groupValue: controller
                                                          .select.value,
                                                      onChanged: (value) {
                                                        controller
                                                            .onClickRadioButton(
                                                                value);
                                                        controller.user.value
                                                                .address =
                                                            "Collect In Store";
                                                      }),
                                                ),
                                                SizedBox(width: 10.w),
                                                GlobalText("Collect  In Store",
                                                    color:
                                                        const Color(0xff111c26),
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.sp)
                                              ]),
                                              SizedBox(width: 30.h),
                                              Obx(() => controller
                                                          .dropvisible.value ==
                                                      true
                                                  ? Row(children: [
                                                      SizedBox(
                                                          width: 20.w,
                                                          child: Radio(
                                                              activeColor:
                                                                  const Color(
                                                                      0xffe41b00),
                                                              value: "Drop",
                                                              groupValue:
                                                                  controller
                                                                      .select
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                    .onClickRadioButton(
                                                                        value);
                                                                controller.addr
                                                                    .value = "";
                                                                controller
                                                                    .user
                                                                    .value
                                                                    .address = "";
                                                              })),
                                                      SizedBox(width: 10.w),
                                                      GlobalText("Drop Zone",
                                                          color: const Color(
                                                              0xff111c26),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 17.sp)
                                                    ])
                                                  : Container())
                                            ])),
                                  ])),
                        ),
                        controller.select.value == "Delivered"
                            ? Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffffffff)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 24.w,
                                              top: 15.h,
                                              right: 27.w),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GlobalText("Delivery Address",
                                                    color:
                                                        const Color(0xff111c26),
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.sp),
                                                GestureDetector(
                                                  onTap: () {
                                                    final controller2 = Get.put(
                                                        AddressController());
                                                    controller2.loadAddress
                                                        .value = false;
                                                    controller.addrtype.value =
                                                        "";
                                                    String tmp =
                                                        controller.addr.value;
                                                    controller.addr.value = "";
                                                    Get.to(() =>
                                                        AddAddressScreen(
                                                            result: const [],
                                                            index: 0,
                                                            c: true,
                                                            dn: dn));
                                                  },
                                                  child: GlobalText(
                                                      "Add Address",
                                                      color: const Color(
                                                          0xffEDCC40),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13.sp),
                                                )
                                              ])),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 23.w,
                                              top: 22.h,
                                              right: 23.w,
                                              bottom: 22.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                    onTap: () async {
                                                      controller.user.value
                                                          .address = "";
                                                      controller.addrtype
                                                          .value = "Current";
                                                      Position position =
                                                          await Geolocator
                                                              .getCurrentPosition();
                                                      debugPrint(
                                                          'location: ${position.latitude}');
                                                      List<Placemark>
                                                          addresses =
                                                          await placemarkFromCoordinates(
                                                              position.latitude,
                                                              position
                                                                  .longitude);

                                                      var first =
                                                          addresses.first;
                                                      controller.user.value
                                                              .address =
                                                          "${first.name},${first.street}\n${first.subAdministrativeArea},${first.administrativeArea}\n${first.locality},${first.subLocality},${first.postalCode}";
                                                      print(controller
                                                          .user.value.address);
                                                      var dist = Geolocator.distanceBetween(
                                                          double.parse(
                                                              rescontrol
                                                                  .rest
                                                                  .value
                                                                  .latitude),
                                                          double.parse(
                                                              rescontrol
                                                                  .rest
                                                                  .value
                                                                  .longitude),
                                                          double.parse(position
                                                              .latitude
                                                              .toString()),
                                                          double.parse(position
                                                              .longitude
                                                              .toString()));
                                                      int a = dist.toInt();
                                                      print(dist);
                                                      print(a);
                                                      controller.price(a);
                                                    },
                                                    child: Obx(
                                                      () => Container(
                                                        height: 43.h,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: controller
                                                                            .addrtype
                                                                            .value ==
                                                                        "Current"
                                                                    ? const Color(
                                                                        0xfffe7500)
                                                                    : Colors
                                                                        .black),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Center(
                                                          child: GlobalText(
                                                              "Use Current Location",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13.sp),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller.addrtype.value =
                                                        "Saved";
                                                    //  print(res2[0]["latitude"]);
                                                    //      var dist=Geolocator.distanceBetween(double.parse(rescontrol.rest.value.latitude), double.parse(rescontrol.rest.value.longitude), double.parse(res2[0]["latitude"]), double.parse(res2[0]["longitude"]));
                                                    //   int a=dist.toInt();
                                                    //      controller.price(a);
                                                    //        print(dist);
                                                    // print(controller.addrtype.value);
                                                    //   controller.user.value.address=res2[0]["apart"]+","+res2[0]["address"]+"\n"+res2[0]["road"]+"\n"+res2[0]["area"]+","+res2[0]["postal_code"];
                                                  },
                                                  child: Obx(() => Container(
                                                        height: 43.h,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: controller
                                                                            .addrtype
                                                                            .value ==
                                                                        "Saved"
                                                                    ? const Color(
                                                                        0xfffe7500)
                                                                    : Colors
                                                                        .black),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Center(
                                                          child: GlobalText(
                                                              "Select Address",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13.sp),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ]))
                            : controller.select.value == "Drop"
                                ? Container(
                                    decoration: const BoxDecoration(
                                        color: Color(0xffffffff)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 24.w,
                                                  top: 15.h,
                                                  right: 27.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GlobalText(
                                                        "Delivery Address",
                                                        color: const Color(
                                                            0xff111c26),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 17.sp),
                                                    // GestureDetector(
                                                    //   onTap: () => Get.toNamed(
                                                    //       Routes.ONLINEADDADRESS),
                                                    //   child: GlobalText("Change",
                                                    //       color: const Color(
                                                    //           0xffe41b00),
                                                    //       fontWeight:
                                                    //           FontWeight.w700,
                                                    //       fontStyle:
                                                    //           FontStyle.normal,
                                                    //       fontSize: 13.sp),
                                                    // )
                                                  ])),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          for (int i = 0;
                                              i < drop["data"].length;
                                              i++)
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 24.w,
                                                    bottom: 20.h,
                                                    right: 27.w),
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                          width: 20.w,
                                                          child: Obx(
                                                            () => Radio(
                                                                activeColor:
                                                                    const Color(
                                                                        0xffe41b00),
                                                                value: i
                                                                    .toString(),
                                                                groupValue:
                                                                    controller
                                                                        .addr
                                                                        .value,
                                                                onChanged:
                                                                    (value) {
                                                                  controller
                                                                          .addr
                                                                          .value =
                                                                      value
                                                                          .toString();
                                                                  print(controller
                                                                      .user
                                                                      .value
                                                                      .address);

                                                                  var dist =
                                                                      Geolocator
                                                                          .distanceBetween(
                                                                    double.parse(
                                                                        rescontrol
                                                                            .rest
                                                                            .value
                                                                            .latitude),
                                                                    double.parse(
                                                                        rescontrol
                                                                            .rest
                                                                            .value
                                                                            .longitude),
                                                                    double.parse(
                                                                        rescontrol
                                                                            .rest
                                                                            .value
                                                                            .latitude),
                                                                    double.parse(
                                                                        rescontrol
                                                                            .rest
                                                                            .value
                                                                            .longitude),
                                                                  );
                                                                  int a = dist
                                                                      .toInt();
                                                                  controller.dropChanged(int.parse(
                                                                      drop["data"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "delivery_price"]));
                                                                  //  controller
                                                                  //     .price(a);

                                                                  print(dist);
                                                                  controller
                                                                          .user
                                                                          .value
                                                                          .dropzone_id =
                                                                      drop["data"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "id"];
                                                                  controller
                                                                      .user
                                                                      .value
                                                                      .address = drop[
                                                                          "data"][i]
                                                                      [
                                                                      "address"];
                                                                  print(controller
                                                                      .user
                                                                      .value
                                                                      .address);
                                                                }),
                                                          )),
                                                      SizedBox(width: 10.w),
                                                      Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GlobalText(
                                                                drop["data"][i]
                                                                    ["address"],
                                                                color: const Color(
                                                                    0xff888E94),
                                                                fontSize: 17.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            ]),
                                                      ),

                                                      // Container(
                                                      //   margin: EdgeInsets.only(
                                                      //       left: 23.w, top: 22.h),
                                                      //   child: GlobalText(
                                                      //       controller.user.value.name!,
                                                      //       color: const Color(0xff111c26),
                                                      //       fontWeight: FontWeight.w700,
                                                      //       fontStyle: FontStyle.normal,
                                                      //       fontSize: 13.sp),
                                                      // ),
                                                      // Container(
                                                      //   margin: EdgeInsets.only(
                                                      //       left: 23.w,
                                                      //       top: 6.h,
                                                      //       bottom: 22.h,
                                                      //       right: 21.w),
                                                      //   child: GlobalText(
                                                      //       controller.user.value.address,
                                                      //       color: const Color(0xff888e94),
                                                      //       fontWeight: FontWeight.w400,
                                                      //       fontStyle: FontStyle.normal,
                                                      //       fontSize: 13.sp),
                                                      // )
                                                    ]))
                                        ]))
                                : Container(),
                        SizedBox(
                          height: 15.h,
                        ),
                        Obx(() => controller.addrtype.value == ""
                            ? Container()
                            : controller.addrtype.value == "Saved" &&
                                    controller.select.value == "Delivered"
                                ? Container(
                                    decoration: const BoxDecoration(
                                        color: Color(0xffffffff)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 24.w,
                                                  top: 15.h,
                                                  right: 27.w),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GlobalText(
                                                        "Delivery Address",
                                                        color: const Color(
                                                            0xff111c26),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 17.sp),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (controller.addr
                                                                    .value ==
                                                                "" &&
                                                            controller.addrtype
                                                                    .value ==
                                                                "Saved") {
                                                          Get.snackbar(
                                                              "Missing Address",
                                                              "Please address your address");
                                                          return;
                                                        }

                                                        final controller2 = Get.put(
                                                            AddressController());
                                                        controller2.loadAddress
                                                            .value = false;
                                                        controller.addrtype
                                                            .value = "";
                                                        String tmp = controller
                                                            .addr.value;
                                                        controller.addr.value =
                                                            "";
                                                        Get.to(() =>
                                                            AddAddressScreen(
                                                                result: res2,
                                                                index:
                                                                    int.parse(
                                                                        tmp),
                                                                c: true,
                                                                dn: dn));
                                                      },
                                                      child: GlobalText(
                                                          "Change",
                                                          color: const Color(
                                                              0xffe41b00),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 13.sp),
                                                    )
                                                    // GestureDetector(
                                                    //   onTap: () => Get.toNamed(
                                                    //       Routes.ONLINEADDADRESS),
                                                    //   child: GlobalText("Change",
                                                    //       color: const Color(
                                                    //           0xffe41b00),
                                                    //       fontWeight:
                                                    //           FontWeight.w700,
                                                    //       fontStyle:
                                                    //           FontStyle.normal,
                                                    //       fontSize: 13.sp),
                                                    // )
                                                  ])),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          for (int i = 0; i < res2.length; i++)
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 24.w,
                                                    bottom: 20.h,
                                                    right: 27.w),
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 20.w,
                                                        child: Radio(
                                                            activeColor:
                                                                const Color(
                                                                    0xffe41b00),
                                                            value: i.toString(),
                                                            groupValue:
                                                                controller
                                                                    .addr.value,
                                                            onChanged: (value) {
                                                              controller.addr
                                                                      .value =
                                                                  value
                                                                      .toString();
                                                              print(controller
                                                                  .user
                                                                  .value
                                                                  .address);
                                                              print(res2[i]
                                                                  ["latitude"]);
                                                              var dist = Geolocator.distanceBetween(
                                                                  double.parse(
                                                                      rescontrol
                                                                          .rest
                                                                          .value
                                                                          .latitude),
                                                                  double.parse(
                                                                      rescontrol
                                                                          .rest
                                                                          .value
                                                                          .longitude),
                                                                  double.parse(
                                                                      res2[i][
                                                                          "latitude"]),
                                                                  double.parse(
                                                                      res2[i][
                                                                          "longitude"]));
                                                              int a =
                                                                  dist.toInt();
                                                              controller
                                                                  .price(a);
                                                              print(dist);
                                                              controller
                                                                  .user
                                                                  .value
                                                                  .address = res2[i]
                                                                      [
                                                                      "apart"] +
                                                                  "," +
                                                                  res2[i][
                                                                      "address"] +
                                                                  "\n" +
                                                                  res2[i]
                                                                      ["road"] +
                                                                  "\n" +
                                                                  res2[i]
                                                                      ["area"] +
                                                                  "," +
                                                                  res2[i][
                                                                      "postal_code"];
                                                              print(controller
                                                                  .user
                                                                  .value
                                                                  .address);
                                                            }),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GlobalText(
                                                                res2[i]["nickname"] ??
                                                                    "",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                              SizedBox(
                                                                height: 1.5.h,
                                                              ),
                                                              GlobalText(
                                                                res2[i]["apart"] +
                                                                    "," +
                                                                    res2[i][
                                                                        "address"],
                                                                color: const Color(
                                                                    0xff888E94),
                                                                fontSize: 17.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                              GlobalText(
                                                                res2[i]["road"],
                                                                color: const Color(
                                                                    0xff888E94),
                                                                fontSize: 17.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                              GlobalText(
                                                                res2[i]["area"] +
                                                                    "," +
                                                                    res2[i][
                                                                        "postal_code"],
                                                                color: const Color(
                                                                    0xff888E94),
                                                                fontSize: 17.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            ]),
                                                      ),

                                                      // Container(
                                                      //   margin: EdgeInsets.only(
                                                      //       left: 23.w, top: 22.h),
                                                      //   child: GlobalText(
                                                      //       controller.user.value.name!,
                                                      //       color: const Color(0xff111c26),
                                                      //       fontWeight: FontWeight.w700,
                                                      //       fontStyle: FontStyle.normal,
                                                      //       fontSize: 13.sp),
                                                      // ),
                                                      // Container(
                                                      //   margin: EdgeInsets.only(
                                                      //       left: 23.w,
                                                      //       top: 6.h,
                                                      //       bottom: 22.h,
                                                      //       right: 21.w),
                                                      //   child: GlobalText(
                                                      //       controller.user.value.address,
                                                      //       color: const Color(0xff888e94),
                                                      //       fontWeight: FontWeight.w400,
                                                      //       fontStyle: FontStyle.normal,
                                                      //       fontSize: 13.sp),
                                                      // )
                                                    ]))
                                        ]))
                                : controller.addrtype.value == "Current" &&
                                        controller.select.value == "Delivered"
                                    ? Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0xffffffff)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 24.w,
                                                      top: 15.h,
                                                      right: 27.w),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GlobalText(
                                                            "Delivery Address",
                                                            color: const Color(
                                                                0xff111c26),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 17.sp),
                                                        // GestureDetector(
                                                        //   onTap: () => Get.toNamed(
                                                        //       Routes.ONLINEADDADRESS),
                                                        //   child: GlobalText("Change",
                                                        //       color: const Color(
                                                        //           0xffe41b00),
                                                        //       fontWeight:
                                                        //           FontWeight.w700,
                                                        //       fontStyle:
                                                        //           FontStyle.normal,
                                                        //       fontSize: 13.sp),
                                                        // )
                                                      ])),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 23.w, top: 22.h),
                                                child: GlobalText(
                                                    controller.user.value.name!,
                                                    color:
                                                        const Color(0xff111c26),
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 13.sp),
                                              ),
                                              Obx(() => Container(
                                                    margin: EdgeInsets.only(
                                                        left: 23.w,
                                                        top: 6.h,
                                                        bottom: 22.h,
                                                        right: 21.w),
                                                    child: GlobalText(
                                                        controller
                                                            .user.value.address,
                                                        color: const Color(
                                                            0xff888e94),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 13.sp),
                                                  ))
                                            ]))
                                    : Container()),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            if (controller.loading.value == false) {
                              if (controller.addrtype.value == "" &&
                                  controller.select.value == "Delivered") {
                                Get.snackbar("Missing Address",
                                    "Please address your address");
                                return;
                              }
                              if (controller.addr.value == "" &&
                                  controller.addrtype.value == "Saved") {
                                Get.snackbar("Missing Address",
                                    "Please address your address");
                                return;
                              }
                              if (controller.addr.value == "" &&
                                  controller.select.value == "Drop") {
                                Get.snackbar("Missing Address",
                                    "Please address your address");
                                return;
                              }

                              if (controller.select.value == "Delivered" &&
                                  controller.user.value.address == "") {
                                Get.snackbar("Missing Address",
                                    "Please address your address");
                                return;
                              }

                              if (controller.cart.value.subTotal < 0) {
                                return;
                              }
                              if (controller.cart.value.nd!.value == 1) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Unable to deliver at this location. Please select drop off zone!!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                return;
                              }
                              TextEditingController address =
                                  TextEditingController(
                                      text: controller.user.value.address);
                              TextEditingController notes =
                                  TextEditingController();
                              showGeneralDialog(
                                context: context,
                                barrierColor: Colors.white, // Background color
                                barrierDismissible: false,
                                barrierLabel: 'Dialog',
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                                pageBuilder: (_, __, ___) {
                                  return SafeArea(
                                    child: Scaffold(
                                      appBar: appBar("CURRENT LOCATION", false,
                                          () => Get.back()),
                                      body: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      top: 19.h, bottom: 23.h),
                                                  child: GlobalText("Address",
                                                      color: const Color(
                                                          0xff111c26),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 20.sp)),
                                              Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 0.w),
                                                  child: TextFormField(
                                                    controller: address,
                                                    autofocus: false,
                                                    maxLines: 7,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.sp),
                                                    textAlign: TextAlign.start,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    obscureText: false,
                                                    cursorColor: Colors.black,
                                                    onChanged: (value) {
                                                      controller.user.value
                                                          .address = value;
                                                    },
                                                    minLines: 2,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      border: true
                                                          ? UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .grey,
                                                                      width:
                                                                          1.w),
                                                            )
                                                          : InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 17.h),
                                                      hintStyle: TextStyle(
                                                          color: const Color(
                                                              0xff888e94),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.sp),
                                                      hintText: "",
                                                    ),
                                                  )),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      top: 19.h, bottom: 23.h),
                                                  child: GlobalText(
                                                      "Please insure the above address is correct to your current location. If not please click on it and edit it",
                                                      color: const Color(
                                                          0xff111c26),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 15.sp)),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      top: 19.h, bottom: 23.h),
                                                  child: GlobalText(
                                                      "Notes for delivery",
                                                      color: const Color(
                                                          0xff111c26),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 20.sp)),
                                              Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 0.w),
                                                  child: TextFormField(
                                                    controller: notes,
                                                    autofocus: false,
                                                    maxLines: 10,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.sp),
                                                    textAlign: TextAlign.start,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    obscureText: false,
                                                    cursorColor: Colors.black,
                                                    onChanged: (value) {
                                                      controller.cart.value
                                                          .notes.value = value;
                                                    },
                                                    minLines: 7,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      border: true
                                                          ? UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .grey,
                                                                      width:
                                                                          1.w),
                                                            )
                                                          : InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 17.h),
                                                      hintStyle: TextStyle(
                                                          color: const Color(
                                                              0xff888e94),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.sp),
                                                      hintText: "Type Here...",
                                                    ),
                                                  )),
                                              SizedBox(height: 15.h),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (controller
                                                          .user.value.address ==
                                                      "") {
                                                    Get.snackbar(
                                                        "Missing Address",
                                                        "Please address your address");
                                                    return;
                                                  } else {
                                                    controller
                                                        .cart
                                                        .value
                                                        .deliverynotes
                                                        .value = dn;
                                                    controller
                                                        .updateLoader(true);
                                                    if (controller
                                                            .select.value ==
                                                        "Drop") {
                                                    } else {
                                                      controller.user.value
                                                          .dropzone_id = "";
                                                    }
                                                    final result =
                                                        await controller
                                                            .saveOrder();

                                                    print("hi");
                                                    if (result.status) {
                                                      controller
                                                          .updateLoader(false);
                                                      Get.to(() =>
                                                          PaymentScreen(
                                                              data: result));
                                                    } else {
                                                      controller
                                                          .updateLoader(false);
                                                      Get.snackbar(
                                                        "Error",
                                                        "Failed to save order",
                                                        backgroundColor:
                                                            Colors.red,
                                                        colorText: Colors.white,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    height: 59.h,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 37.w),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      color: const Color(
                                                          0xffEDCC40),
                                                      /*  gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            Color(0xfffe7500),
                                                            Color(0xffe41b00)
                                                          ],
                                                          stops: [0, 1],
                                                          begin: Alignment(
                                                              -1.00, 0.00),
                                                          end: Alignment(
                                                              1.00, -0.00),
                                                          // angle: 90,
                                                          // scale: undefined,
                                                        ) */
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: GlobalText("Confirm",
                                                        color: const Color(
                                                            0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 20.sp)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 37.w, right: 37.w, top: 24.h),
                              height: 59.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: const Color(0xffEDCC40)
                                  /* gradient: const LinearGradient(
                                    colors: [
                                      Color(0xfffe7500),
                                      Color(0xffe41b00)
                                    ],
                                    stops: [0, 1],
                                    begin: Alignment(-1.00, 0.00),
                                    end: Alignment(1.00, -0.00),
                                    // angle: 90,
                                    // scale: undefined,
                                  ) */
                                  ),
                              alignment: Alignment.center,
                              child: controller.loading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : GlobalText("Proceed to Pay",
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.sp)),
                        )
                      ]),
                ),
              ))),
    );
  }
}
