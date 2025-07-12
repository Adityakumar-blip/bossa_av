import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:Bossa/util/bottom_bar.dart';
import 'package:Bossa/util/global_text.dart';
import 'detail_controller.dart';

class DetailScreen extends GetView<DetailController> {
  @override
  final controller = Get.put(DetailController());

  DetailScreen({Key? key}) : super(key: key);

  Widget customButton(String text, Function onTap) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(),
      child: Container(
          height: 45.h,
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Color(0xffEDCC40),
            /* gradient: const LinearGradient(
                colors: [
                  Color(0xffed2024),
                  Color(0xfff47729),
                  Color(0xfffbaf42)
                ],
                stops: [0, 0.4679799973964691, 1],
                begin: Alignment(-1.00, 0.00),
                end: Alignment(1.00, -0.00),
                // angle: 90,
                // scale: undefined,
              ) */
          ),
          alignment: Alignment.center,
          child: GlobalText(text,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 15.sp)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomBar(controller.selectedIndex),
        body: ListView(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                  height: 87.h,
                  width: 375.w,
                  decoration: const BoxDecoration(
                    color: Color(0xffEDCC40),

                    /*  gradient: LinearGradient(
                    colors: [
                      Color(0xffed2024),
                      Color(0xfff47729),
                      Color(0xfffbb042)
                    ],
                    stops: [0, 0.4827589988708496, 1],
                    begin: Alignment(-1.00, 0.00),
                    end: Alignment(1.00, -0.00),
                    // angle: 90,
                    // scale: undefined,
                  ) */
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 11.h),
                  child: Row(children: [
                    SizedBox(width: 24.w),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child:
                            Image.asset("assets/images/back.png", width: 24.w)),
                    const Spacer(flex: 2),
                    GlobalText("BOSSA REWARDS",
                        color: Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 2.166666732788086),
                    const Spacer(flex: 4),
                  ])),
              Container(
                  height: 176.h,
                  margin: EdgeInsets.only(
                      top: 18.h, bottom: 15.h, left: 20.w, right: 19.w),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff707070), width: 1.w),
                      color: const Color(0xffffffff)),
                  alignment: Alignment.center,
                  child: GlobalText("Restaurant logo",
                      rubikText: true,
                      color: const Color(0xff222222),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 21.sp,
                      textAlign: TextAlign.center)),
              Center(
                child: GlobalText("Name",
                    color: const Color(0xff0e0b20),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.sp),
              ),
              SizedBox(height: 15.h),
              Center(
                child: GlobalText("Location",
                    color: const Color(0xff0e0b20),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.sp),
              ),
              SizedBox(height: 10.h),
              customButton("Get Directions", () {}),
              SizedBox(height: 6.h),
              customButton("Call Now", () {}),
              SizedBox(height: 16.h),
              Center(
                child: GlobalText("Opening Hours",
                    color: const Color(0xff0e0b20),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.2),
              ),
              SizedBox(height: 11.h),
              textRow("Monday", "8:00am - 5:00pm"),
              textRow("Tuesday", "8:00am - 5:00pm"),
              textRow("Wednesday", "8:00am - 5:00pm"),
              textRow("Thursday", "8:00am - 5:00pm"),
              textRow("Friday", "8:00am - 5:00pm"),
              textRow("Saturday", "8:00am - 5:00pm"),
              textRow("Sunday", "8:00am - 5:00pm"),
              textRow("Public Holidays", "8:00am - 5:00pm"),
              SizedBox(height: 10.h),
              customButton("Rate Restaurant", () {}),
              SizedBox(height: 20.h),
              customButton("Go Back", () {
                Get.back();
              })
            ]));
  }

  Widget textRow(String mainText, String subText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 45.w),
      child: Row(children: [
        Expanded(
            flex: 1,
            child: GlobalText(mainText,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.75)),
        Expanded(
            flex: 1,
            child: GlobalText(subText,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.75))
      ]),
    );
  }
}
