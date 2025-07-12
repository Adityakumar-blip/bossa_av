import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/global_text.dart';
import 'order_favourite_controller.dart';

class OrderFavouriteScreen extends GetView<OrderFavouriteController> {
  @override
  final controller = Get.put(OrderFavouriteController());

  OrderFavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar("My Favourites", false, () => Get.back()),
        body: GetBuilder<OrderFavouriteController>(
          init: controller,
          builder: ((cont) => cont.is_loading.value
              ? CommonMethods().loader()
              : !cont.hasOrder.value
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/note.svg"),
                            SizedBox(height: 25.h),
                            GlobalText("Your Favourites is Empty",
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 22.sp),
                            SizedBox(height: 11.h),
                            GlobalText("You haven’t Marked any Favourites Yet.",
                                color: const Color(0xff888e94),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 15.sp),
                          ]),
                    )
                  : SizedBox(
                      child: Column(children: [
                        /* Obx(() =>  */SingleChildScrollView(
                              child: ListView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 34.h, horizontal: 25.w),
                                  itemCount: controller.fav!.fav.length,
                                  itemBuilder: (context, index) =>
                                      Column(children: [
                                        Container(
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff000000),
                                                borderRadius:
                                                    BorderRadius.circular(5.r)),
                                            alignment: Alignment.centerRight,
                                            padding:
                                                EdgeInsets.only(right: 16.w),
                                            child: SvgPicture.asset(
                                                "assets/images/heart.svg")),
                                        SizedBox(height: 9.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GlobalText(
                                                        controller
                                                            .fav!
                                                            .fav[index]
                                                            .restName,
                                                        color: const Color(
                                                            0xff111c26),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 17.sp),
                                                    GlobalText(
                                                        controller
                                                            .fav!
                                                            .fav[index]
                                                            .location,
                                                        color: const Color(
                                                            0xff888e94),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 11.sp),
                                                  ])
                                            ]),
                                        SizedBox(height: 21.h)
                                      ])),
                            )
                            // )
                      ]),
                    )),
        ),
      ),
    );
  }
}
