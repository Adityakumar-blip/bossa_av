import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/global_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/cart.dart';
import '../../services/storage/storage_service.dart';
import '../My_Bag/my_bag_controller.dart';
import '../My_Bag/my_bag_screen.dart';
import '../Payment/payment_controller.dart';
import '../Profile/profile_screen.dart';
import '../Restuarent_Menu_Page/reasurant_menu_controller.dart';
import '../Restuarent_Menu_Page/reasurant_menu_page.dart';
import 'order_main_controller.dart';
import 'search_location.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height / 1.2)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OrderMainScreen extends GetView<OrderMainController> {
  @override
  final controller = Get.put(OrderMainController());

  OrderMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
            height: 74.h,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                    color: Color(0x23000000),
                    offset: Offset(0, 5),
                    blurRadius: 13,
                    spreadRadius: 0)
              ],
            ),
            child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      bottomBarItem(0),
                      bottomBarItem(1),
                      bottomBarItem(2),
                      bottomBarItem(3)
                    ]))),
        body: Obx(() => controller.selectedIndex.value == 0
            ? Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                        height: 288.h,
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(color: Color(0xffEDCC40)
                            /*   gradient: LinearGradient(
                          colors: [Color(0xffEDCC40), Color(0xfff32735)],
                          stops: [0, 1],
                          begin: Alignment(1.00, -0.00),
                          end: Alignment(-1.00, 0.00),
                        ) */
                            )),
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 69.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                //Get.offAndToNamed(Routes.ROOT);
                                Get.offAllNamed(Routes.ROOT);
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Icon(CupertinoIcons.chevron_back,
                                  size: 30.h)),
                          SizedBox(width: 15.w),
                          GlobalText("Restaurants Close To You",
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.sp),
                          SizedBox(width: 15.w),
                          Container(
                              width: 20.w,
                              height: 0.714.h,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffffffff),
                                      width: 2.w)))
                        ],
                      ),
                      controller.restuarantLoading.value
                          ? CommonMethods().loader()
                          : controller.restHasValue.value
                              ? Container(
                                  height: 190.h,
                                  margin:
                                      EdgeInsets.only(top: 35.h, left: 26.w),
                                  child: Swiper(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return controller
                                                  .res.res[index].resName ==
                                              ''
                                          ? defaultSwiperItem(115.h)
                                          : swiperItem(context,
                                              controller.res.res[index]);
                                    },
                                    viewportFraction: 0.58,
                                    itemCount: controller.res.res.length,
                                  ),
                                )
                              : defaultSwiperItem(181.h),
                      controller.specialsLoading.value
                          ? CommonMethods().loader()
                          : controller.specialHasValue.value
                              ? Container(
                                  height: 270.h,
                                  padding: EdgeInsets.only(
                                      top: 16.h, bottom: 32.h, left: 26.w),
                                  child: Swiper(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var resId = controller
                                          .specials!.specials[index].id;
                                      return GestureDetector(
                                        onTap: () async {
                                          var storage =
                                              Get.find<StorageService>();
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? resid =
                                              preferences.getString("resid");
                                          var storageCart = storage.getCart();
                                          print(storageCart);
                                          print(resid);
                                          try {
                                            if (resid == null) {
                                              preferences.setString(
                                                  "resid", resId);
                                              Get.to(() => ReasurantMenuScreen(
                                                  resID: int.parse(resId),
                                                  name: controller
                                                      .specials!
                                                      .specials[index]
                                                      .storename,
                                                  address: "",
                                                  km: controller
                                                      .specials!
                                                      .specials[index]
                                                      .distance));
                                            } else if (resid != resId &&
                                                storageCart != null) {
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
                                                        color:
                                                            Color(0xffEDCC40),
                                                        /* gradient:
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: GlobalText(
                                                          "CANCEL",
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 18.sp)),
                                                ),
                                                middleTextStyle: TextStyle(
                                                    color: Colors.black),
                                                radius: 30,
                                                confirm: InkWell(
                                                  onTap: () {
                                                    preferences.setString(
                                                        "resid", resId);
                                                    Get.delete<
                                                        ReasurantMenuController>();
                                                    storage.clearData();
                                                    Get.back();
                                                    Get.to(() =>
                                                        ReasurantMenuScreen(
                                                            resID: int.parse(
                                                                resId),
                                                            name: controller
                                                                .specials!
                                                                .specials[index]
                                                                .storename,
                                                            address: "",
                                                            km: controller
                                                                .specials!
                                                                .specials[index]
                                                                .distance));
                                                  },
                                                  child: Container(
                                                      height: 45.h,
                                                      width: 100.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
                                                        color:
                                                            Color(0xffEDCC40),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: GlobalText("OK",
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 18.sp)),
                                                ),
                                              );
                                            } else {
                                              preferences.setString(
                                                  "resid", resId);
                                              Get.to(() => ReasurantMenuScreen(
                                                  resID: int.parse(resId),
                                                  name: controller
                                                      .specials!
                                                      .specials[index]
                                                      .storename,
                                                  address: "",
                                                  km: controller
                                                      .specials!
                                                      .specials[index]
                                                      .distance));
                                            }
                                          } catch (e) {
                                            print("in");
                                          }
                                        },
                                        child: Container(
                                            padding:
                                                EdgeInsets.only(right: 15.w),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                                child: Image.network(
                                                  controller.specials!
                                                      .specials[index].url,
                                                  fit: BoxFit.fill,
                                                ))),
                                      );
                                    },
                                    layout: SwiperLayout.DEFAULT,
                                    itemCount:
                                        controller.specials!.specials.length,
                                    viewportFraction: 0.92,
                                    indicatorLayout: PageIndicatorLayout.COLOR,
                                  ))
                              : defaultSwiperItem(186.h),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //           width: 20.w,
                      //           height: 0.714.h,
                      //           decoration: BoxDecoration(
                      //               border: Border.all(
                      //                   color: const Color(0xffe72600),
                      //                   width: 2.w))),
                      //       SizedBox(width: 4.w),
                      //       GlobalText("FEATURED RESTAURANTS",
                      //           color: const Color(0xff111c26),
                      //           fontWeight: FontWeight.w700,
                      //           fontStyle: FontStyle.normal,
                      //           fontSize: 17.sp),
                      //       SizedBox(width: 4.w),
                      //       Container(
                      //           width: 20.w,
                      //           height: 0.714.h,
                      //           decoration: BoxDecoration(
                      //               border: Border.all(
                      //                   color: const Color(0xffe72600),
                      //                   width: 2.w)))
                      //     ]),
                      // controller.restuarantLoading.value
                      //     ? CommonMethods().loader()
                      //     : controller.restHasValue.value
                      //         ? Container(
                      //             margin: EdgeInsets.only(
                      //                 left: 26.w, top: 24.h, bottom: 11.h),
                      //             height: 250.h,
                      //             child: Swiper(
                      //               itemBuilder:
                      //                   (BuildContext context, int index) {
                      //                 return commonSwiperItem(
                      //                     controller.res.res[index]);
                      //               },
                      //               layout: SwiperLayout.DEFAULT,
                      //               itemCount: controller.res.res.length,
                      //               viewportFraction: 0.9,
                      //               indicatorLayout: PageIndicatorLayout.COLOR,
                      //             ))
                      //         : defaultSwiperItem(175.h)
                    ],
                  )
                ],
              )
            : controller.selectedIndex.value == 1
                ? searchPage()
                : controller.selectedIndex.value == 2
                    ? MyBagScreen()
                    : ProfileScreen()));
  }

  Widget defaultSwiperItem(double height) {
    return Container(
        margin: EdgeInsets.only(top: 35.h, left: 26.w),
        padding: EdgeInsets.only(right: 25.w),
        child: Column(children: [
          Container(
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  color: Color.fromARGB(255, 201, 187, 187),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/pmck_logo2.png'),
                    fit: BoxFit.contain,
                  ))),
          Container(
              margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlobalText("Coming soon",
                            color: const Color(0xff111c26),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.sp),
                        GlobalText("",
                            color: const Color(0xff888e94),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            fontSize: 12.sp),
                      ],
                    ),
                    GlobalText("",
                        color: const Color(0xff888e94),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 11.sp)
                  ]))
        ]));
  }

  Widget commonSwiperItem(Restaurant res) {
    return GestureDetector(
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
            Get.to(() => ReasurantMenuScreen(
                resID: res.id,
                name: res.resName,
                address: res.resArea,
                fetchapi: true,
                km: res.distance));
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
                      /*   gradient: const LinearGradient(
                          colors: [Color(0xfffe7500), Color(0xffe41b00)],
                          stops: [0, 1],
                          begin: Alignment(-1.00, 0.00),
                          end: Alignment(1.00, -0.00),
                          // angle: 90,
                          // scale: undefined,
                        ) */
                    ),
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
                  Get.to(() => ReasurantMenuScreen(
                      resID: res.id,
                      name: res.resName,
                      address: res.resArea,
                      fetchapi: true,
                      km: res.distance));
                },
                child: Container(
                    height: 45.h,
                    width: 100.w,
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
                        ) */
                    ),
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
            Get.to(() => ReasurantMenuScreen(
                resID: res.id,
                name: res.resName,
                address: res.resArea,
                fetchapi: true,
                km: res.distance));
          }
        } catch (e) {
          print("in");
        }
      },
      child: Container(
          padding: EdgeInsets.only(right: 25.w),
          child: Column(children: [
            Container(
                height: 175.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                    color: const Color.fromARGB(255, 211, 204, 204),
                    image: DecorationImage(
                      image: NetworkImage(res.url),
                      fit: BoxFit.fill,
                    ))),
            Container(
                margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText(res.resName,
                                color: const Color(0xff111c26),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 17.sp),
                            GlobalText(res.resArea,
                                color: const Color(0xff888e94),
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.sp),
                          ],
                        ),
                      ),
                      GlobalText("${res.distance}Km",
                          color: const Color(0xff888e94),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 11.sp)
                    ]))
          ])),
    );
  }

  Widget swiperItem(BuildContext context, Restaurant res) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
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
            Get.to(() => ReasurantMenuScreen(
                resID: res.id,
                name: res.resName,
                address: res.resArea,
                fetchapi: true,
                km: res.distance));
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
                      /*  gradient: const LinearGradient(
                          colors: [Color(0xfffe7500), Color(0xffe41b00)],
                          stops: [0, 1],
                          begin: Alignment(-1.00, 0.00),
                          end: Alignment(1.00, -0.00),
                          // angle: 90,
                          // scale: undefined,
                        ) */
                    ),
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
                  Get.to(() => ReasurantMenuScreen(
                      resID: res.id,
                      name: res.resName,
                      address: res.resArea,
                      fetchapi: true,
                      km: res.distance));
                },
                child: Container(
                    height: 45.h,
                    width: 100.w,
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
                        ) */
                    ),
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
            Get.to(() => ReasurantMenuScreen(
                resID: res.id,
                name: res.resName,
                address: res.resArea,
                fetchapi: true,
                km: res.distance));
          }
        } catch (e) {
          print("in");
        }
      },
      child: Container(
          height: 190.h,
          // width: 10,
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.r),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x24000000),
                    offset: Offset(0, 5),
                    blurRadius: 13,
                    spreadRadius: 0)
              ],
              color: const Color(0xffffffff)),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9.r),
                    topRight: Radius.circular(9.r)),
                child: Image.network(
                  res.url,
                  fit: BoxFit.fill,
                  height: 121.h,
                  //width: 10,
                ),
              ),
              Container(
                  height: 69.h,
                  // width: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9.r),
                        bottomRight: Radius.circular(9.r)),
                    color: Color(0xffEDCC40),
                    /* gradient: const LinearGradient(
                          colors: [Color(0xfff32934), Color(0xfffcc43e)],
                          stops: [0, 1],
                          begin: Alignment(-1.00, -0.02),
                          end: Alignment(1.00, 0.02)) */
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GlobalText(
                                    res.resName
                                        .substring(0, res.resName.length - 5),
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.sp),
                                GlobalText(res.resArea,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 9.sp)
                              ]),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GlobalText(res.distance,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 8.sp),
                              SizedBox(width: 4.w),
                              GlobalText("KM\nAWAY",
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 8.sp)
                            ])
                      ]))
            ],
          )),
    );
  }

  Widget bottomBarItem(int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (controller.selectedIndex.value == index) {
          return;
        }
        controller.selectedIndex.value = index;
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset(
            index == 0
                ? "assets/images/home.svg"
                : index == 1
                    ? "assets/images/search.svg"
                    : index == 2
                        ? "assets/images/cart.svg"
                        : "assets/images/profile.svg",
            width: 27.w,
            height: 28.h,
            color: controller.selectedIndex.value == index
                ? const Color(0xffEDCC40)
                : Colors.black),
        SizedBox(height: 6.h),
        GlobalText(
            index == 0
                ? "Home"
                : index == 1
                    ? "Search"
                    : index == 2
                        ? "My Bag"
                        : "Profile",
            color: controller.selectedIndex.value == index
                ? const Color(0xffEDCC40)
                : const Color(0xff131b26),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal)
      ]),
    );
  }

  Widget searchPage() {
    return ListView(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
              height: 52.h,
              margin: EdgeInsets.only(top: 53.h, left: 25.w, right: 25.w),
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x23000000),
                      offset: Offset(0, 5),
                      blurRadius: 13,
                      spreadRadius: 0)
                ],
              ),
              child: Row(children: [
                SizedBox(width: 15.w),
                SvgPicture.asset("assets/images/searchRed.svg"),
                SizedBox(width: 5.w),
                Expanded(
                  child: TextFormField(
                    autofocus: false,
                    onTap: () => Get.to(SearchLocationScreen()),
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w500,
                        fontFamily: "Future PT",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.sp,
                        color: Colors.black),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      hintStyle: TextStyle(
                          fontFeatures: const [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.w400,
                          fontFamily: "Future PT",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.sp,
                          color: const Color(0xff8e9598)),
                      hintText: "Search for restaurant ",
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ])),
          Container(
              margin: EdgeInsets.only(top: 22.h, bottom: 14.h, left: 25.w),
              child: GlobalText("NEAR BY",
                  color: const Color(0xff111c26),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 17.sp)),
          Container(
              margin: EdgeInsets.only(left: 25.w),
              height: 280.h,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return commonSwiperItem(controller.res.res[index]);
                },
                layout: SwiperLayout.DEFAULT,
                itemCount: controller.res.res.length,
                viewportFraction: 0.8,
                indicatorLayout: PageIndicatorLayout.COLOR,
              )),
          Container(
              margin: EdgeInsets.only(top: 34.h, bottom: 20.h, left: 25.w),
              child: GlobalText("FEATURED RESTAURANTS",
                  color: const Color(0xff111c26),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 17.sp)),
          ListView.builder(
            itemCount: controller.res.res.length,
            itemBuilder: (context, index) => Column(children: [
              Container(
                  height: 132.h,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 16.w, top: 15.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(controller.res.res[index].url),
                          fit: BoxFit.fill),
                      color: const Color(0xff000000),
                      borderRadius: BorderRadius.circular(5.r)),
                  child: SvgPicture.asset(index.isEven
                      ? "assets/images/heart.svg"
                      : "assets/images/heartEmpty.svg")),
              Container(
                  margin: EdgeInsets.only(top: 5.h, bottom: 21.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GlobalText(controller.res.res[index].resName,
                                    color: const Color(0xff111c26),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 19.sp),
                                GlobalText(controller.res.res[index].resArea,
                                    color: const Color(0xff888e94),
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.sp)
                              ]),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              index.isEven
                                  ? Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/star.svg"),
                                        GlobalText("3.5",
                                            color: const Color(0xff111c26),
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.sp),
                                      ],
                                    )
                                  : const SizedBox(),
                              GlobalText(
                                  "${controller.res.res[index].distance}Km",
                                  color: const Color(0xff888e94),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.sp)
                            ])
                      ]))
            ]),
            padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 5.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          )
        ]);
  }

  Widget shopPage() {
    return Column(children: [
      appBar("Empty Cart", false, () => controller.selectedIndex.value = 0),
      Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset("assets/images/cartIcon.svg"),
        SizedBox(height: 25.h),
        GlobalText("Your Cart is Empty",
            color: const Color(0xff111c26),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 25.sp),
        SizedBox(height: 11.h),
        GlobalText(
            "Good Food is Always Cooking.!\nGo ahead, Order some Yummy Items the Menu Food",
            color: const Color(0xff888e94),
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            fontStyle: FontStyle.normal,
            fontSize: 16.sp),
        SizedBox(height: 26.h),
        Container(
            height: 59.h,
            margin: EdgeInsets.symmetric(horizontal: 37.w),
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
                ) */
            ),
            alignment: Alignment.center,
            child: GlobalText("Back to Shopping",
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 18.sp))
      ]))
    ]);
  }
}
