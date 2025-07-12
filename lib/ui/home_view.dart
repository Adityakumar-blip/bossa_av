import 'package:Bossa/model/advertisement_model.dart';
import 'package:Bossa/model/restaurants_model.dart';
import 'package:Bossa/model/specials_model.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/home_controller.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/global_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/api.dart';

class HomeView extends GetView<HomeController> {
  @override
  final controller = Get.put(HomeController());

  HomeView({super.key});

  Widget lineWidget() {
    return Container(
        width: 18.w,
        height: 6.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: const Color(0xffEDCC40),

          /* gradient: const LinearGradient(
                begin: Alignment(0, 0.5),
                end: Alignment(1, 0.5),
                colors: [
                  Color(0xfff47629),
                  Color(0xfff47629),
                  Color(0xfffbb042)
                ]) */
        ));
  }

  Widget circleWidget() {
    return Container(
        width: 6.w,
        height: 6.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: const Color(0xffEDCC40),

          /*  gradient: const LinearGradient(
                begin: Alignment(0, 0.5),
                end: Alignment(1, 0.5),
                colors: [
                  Color(0xfff47629),
                  Color(0xfff47629),
                  Color(0xfffbb042)
                ]) */
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
          body: Obx(() => NotificationListener<ScrollNotification>(
                onNotification: (x) {
                  return true;
                },
                child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                          height: 87.h,
                          width: 375.w,
                          decoration: const BoxDecoration(
                            color: Color(0xffEDCC40),
                            /* gradient: LinearGradient(
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
                          child: controller.viewAllClicked.value
                              ? Row(children: [
                                  SizedBox(width: 24.w),
                                  InkWell(
                                      onTap: () {
                                        controller.viewAllClicked.value = false;
                                      },
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      child: Image.asset(
                                          "assets/images/back.png",
                                          width: 24.w)),
                                  const Spacer(flex: 2),
                                  GlobalText("BOSSA REWARDS",
                                      color: Colors.white,
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 2.166666732788086),
                                  const Spacer(flex: 4),
                                ])
                              : GlobalText("BOSSA REWARDS",
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 2.166666732788086)),
                      controller.viewAllClicked.value
                          ? Center(
                              child: Container(
                                  width: 170.w,
                                  height: 23.h,
                                  margin:
                                      EdgeInsets.only(top: 12.h, bottom: 3.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xffEDCC40),
                                    /* gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffed2324),
                                          Color(0xfff47629),
                                          Color(0xfffbb042)
                                        ],
                                        stops: [0, 0.4679799973964691, 1],
                                        begin: Alignment(-1.00, 0.00),
                                        end: Alignment(1.00, -0.00),
                                      ) */
                                  ),
                                  alignment: Alignment.center,
                                  child: GlobalText("Restaurants Near You",
                                      color: const Color(0xffffffff),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.5292857284545899)),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  top: 12.h, left: 13.w, right: 12.w),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (!controller.specialSelected.value) {
                                          controller.specialSelected.value =
                                              true;
                                        }
                                      },
                                      child: Container(
                                          width: 170.w,
                                          height: 25.h,
                                          decoration: controller
                                                  .specialSelected.value
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color:
                                                      const Color(0xff000000),
                                                  /* gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xffed2324),
                                                      Color(0xfff47629),
                                                      Color(0xfffbb042)
                                                    ],
                                                    stops: [
                                                      0,
                                                      0.4679799973964691,
                                                      1
                                                    ],
                                                    begin:
                                                        Alignment(-1.00, 0.00),
                                                    end: Alignment(1.00, -0.00),
                                                  ) */
                                                )
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.r)),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff000000),
                                                      width: 1.w)),
                                          alignment: Alignment.center,
                                          child: GlobalText("Specials Near You",
                                              color: controller
                                                      .specialSelected.value
                                                  ? const Color(0xffffffff)
                                                  : const Color(0xff000000),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing:
                                                  0.5292857284545899)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (controller.specialSelected.value) {
                                          controller.specialSelected.value =
                                              false;
                                        }
                                      },
                                      child: Container(
                                          width: 170.w,
                                          height: 23.h,
                                          decoration: !controller
                                                  .specialSelected.value
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color:
                                                      const Color(0xff000000),
                                                  /*  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xffed2324),
                                                      Color(0xfff47629),
                                                      Color(0xfffbb042)
                                                    ],
                                                    stops: [
                                                      0,
                                                      0.4679799973964691,
                                                      1
                                                    ],
                                                    begin:
                                                        Alignment(-1.00, 0.00),
                                                    end: Alignment(1.00, -0.00),
                                                  ) */
                                                )
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.r)),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff000000),
                                                      width: 1.w)),
                                          alignment: Alignment.center,
                                          child: GlobalText(
                                              "Restaurants Near You",
                                              color: !controller
                                                      .specialSelected.value
                                                  ? const Color(0xffffffff)
                                                  : const Color(0xff000000),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing:
                                                  0.5292857284545899)),
                                    )
                                  ])),
                      controller.viewAllClicked.value
                          ? const SizedBox()
                          : (controller.specialSelected.value)
                              ? (controller.specialsLoading.value == false &&
                                      controller.specials != null &&
                                      controller.specials?.specials != null &&
                                      controller.specials!.specials.isNotEmpty)
                                  ? Container(
                                      height: 155.h,
                                      margin: EdgeInsets.only(
                                          left: 14.w, top: 10.h),
                                      child: Swiper(
                                        controller: SwiperController(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return swiperItem(controller
                                              .specials!.specials[index]);
                                        },
                                        viewportFraction: 0.8,
                                        itemCount: controller
                                                .specials?.specials.length ??
                                            0,
                                        indicatorLayout:
                                            PageIndicatorLayout.NONE,
                                        layout: SwiperLayout.DEFAULT,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 155.h,
                                      child: Container(
                                          height: 165.h,
                                          margin: EdgeInsets.only(right: 15.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              color: Colors.transparent,
                                              image: const DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      'assets/images/pmck_logo2.png'))),
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              height: 55.h,
                                              width: 314.w,
                                              padding: EdgeInsets.only(
                                                  left: 11.w, right: 11.w),
                                              decoration: BoxDecoration(
                                                color: const Color(0xccffffff),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(6.r),
                                                    topRight:
                                                        Radius.circular(6.r),
                                                    bottomLeft:
                                                        Radius.circular(12.r),
                                                    bottomRight:
                                                        Radius.circular(12.r)),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color(0x21000000),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 48,
                                                      spreadRadius: 0)
                                                ],
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 1.h),
                                                    GlobalText("Coming soon",
                                                        textAlign:
                                                            TextAlign.start,
                                                        color: const Color(
                                                            0xff333333),
                                                        fontSize: 11.sp,
                                                        sfProText: true,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        letterSpacing: 0.575),
                                                    SizedBox(height: 2.h),
                                                  ]))),
                                    )
                              : (controller.restuarantLoading.value == false &&
                                      controller.res != null)
                                  ? SizedBox(
                                      height: 155.h,
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification: (_) => true,
                                        child: ListView.builder(
                                          controller:
                                              controller.restaurantScroll,
                                          itemBuilder: (context, index) =>
                                              customListItem(true,
                                                  controller.res?.res[index]),
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(
                                              left: 14.w,
                                              top: 10.h,
                                              bottom: 10.h),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.res?.res.length,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 155.h,
                                      child: Container(
                                          height: 165.h,
                                          margin: EdgeInsets.only(right: 15.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              color: Colors.transparent,
                                              image: const DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      'assets/images/pmck_logo2.png'))),
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              height: 55.h,
                                              width: 314.w,
                                              padding: EdgeInsets.only(
                                                  left: 11.w, right: 11.w),
                                              decoration: BoxDecoration(
                                                color: const Color(0xccffffff),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(6.r),
                                                    topRight:
                                                        Radius.circular(6.r),
                                                    bottomLeft:
                                                        Radius.circular(12.r),
                                                    bottomRight:
                                                        Radius.circular(12.r)),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color(0x21000000),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 48,
                                                      spreadRadius: 0)
                                                ],
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 1.h),
                                                    GlobalText("Coming soon",
                                                        textAlign:
                                                            TextAlign.start,
                                                        color: const Color(
                                                            0xff333333),
                                                        fontSize: 11.sp,
                                                        sfProText: true,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        letterSpacing: 0.575),
                                                    SizedBox(height: 2.h),
                                                  ]))),
                                    ),
                      controller.viewAllClicked.value
                          ? const SizedBox()
                          : controller.specialSelected.value
                              ? SizedBox(height: 10.h)
                              : Center(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      controller.viewAllClicked.value = true;
                                    },
                                    child: Container(
                                        width: 88.w,
                                        height: 23.h,
                                        margin: EdgeInsets.only(
                                            bottom: 10.h, top: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: const Color(0xffEDCC40),
                                          /* gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffed2324),
                                                Color(0xfff47629),
                                                Color(0xfffbb042)
                                              ],
                                              stops: [0, 0.4899210035800934, 1],
                                              begin: Alignment(-1.00, 0.00),
                                              end: Alignment(1.00, -0.00),
                                              // angle: 90,
                                              // scale: undefined,
                                            ) */
                                        ),
                                        alignment: Alignment.center,
                                        child: GlobalText("View All",
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.sp)),
                                  ),
                                ),
                      controller.viewAllClicked.value
                          ? const SizedBox()
                          : (!controller.advertsLoading.value &&
                                  controller.adverts != null &&
                                  controller.adverts!.adverts.isNotEmpty)
                              ? customSlider(
                                  controller.adverts, controller.swiperIndex)
                              : loader(),
                      controller.viewAllClicked.value
                          ? const SizedBox()
                          : GridView.builder(
                              itemCount: 4,
                              padding: EdgeInsets.symmetric(
                                  vertical: 13.h, horizontal: 17.w),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.h,
                                mainAxisSpacing: 12.w,
                                childAspectRatio: (2 / 1),
                              ),
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.r),
                                      color: index == 0
                                          ? const Color(0xffEDCC40)
                                          : index == 1
                                              ? const Color(0xff756F6F)
                                              : index == 2
                                                  ? const Color(0xff000000)
                                                  : index == 3
                                                      ? const Color(0xffEDCC40)
                                                      : null,
                                    ),
                                    alignment: index == 0
                                        ? Alignment.topLeft
                                        : Alignment.center,
                                    child: displayButton(context)[index]);
                              },
                            ),
                      controller.viewAllClicked.value
                          ? customGlide(controller.res)
                          : const SizedBox()
                    ]),
              ))),
    );
  }

  List<Widget> displayButton(context) {
    return [
      onlineOrder(), proudPartners(), newPromotions(),
      qrScanner()
      //review(context)
    ];
  }

  Widget proudPartners() {
    return GestureDetector(
      onTap: () async {
        controller.gotTOProudPartners();
      },
      child: GlobalText("PROUD PARTNERS",
          color: const Color(0xffffffff),
          fontSize: 13.sp,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.9285714569091796),
    );
  }

  Widget newPromotions() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.NEWS,
          arguments: {'navId': NavConst.homeNav, 'res': null},
          id: NavConst.homeNav),
      child: Container(
        color: Colors
            .transparent, // Matches the implicit transparent background of proudPartners
        child: GlobalText(
          "BOSSA GOOD TIMES",
          color: const Color(0xffffffff), // Same white color as proudPartners
          fontSize: 13.sp,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.9285714569091796,
        ),
      ),
    );
  }

  Widget review(context) {
    return GestureDetector(
        onTap: () async {
          var res = await Api().getCustomerCare();
          print(res);
          var whatsappAndroid = Uri.parse(
              "whatsapp://send?phone=${res["data"]["whatsapp_number"]}&text=BOSSA REWARDS");
          if (await canLaunchUrl(whatsappAndroid)) {
            await launchUrl(whatsappAndroid);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("WhatsApp is not installed on the device"),
              ),
            );
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xff1bd741),
            border: Border.all(color: const Color(0xff1bd741), width: 10),
          ),
          child: Image.asset('assets/images/whatsapp_icon.png', scale: 2.5),
        ));
  }

  //Get.toNamed(Routes.ONLINEORDERMAIN)
  Widget onlineOrder() {
    return GestureDetector(
      onTap: () => {Get.toNamed(Routes.ONLINEORDERMAIN)},
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Center(
            child: GlobalText("ORDER ONLINE",
                color: Colors.black,
                fontSize: 13.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.9285714569091796),
          )
        ],
      ),
    );
  }

  //----QR scan widget---//
  Widget qrScanner() {
    return GestureDetector(
      onTap: () async {
        controller.scanQR();
      },
      child: GlobalText("SCAN TO PAY",
          color: const Color(0xffffffff),
          fontSize: 13.sp,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.9285714569091796),
    );
    // ElevatedButton(
    //     onPressed: () => scanQR(), child: const Text('Start QR scan'));
    // ElevatedButton(
    //   onPressed: () async {
    //     var res = await Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const SimpleBarcodeScannerPage(),
    //         ));

    //     if (res is String) {
    //       controller.updateResult(res);
    //     }
    //   },
    //   child: const Text('Open Scanner'),
    // );
  }

  Widget customListItem(bool addRightSpace, Restaurant? res) {
    if (res == null) {
      return loader();
    } else if (!addRightSpace) {
      return InkWell(
          onTap: () => Get.toNamed(Routes.ONLINEORDERMAIN),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: childCustomListItem(addRightSpace, res));
    } else {
      return childCustomListItem(addRightSpace, res);
    }
  }

  Widget childCustomListItem(bool addRightSpace, Restaurant? res) {
    return GestureDetector(
      onTap: (() => Get.toNamed(Routes.RESTAURANTDETAILS,
          arguments: {"id": res!.id, "navId": NavConst.homeNav},
          id: NavConst.homeNav)),
      child: Container(
          width: 149.w,
          height: 130.h,
          margin: EdgeInsets.only(right: addRightSpace ? 10.w : 0),
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
            res!.image != null
                ? res.image!
                : Image.network(
                    res.url,
                    fit: BoxFit.fill,
                    height: 80.h,
                  ),
            const Spacer(),
            Container(
                width: 160.w,
                height: 55.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: const Color(0xffEDCC40),

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
                padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 10.w),
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
    );
  }

  Widget customGlide(Restaurants? res) {
    return res == null
        ? loader()
        : GridView.builder(
            itemCount: res.res.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 20.h,
                childAspectRatio: 0.9),
            padding: EdgeInsets.symmetric(horizontal: 33.w),
            itemBuilder: (
              context,
              index,
            ) {
              return customListItem(false, res.res[index]);
            });
  }

//advert
  Widget customSlider(Adverts? adverts, Rx<int> swipeIndex) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            width: 375.w,
            height: 220.h,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: const BoxDecoration(
              color: Color(0xffEDCC40),

              /*  gradient: LinearGradient(
                colors: [
                  Color(0xffed2224),
                  Color(0xfff47529),
                  Color(0xfffbb042)
                ],
                stops: [0, 0.46935799717903137, 1],
                begin: Alignment(-1.00, 0.00),
                end: Alignment(1.00, -0.00),
                // angle: 90,
                // scale: undefined,
              ), */
            ),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return advertSlider(adverts?.adverts[index], context);
              },
              layout: SwiperLayout.DEFAULT,
              itemCount: controller.adverts?.adverts.length ?? 0,
              onIndexChanged: (index) => swipeIndex.value = index,
              indicatorLayout: PageIndicatorLayout.COLOR,
              autoplay: true,
            )),
        Container(
          margin: EdgeInsets.only(bottom: 13.h),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            controller.swiperIndex.value == 0 ? lineWidget() : circleWidget(),
            SizedBox(width: 3.w),
            controller.swiperIndex.value == 1 ? lineWidget() : circleWidget(),
            SizedBox(width: 3.w),
            controller.swiperIndex.value == 2 ? lineWidget() : circleWidget(),
            SizedBox(width: 3.w),
            controller.swiperIndex.value == 3 ? lineWidget() : circleWidget(),
          ]),
        )
      ],
    );
  }

  void _launchURL(url, BuildContext context) async {
    try {
      await launch(url);
    } catch (e) {
      CommonMethods().showFlushBar("Invalid URL request", context);
    }
  }

  Widget advertSlider(Advert? advert, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(advert?.link, context);
      },
      child: SizedBox(
        width: SizeConfig.screenWidth,
        child: advert?.advImage ??
            Image.network(
              advert?.image ?? "",
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return CommonMethods().loader(white: true);
                }
              },
            ),
      ),
    );
  }

//specials
  Widget swiperItem(Special special) {
    return GestureDetector(
      onTap: (() => Get.toNamed(Routes.NEWS,
          arguments: {"navId": NavConst.homeNav, "res": special.id},
          id: NavConst.homeNav)),
      child: Container(
          height: 155.h,
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.transparent,
              image: DecorationImage(
                image: special.specImage ?? NetworkImage(special.url),
                fit: BoxFit.fill,
              )),
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 76.h,
              width: 300.w,
              padding: EdgeInsets.only(left: 11.w, right: 11.w),
              decoration: BoxDecoration(
                color: const Color(0xccffffff),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.r),
                    topRight: Radius.circular(6.r),
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x21000000),
                      offset: Offset(0, 2),
                      blurRadius: 48,
                      spreadRadius: 0)
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    GlobalText(special.specialName,
                        textAlign: TextAlign.start,
                        color: const Color(0xff333333),
                        fontSize: 10.sp,
                        sfProText: true,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.575),
                    const Spacer(),
                    GlobalText(special.storename,
                        color: const Color(0xff989898),
                        fontSize: 9.sp,
                        sfProText: true,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.366428581237793),
                    GlobalText("${special.distance} km",
                        color: const Color(0xff989898),
                        fontSize: 7.sp,
                        sfProText: true,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.32571429443359373),
                    SizedBox(height: 2.h),
                  ]))),
    );
  }

  Widget loader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 375.w,
          height: 220.h,
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: const BoxDecoration(
            color: Color(0xffEDCC40),
            /*  gradient: LinearGradient(
              colors: [Color(0xffed2224), Color(0xfff47529), Color(0xfffbb042)],
              stops: [0, 0.46935799717903137, 1],
              begin: Alignment(-1.00, 0.00),
              end: Alignment(1.00, -0.00),
              // angle: 90,
              // scale: undefined,
            ), */
          ),
          child: CommonMethods().loader(white: true),
        )
      ],
    );
  }
}
