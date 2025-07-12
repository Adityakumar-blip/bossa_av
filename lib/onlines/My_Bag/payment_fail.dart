import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/global_text.dart';

import '../Checkout/checkout_controller.dart';

class PaymentFail extends GetView<CheckOutController> {
  @override
  final controller = Get.put(CheckOutController());

  PaymentFail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f6f9),
        body: GetBuilder(
          init: controller,
          builder: ((conx) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(top: 60.h, left: 25.w, right: 25.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {},
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Icon(CupertinoIcons.chevron_back,
                                      color: Colors.transparent, size: 30.h)),
                              GlobalText("Order History",
                                  color: const Color(0xff111c26),
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.sp),
                              SizedBox(width: 20.w, height: 5.h)
                            ]),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 28.h, bottom: 10.h),
                          decoration:
                              const BoxDecoration(color: Color(0xffffffff)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                      "assets/images/success.jpg",
                                      height: 200.w,
                                      width: 200.h),
                                ),
                                Center(
                                    child: GlobalText(
                                        "Failed to place the order",
                                        color: const Color(0xff111c26),
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 17.sp)),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 19.h, left: 24.w),
                                    child: GlobalText("Items Total",
                                        color: const Color(0xff111c26),
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 17.sp)),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.cart.value.items!.length,
                                    itemBuilder: (context, index) => Padding(
                                          padding: EdgeInsets.only(
                                              top: 19.h,
                                              left: 24.w,
                                              right: 25.w),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GlobalText(
                                                  controller.cart.value
                                                      .items![index].name,
                                                ),
                                                GlobalText(
                                                  ("R${(controller.cart.value.items![index].price * controller.cart.value.items![index].qantity).toStringAsFixed(2)}"),
                                                )
                                              ]),
                                        )),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 68.h, left: 25.w, right: 25.w),
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
                                /* Container(
                margin: EdgeInsets.only(top: 23.h, left: 25.w, right: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlobalText("Discount Price",
                        color: const Color(0xff141f29),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 15.sp),
                    GlobalText("+ R4.25",
                        color: const Color(0xff00aa63),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 15.sp),
                  ],
                )), */
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
                                            controller.select == "Collect"
                                                ? "R0.00"
                                                : "R${controller.cart.value.deliveryFee}",
                                            color: const Color(0xffe41b00),
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
                                        left: 25.w, right: 25.w, bottom: 23.h),
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
                                            controller.select == "Collect"
                                                ? "R${controller.cart.value.subTotal.toStringAsFixed(2)}"
                                                : "R${controller.total.value.toStringAsFixed(2)}",
                                            color: const Color(0xffe41b00),
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20.sp),
                                      ],
                                    )),
                              ])),
                      controller.select == "Delivered"
                          ? Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffffffff)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 24.w, top: 15.h, right: 27.w),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalText("Delivery Address",
                                                  color:
                                                      const Color(0xff111c26),
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 17.sp),
                                            ])),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 23.w, top: 22.h),
                                      child: GlobalText(
                                          controller.user.value.name!,
                                          color: const Color(0xff111c26),
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 13.sp),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 23.w,
                                          top: 6.h,
                                          bottom: 22.h,
                                          right: 201.w),
                                      child: GlobalText(
                                          controller.user.value.address,
                                          color: const Color(0xff888e94),
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 13.sp),
                                    )
                                  ]))
                          : Container(),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          Get.offAllNamed(Routes.ONLINEORDERMAIN);
                          //Get.toNamed(Routes.ONLINEORDERMAIN);
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 37.w, right: 37.w, top: 24.h),
                            height: 59.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                 color: Color(0xffEDCC40),
                              /*   gradient: const LinearGradient(
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
                            child: controller.loading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : GlobalText("OK",
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.sp)),
                      )
                    ]),
              ))),
        ));
  }
}
