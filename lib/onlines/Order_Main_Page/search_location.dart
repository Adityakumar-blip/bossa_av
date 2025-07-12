import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/onlines/Order_Main_Page/search_controller.dart';
import 'package:Bossa/onlines/Restuarent_Menu_Page/reasurant_menu_page.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/global_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/restaurants_model.dart';
import '../../services/storage/storage_service.dart';
import '../Restuarent_Menu_Page/reasurant_menu_controller.dart';

class SearchLocationScreen extends GetView<SearchController2> {
  @override
  final controller = Get.put(SearchController2());
  SearchLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar("Search Location", false, () => Get.back()),
        body: GetBuilder<SearchController2>(
            init: controller,
            builder: (x) => ListView(
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 44.h),
                      Center(
                          child: GlobalText("Find Food Near You",
                              color: const Color(0xff111c26),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 32.sp)),
                      Center(
                          child: Container(
                        margin:
                            EdgeInsets.only(left: 37.w, right: 37.w, top: 14.h),
                        child: GlobalText(
                            "We need to know your Address in Order to Find Delicious Food for You.!",
                            color: const Color(0xff8c999f),
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.sp),
                      )),
                      SizedBox(height: 60.h),
                      GestureDetector(
                        onTap: (() async {
                          await x.find();
                        }),
                        child: Container(
                            height: 59.h,
                            margin: EdgeInsets.symmetric(horizontal: 37.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                 color: Color(0xffEDCC40),
                                /* gradient: const LinearGradient(
                                  colors: [
                                    Color(0xfffe7500),
                                    Color(0xffe41b00)
                                  ],
                                  stops: [0, 1],
                                  begin: Alignment(-1.00, 0.00),
                                  end: Alignment(1.00, -0.00),
                                ) */),
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.gps_fixed,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3.5.w),
                                  GlobalText("Use Current Location",
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.sp)
                                ])),
                      ),
                      SizedBox(height: 20.h),
                      x.isloading.value
                          ? CommonMethods().loader()
                          : x.res.value.res.isEmpty
                              ? Container(
                                  child: Center(
                                    child: GlobalText("No restaurant near you.",
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20.sp),
                                  ),
                                )
                              : SizedBox(
                                  height: 500.h,
                                  child: Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: 10.h,
                                            top: 10.h,
                                            left: 100.w,
                                            right: 100.w),
                                        itemCount: x.res.value.res.length,
                                        itemBuilder: (context, index) =>
                                            childCustomListItem(
                                                x.res.value.res[index])),
                                  ),
                                )
                    ])),
      ),
    );
  }

  Widget childCustomListItem(Restaurant res) {
    return Container(
      padding:
          EdgeInsets.only(bottom: 10.h, top: 10.h, right: 10.w, left: 10.w),
      child: GestureDetector(
        onTap: () async {
          var storage = Get.find<StorageService>();
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String? resid = preferences.getString("resid");
          var storageCart = storage.getCart();
          print(storageCart);
          print(resid);
          print(res.id);
          try {
            if (resid == null) {
              preferences.setString("resid", res.id.toString());
              Get.to(
                  () => ReasurantMenuScreen(
                      resID: res.id,
                      name: res.resName,
                      address: res.resArea,
                      fetchapi: true,
                      km: res.distance),
                  binding:
                      BindingsBuilder.put(() => ReasurantMenuController()));
            } else if (resid != res.id.toString() && storageCart != null) {
              Get.defaultDialog(
                middleText:
                    "On switching to another restaurant, your cart will be emptied.",
                cancel: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      width: 100.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                           color: Color(0xffEDCC40),
                          /* gradient: const LinearGradient(
                            colors: [Color(0xfffe7500), Color(0xffe41b00)],
                            stops: [0, 1],
                            begin: Alignment(-1.00, 0.00),
                            end: Alignment(1.00, -0.00),
                            // angle: 90,
                            // scale: undefined,
                          ) */),
                      alignment: Alignment.center,
                      child: GlobalText("CANCEL",
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp)),
                ),
                middleTextStyle: TextStyle(color: Colors.black),
                radius: 30,
                confirm: InkWell(
                  onTap: () {
                    preferences.setString("resid", res.id.toString());
                    Get.delete<ReasurantMenuController>();
                    storage.clearData();
                    Get.back();
                    Get.to(
                        () => ReasurantMenuScreen(
                            resID: res.id,
                            name: res.resName,
                            address: res.resArea,
                            fetchapi: true,
                            km: res.distance),
                        binding: BindingsBuilder.put(
                            () => ReasurantMenuController()));
                  },
                  child: Container(
                      height: 45.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                           color: Color(0xffEDCC40),
                         /*  gradient: const LinearGradient(
                            colors: [Color(0xfffe7500), Color(0xffe41b00)],
                            stops: [0, 1],
                            begin: Alignment(-1.00, 0.00),
                            end: Alignment(1.00, -0.00),
                            // angle: 90,
                            // scale: undefined,
                          ) */),
                      alignment: Alignment.center,
                      child: GlobalText("OK",
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp)),
                ),
              );
            } else {
              preferences.setString("resid", res.id.toString());
              Get.to(
                  () => ReasurantMenuScreen(
                      resID: res.id,
                      name: res.resName,
                      address: res.resArea,
                      fetchapi: true,
                      km: res.distance),
                  binding:
                      BindingsBuilder.put(() => ReasurantMenuController()));
            }
          } catch (e) {
            print("in");
          }
        },
        child: Container(
            width: 149.w,
            height: 140.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(5, 5),
                      blurRadius: 3,
                      spreadRadius: 0)
                ],
                color: const Color(0xffffffff)),
            child: Column(children: [
              SizedBox(height: 2.h),
              res.image != null
                  ? res.image!
                  : Image.network(
                      res.url,
                      fit: BoxFit.fill,
                      height: 80.h,
                    ),
              const Spacer(),
              Container(
                  width: 160.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                     color: Color(0xffEDCC40),
                    /* gradient: const LinearGradient(
                      colors: [
                        Color(0xffed2124),
                        Color(0xfff47529),
                        Color(0xfffbb042)
                      ],
                      stops: [0, 0.4827589988708496, 1],
                      begin: Alignment(-1.00, 0.00),
                      end: Alignment(1.00, -0.00),
                      // angle: 90,
                      // scale: undefined,
                    ), */
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x21000000),
                          offset: Offset(0, 2),
                          blurRadius: 48,
                          spreadRadius: 0)
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 11.h, horizontal: 10.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 18.h,
                          child: GlobalText(res.resName,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              sfProText: true,
                              fontStyle: FontStyle.normal,
                              fontSize: 10.sp),
                        ),
                        GlobalText("${res.distance} km",
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                            sfProText: true,
                            fontStyle: FontStyle.normal,
                            fontSize: 8.sp)
                      ]))
            ])),
      ),
    );
  }
}
