// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/onlines/Checkout/checkout_screen.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/global_text.dart';

import '../Checkout/checkout_controller.dart';
import 'my_bag_controller.dart';

class MyBagScreen extends GetView<MyBagController> {
  @override
  final controller = Get.put(MyBagController());

  MyBagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<MyBagController>(
        init: controller,
        builder: ((contr) => SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        appBar("My Bag", true, () {
                          Get.back();
                        }),
                        controller.cart == null
                            ? GlobalText("No Items Found!!", fontSize: 30.sp)
                            : controller.cart!.value.items!.isNotEmpty
                                ? SingleChildScrollView(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) =>
                                          Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 26.h),
                                              padding:
                                                  EdgeInsets.only(bottom: 10.h),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color(0x23000000),
                                                      offset: Offset(0, 5),
                                                      blurRadius: 13,
                                                      spreadRadius: 0)
                                                ],
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            right: 18.w),
                                                        width: 50.w,
                                                        height: 97.h,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Color(
                                                                    0xffffffff))),
                                                    Obx(() => Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 10.h),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: GlobalText(
                                                                    controller
                                                                        .cart!
                                                                        .value
                                                                        .items![
                                                                            index]
                                                                        .name,
                                                                    color: const Color(
                                                                        0xff111c26),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        16.sp),
                                                              ),
                                                              SizedBox(
                                                                  height: 4.h),
                                                              GlobalText(
                                                                  "${controller.cart!.value.items![index].qantity} X R${controller.cart!.value.items![index].price.toStringAsFixed(2)}",
                                                                  color: const Color(
                                                                      0xff888e94),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      12.sp),
                                                              SizedBox(
                                                                  height: 10.h),
                                                              Row(children: [
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap: () {
                                                                    controller
                                                                        .removeItem(
                                                                            index);
                                                                  },
                                                                  child: Container(
                                                                      width: 30.w,
                                                                      height: 30.h,
                                                                      alignment: Alignment.center,
                                                                      // ignore: sort_child_properties_last
                                                                      child: Center(
                                                                        child: Icon(
                                                                            Icons
                                                                                .remove,
                                                                            color: controller.cart!.value.items![index].qantity == 1
                                                                                ? const Color(0xffe0e0e0)
                                                                                : const Color(0xff111c26)),
                                                                      ),
                                                                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: controller.cart!.value.items![index].qantity == 1 ? const Color(0xffe0e0e0) : const Color(0xff111c26), width: 2.w))),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        10.w),
                                                                GlobalText(
                                                                    "${controller.cart!.value.items![index].qantity}",
                                                                    color: const Color(
                                                                        0xff181009),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        16.sp),
                                                                SizedBox(
                                                                    width:
                                                                        10.w),
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap: () {
                                                                    controller
                                                                        .addToItem(
                                                                            index);
                                                                  },
                                                                  child: Container(
                                                                      width: 30.w,
                                                                      height: 30.h,
                                                                      alignment: Alignment.center,
                                                                      // ignore: sort_child_properties_last
                                                                      child: const Center(
                                                                        child: Icon(
                                                                            Icons
                                                                                .add,
                                                                            color:
                                                                                Color(0xff111c26)),
                                                                      ),
                                                                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xff111c26), width: 2.w))),
                                                                ),
                                                              ])
                                                            ])),
                                                    const Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () {
                                                              controller.removeBagItem(
                                                                  controller
                                                                          .cart!
                                                                          .value
                                                                          .items![
                                                                      index]);
                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right: 10
                                                                            .w,
                                                                        top: 10
                                                                            .h,
                                                                        bottom: 25
                                                                            .h),
                                                                child: const Icon(
                                                                    CupertinoIcons
                                                                        .clear,
                                                                    color: Color(
                                                                        0xffaeaeae),
                                                                    size: 20))),
                                                        Obx(() => Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          16.w,
                                                                      bottom:
                                                                          15.h),
                                                              child: GlobalText(
                                                                  "R${controller.itemTotal(controller.cart!.value.items![index]).toStringAsFixed(2)}",
                                                                  color: const Color(
                                                                      0xff111c26),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.sp),
                                                            )),
                                                        SizedBox(height: 10.h),
                                                      ],
                                                    )
                                                  ])),
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                          top: 39.h,
                                          left: 25.w,
                                          right: 25.w,
                                          bottom: 10.h),
                                      itemCount:
                                          controller.cart!.value.items!.length,
                                    ),
                                  )
                                : Container(),
                      ]),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      TextEditingController notes = TextEditingController();
                      showGeneralDialog(
                          context: context,
                          barrierColor: Colors.white, // Background color
                          barrierDismissible: false,
                          barrierLabel: 'Dialog',
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: (_, __, ___) {
                            return SafeArea(
                              child: Scaffold(
                                appBar: appBar(
                                    "FOOD NOTES", false, () => Get.back()),
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
                                            child: GlobalText("Notes",
                                                color: const Color(0xff111c26),
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 20.sp)),
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: 19.h, bottom: 23.h),
                                            child: GlobalText(
                                                "Please enter any information you would like us to know about your order below",
                                                color: const Color(0xff111c26),
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15.sp)),
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: 19.h, bottom: 23.h),
                                            child: GlobalText("Notes for food",
                                                color: const Color(0xff111c26),
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
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
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.sp),
                                              textAlign: TextAlign.start,
                                              keyboardType: TextInputType.text,
                                              obscureText: false,
                                              cursorColor: Colors.black,
                                              onChanged: (value) {
                                                controller
                                                    .cart!
                                                    .value
                                                    .deliverynotes
                                                    .value = value;

                                                print(controller.cart!.value
                                                    .deliverynotes.value);
                                              },
                                              minLines: 7,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: true
                                                    ? UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.w),
                                                      )
                                                    : InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        0, 0, 0, 17.h),
                                                hintStyle: TextStyle(
                                                    color:
                                                        const Color(0xff888e94),
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.sp),
                                                hintText: "Type Here...",
                                              ),
                                            )),
                                        SizedBox(height: 15.h),
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              height: 59.h,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 37.w),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  color: Color(0xffEDCC40)
                                                  /* gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xfffe7500),
                                                      Color(0xffe41b00)
                                                    ],
                                                    stops: [0, 1],
                                                    begin:
                                                        Alignment(-1.00, 0.00),
                                                    end: Alignment(1.00, -0.00),
                                                    // angle: 90,
                                                    // scale: undefined,
                                                  ) */
                                                  ),
                                              alignment: Alignment.center,
                                              child: GlobalText("Confirm",
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 20.sp)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                        margin: EdgeInsets.only(
                          left: 25.w,
                          right: 25.w,
                        ),
                        height: 59.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffEDCC40)
                            /*  gradient: LinearGradient(
                              colors: [Color(0xffe51f00), Color(0xfffd7200)],
                              stops: [0, 1],
                              begin: Alignment(1.00, -0.00),
                              end: Alignment(-1.00, 0.00),
                            ) */
                            ),
                        alignment: Alignment.center,
                        child: GlobalText("ADD FOOD NOTES",
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.sp)),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 16.h, horizontal: 25.w),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GlobalText("Sub Total",
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.sp),
                            GlobalText(
                                "R${controller.cart?.value.subTotal.toStringAsFixed(2) ?? "0.00"}",
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.sp)
                          ])),
                  // // Container(
                  // //     margin: EdgeInsets.only(
                  // //         bottom: 26.h, left: 25.w, right: 25.w),
                  // //     child: Row(
                  // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // //         children: [
                  // //           GlobalText("Delivery Fee",
                  // //               color: const Color(0xff111c26),
                  // //               fontWeight: FontWeight.w500,
                  // //               fontStyle: FontStyle.normal,
                  // //               fontSize: 16.sp),
                  // //           GlobalText(
                  // //               "R${controller.cart?.value.deliveryFee ?? "0.00"} ",
                  // //               color: const Color(0xffe82800),
                  // //               fontWeight: FontWeight.w500,
                  // //               fontStyle: FontStyle.normal,
                  // //               fontSize: 16.sp)
                  //         ])),
                  Container(
                      height: 1.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffe0e0e0), width: 1.w))),
                  Container(
                      margin: EdgeInsets.only(
                          bottom: 26.h, top: 21.h, left: 25.w, right: 25.w),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GlobalText("Total",
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 20.sp),
                            GlobalText(
                                "R${controller.cart?.value.total?.toStringAsFixed(2) ?? "0.00"}",
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 20.sp)
                          ])),

                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      print(controller.cart!.value.deliverynotes);
                      Get.to(() => CheckOutScreen(
                            dn: controller.cart!.value.deliverynotes.toString(),
                          ));
                    },
                    child: Container(
                        height: 74.h,
                        decoration: const BoxDecoration(color: Color(0xffEDCC40)
                            /* gradient: LinearGradient(
                          colors: [Color(0xffe51f00), Color(0xfffd7200)],
                          stops: [0, 1],
                          begin: Alignment(1.00, -0.00),
                          end: Alignment(-1.00, 0.00),
                        ) */
                            ),
                        alignment: Alignment.center,
                        child: GlobalText("Checkout",
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.sp)),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
