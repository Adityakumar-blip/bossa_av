import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/global_text.dart';

import 'order_history_controller.dart';

class OrderHistoryScreen extends GetView<OrderHistoryController> {
  @override
  final controller = Get.put(OrderHistoryController());

  OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar("My Order History", false, () => Get.back()),
        body: GetBuilder<OrderHistoryController>(
          init: controller,
          builder: ((cont) => cont.loading.value
              ? CommonMethods().loader()
              : !cont.hasOrder.value
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/scooter.svg"),
                            SizedBox(height: 25.h),
                            GlobalText("Your Order is Empty",
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 22.sp),
                            SizedBox(height: 11.h),
                            GlobalText("You haven’t Placed any Orders Yet.",
                                color: const Color(0xff888e94),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 15.sp),
                          ]),
                    )
                  : SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    vertical: 34.h, horizontal: 25.w),
                                itemCount: controller.history!.histories.length,
                                itemBuilder: (context, index) => SizedBox(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 30.h,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff000000),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r))),
                                            SizedBox(height: 9.h),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GlobalText(
                                                      "Order No - ${cont.history!.histories[index].orderNo} ",
                                                      color: const Color(
                                                          0xff111c26),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 17.sp),
                                                  GlobalText(
                                                      cont
                                                          .history!
                                                          .histories[index]
                                                          .total,
                                                      color: const Color(
                                                          0xff141f29),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 15.sp),
                                                ]),
                                            SizedBox(height: 3.h),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GlobalText(
                                                      cont.history!
                                                          .histories[index].res,
                                                      color: const Color(
                                                          0xff888e94),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.sp),
                                                  GlobalText(
                                                      cont
                                                          .history!
                                                          .histories[index]
                                                          .status,
                                                      color: const Color(
                                                          0xff00aa63),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.sp),
                                                ]),
                                            SizedBox(height: 21.h)
                                          ]),
                                    ))
                          ]),
                    )),
        ),
      ),
    );
  }
}
