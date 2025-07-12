import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Bossa/model/addons_model.dart';
import 'package:Bossa/model/bag_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/global_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../My_Bag/my_bag_controller.dart';
import 'reasurant_menu_controller.dart';

// ignore: must_be_immutable
class ReasurantMenuScreen extends GetView<ReasurantMenuController> {
  int? resID;
  bool? fetchapi;
  String? name, km, address;
  RxInt? total3 = 0.obs;
  Rx<AddOnsModel> add = AddOnsModel().obs;
  @override
  final controller = Get.put(
    ReasurantMenuController(),
  );

  ReasurantMenuScreen(
      {Key? key, this.resID, this.name, this.km, this.address, this.fetchapi})
      : super(key: key) {
    if (resID != null) {
      controller.setRes(resID!);
      controller.getCategorylist(resID.toString());
    }
  }

  Widget radioItem(RxInt index, int item, String title, String price) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GlobalText(title,
          color: const Color(0xff111c26),
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 13.sp),
      Row(children: [
        GlobalText(price,
            color: const Color(0xff111c26),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 13.sp),
        SizedBox(width: 10.6.w),
        InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (index.value == item) {
                return;
              }

              index.value = item;
            },
            child: Obx(() => Icon(
                index.value == item
                    ? CupertinoIcons.smallcircle_fill_circle
                    : CupertinoIcons.circle,
                color: index.value == item
                    ? const Color(0xffe41b00)
                    : const Color(0xff7d90aa))))
      ])
    ]);
  }

  // RxList menu = [
  //   {"name": "Promotions", "index": 4, "value": true.obs},
  //   {"name": "Breakfast", "index": 0, "value": false.obs},
  //   {"name": "Starter", "index": 5, "value": false.obs},
  //   {"name": "Lunch", "index": 1, "value": false.obs},
  //   {"name": "Dinner", "index": 2, "value": false.obs},
  //   {"name": "Dessert", "index": 3, "value": false.obs}
  // ].obs;
  RxInt? ind = 0.obs;
  showDialogIfFirstLoaded(BuildContext context) async {
    Api api = Api();
    Map data = await api.getpopup(resID);
    if (data["data"].length >= 1) {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      print(formattedDate);

      String time = now.hour.toString() +
          ":" +
          now.minute.toString() +
          ":" +
          now.second.toString();
      for (int i = 0; i < data["data"].length; i++) {
        if (data["data"][i]["date"] == formattedDate &&
            data["data"][i]["time"] == null) {
          showGeneralDialog(
            context: context,
            barrierLabel: "Barrier",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) {
              return Center(
                child: Wrap(
                  children: [
                    Center(
                      child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                    // splashColor: Colors
                                    //     .transparent,
                                    // highlightColor: Colors
                                    //     .transparent,
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(Icons.close,
                                        color: Color(0xff000000), size: 30)),
                              ),
                              SizedBox(height: 15),
                              Image.network(data["data"][0]["logo"],
                                  fit: BoxFit.contain, loadingBuilder:
                                      (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xfff47629),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: 15),
                            ],
                          )),
                    ),
                  ],
                ),
              );
            },
            transitionBuilder: (_, anim, __, child) {
              Tween<Offset> tween;
              if (anim.status == AnimationStatus.reverse) {
                tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
              } else {
                tween = Tween(begin: Offset(1, 0), end: Offset.zero);
              }

              return SlideTransition(
                position: tween.animate(anim),
                child: FadeTransition(
                  opacity: anim,
                  child: child,
                ),
              );
            },
          );
        } else if (data["data"][i]["date"] == formattedDate &&
            data["data"][i]["time"] == time) {
          showGeneralDialog(
            context: context,
            barrierLabel: "Barrier",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) {
              return Center(
                child: Container(
                    height: 240,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              // splashColor: Colors
                              //     .transparent,
                              // highlightColor: Colors
                              //     .transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close,
                                  color: Color(0xff000000), size: 30)),
                        ),
                        SizedBox(height: 15),
                        Image.network(data["data"][0]["logo"],
                            fit: BoxFit.contain, loadingBuilder:
                                (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xfff47629),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 15),
                      ],
                    )),
              );
            },
            transitionBuilder: (_, anim, __, child) {
              Tween<Offset> tween;
              if (anim.status == AnimationStatus.reverse) {
                tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
              } else {
                tween = Tween(begin: Offset(1, 0), end: Offset.zero);
              }

              return SlideTransition(
                position: tween.animate(anim),
                child: FadeTransition(
                  opacity: anim,
                  child: child,
                ),
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fetchapi == true) {
      Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));
      fetchapi = false;
    }
    return GetBuilder<ReasurantMenuController>(
        init: controller,
        builder: ((_) => Scaffold(
              floatingActionButton: controller.rest.value.whatsapp == ''
                  ? Container()
                  : GestureDetector(
                      onTap: () async {
                        var whatsapp = controller.rest.value.whatsapp;
                        var whatsappAndroid = Uri.parse(
                            "whatsapp://send?phone=$whatsapp&text=BOSSA REWARDS");
                        var whatsappios = Uri.parse(
                            "https://wa.me/$whatsapp?text=BOSSA REWARDS");
                        if (Platform.isAndroid) {
                          if (await canLaunchUrl(whatsappAndroid)) {
                            await launchUrl(whatsappAndroid);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "WhatsApp is not installed on the device"),
                              ),
                            );
                          }
                        } else {
                          if (await canLaunchUrl(whatsappios)) {
                            await launchUrl(whatsappios);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "WhatsApp is not installed on the device"),
                              ),
                            );
                          }
                        }
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            height: 40.h,
                            margin: EdgeInsets.only(right: 15, bottom: 15),
                            width: 140.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xff1bd741),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.075,
                                  child: Image.asset(
                                      'assets/images/whatsapp_icon.png',
                                      scale: 2.5),
                                ),
                                SizedBox(width: 5),
                                GlobalText("Support",
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.sp),
                              ],
                            )),
                      ),
                    ),
              bottomNavigationBar: Wrap(
                children: [
                  Container(
                      height: 74.091.h,
                      padding: EdgeInsets.only(left: 45.w, right: 19.w),
                      decoration: const BoxDecoration(
                         color: Color(0xffEDCC40),
                       /*  gradient: LinearGradient(
                          colors: [Color(0xfff32934), Color(0xffffb401)],
                          stops: [0, 1],
                          begin: Alignment(-1.00, 0.00),
                          end: Alignment(1.00, -0.00),
                          // angle: 90,
                          // scale: undefined,
                        ), */
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x23000000),
                              offset: Offset(0, 5),
                              blurRadius: 13,
                              spreadRadius: 0)
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GlobalText(
                                      controller.cart.value.items != null
                                          ? "${controller.cart.value.items!.length} Items"
                                          : "0 Items",
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.sp),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      GlobalText(
                                          controller.cart.value.items != null
                                              ? "${controller.cart.value.subTotal.toStringAsFixed(2)} Items"
                                              : "",
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 13.sp),
                                      SizedBox(width: 4.w),
                                      GlobalText("Total",
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.sp),
                                    ],
                                  )
                                ]),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Get.toNamed(Routes.ONLINEMYBAG);
                              },
                              child: Row(children: [
                                GlobalText("View Cart",
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.sp),
                                Icon(Icons.arrow_right_sharp,
                                    color: const Color(0xffffffff), size: 30.h)
                              ]),
                            )
                          ])),
                ],
              ),
              body: SafeArea(
                child: Obx(
                  () => ListView(
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        appBar("", true, () {
                          Get.back();
                        }),
                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onTap: () => Get.back(),
                        //   child: Container(
                        //       padding: EdgeInsets.only(
                        //         top: 50.h,
                        //         left: 25.w,
                        //       ),
                        //       child: Row(children: [
                        //         Icon(
                        //           CupertinoIcons.chevron_back,
                        //           size: 25.h,
                        //         ),
                        //         SizedBox(width: 15.w),
                        //         GlobalText("Go Back",
                        //             color: const Color(0xff111c26),
                        //             fontWeight: FontWeight.w500,
                        //             fontStyle: FontStyle.normal,
                        //             fontSize: 15.sp)
                        //       ])),
                        // ),
                        Stack(alignment: Alignment.center, children: [
                          controller.rest.value.url == ""
                              ? Container(
                                  child: CommonMethods().loader(),
                                )
                              : Image.network(controller.rest.value.url,
                                  fit: BoxFit.fill, height: 255.h),
                        ]),

                        Container(
                            height: 3.h,
                            decoration: const BoxDecoration(
                               color: Color(0xffEDCC40),
                                /* gradient: LinearGradient(
                              colors: [Color(0xfff32a34), Color(0xffffb401)],
                              stops: [0, 1],
                              begin: Alignment(-1.00, 0.00),
                              end: Alignment(1.00, -0.00),
                              // angle: 90,
                              // scale: undefined,
                            ) */)),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: GlobalText(
                            name!,
                            color: Color(0xff111C26),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GlobalText(
                                address!,
                                color: Color(0xff888E94),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                              GlobalText("${km!} KM",
                                  color: Color(0xff888E94),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                            height: 35.h,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    controller.categoryListModel.data?.length ??
                                        0,
                                itemBuilder: (context, i) {
                                  return Obx(() => GestureDetector(
                                        onTap: () {
                                          if (i != ind!.value) {
                                            ind!.value = i;

                                            controller.updateOpen(controller
                                                    .categoryListModel
                                                    .data?[i]
                                                    .name
                                                    .toString() ??
                                                '');
                                          }
                                          print(ind);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 15,
                                                right: i == 5 ? 15 : 0),
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                     color: Color(0xffEDCC40),
                                                /* gradient: LinearGradient(
                                                  colors: [
                                                    ind == i
                                                        ? Color(0xfff32a34)
                                                        : Color(0xffCFCFCF),
                                                    ind == i
                                                        ? Color(0xffffb401)
                                                        : Color(0xffCFCFCF)
                                                  ],
                                                  stops: [0, 1],
                                                  begin: Alignment(-1.00, 0.00),
                                                  end: Alignment(1.00, -0.00),
                                                  // angle: 90,
                                                  // scale: undefined,
                                                ) */),
                                            child: Center(
                                                child: GlobalText(
                                              controller.categoryListModel
                                                      .data?[i].name
                                                      .toString() ??
                                                  '',
                                              fontSize: 15.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ))),
                                      ));
                                })),
                        // Container(
                        //     margin: EdgeInsets.only(
                        //         left: 24.w, top: 8.h, bottom: 8.h),
                        //     child: GlobalText("controller.rest.value.resName",
                        //         color: const Color(0xff111c26),
                        //         fontWeight: FontWeight.w700,
                        //         fontStyle: FontStyle.normal,
                        //         fontSize: 20.sp)),
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
                        //       SizedBox(width: 10.w),
                        //       // GlobalText("CHOOSE BY CATEGORY",
                        //       //     color: const Color(0xff111c26),
                        //       //     fontWeight: FontWeight.w700,
                        //       //     fontStyle: FontStyle.normal,
                        //       //     fontSize: 17.sp),
                        //       // SizedBox(width: 10.w),
                        //       Container(
                        //           width: 20.w,
                        //           height: 0.714.h,
                        //           decoration: BoxDecoration(
                        //               border: Border.all(
                        //                   color: const Color(0xffe72600),
                        //                   width: 2.w)))
                        //     ]),
                        // Container(
                        //   margin: EdgeInsets.symmetric(
                        //       vertical: 15.h, horizontal: 10.w),
                        //   child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         rowItem(
                        //             "assets/images/dish.png", "Promotions", 4),
                        //         rowItem("assets/images/cup.png", "Breakfast", 0),
                        //         rowItem("assets/images/lunch.png", "Lunch", 1),
                        //         rowItem("assets/images/pizza.png", "Dinner", 2),
                        //         rowItem(
                        //             "assets/images/dessert.png", "Dessert", 3),
                        //       ]),
                        // ),
                        Obx(() => controller.dishCategories.isEmpty
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: const Center(
                                  child: Text("Sorry no dishes available."),
                                ),
                              )
                            :
                            // ListView.builder(
                            //     itemBuilder: (context, index) => Column(
                            //       children: [
                            //         InkWell(
                            //           onTap: () {
                            //             print(index);
                            //             if (controller
                            //                 .dishCategories[index].isOpened) {
                            //               controller.dishCategories[index]
                            //                   .isOpened = false;
                            //               controller.dishCategories.refresh();
                            //               return;
                            //             }

                            //             for (var element
                            //                 in controller.dishCategories) {
                            //               element.isOpened = false;
                            //             }
                            //             controller.dishCategories[index]
                            //                 .isOpened = true;
                            //             controller.dishCategories.refresh();
                            //           },
                            //           splashColor: Colors.transparent,
                            //           highlightColor: Colors.transparent,
                            //           child: Container(
                            //               height: 61.h,
                            //               decoration: BoxDecoration(
                            //                 color: const Color(0xffffffff),
                            //                 borderRadius:
                            //                     BorderRadius.circular(5.r),
                            //                 boxShadow: const [
                            //                   BoxShadow(
                            //                       color: Color(0x13000000),
                            //                       offset: Offset(0, 0),
                            //                       blurRadius: 18,
                            //                       spreadRadius: 0)
                            //                 ],
                            //               ),
                            //               child: Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                 children: [
                            //                   Container(
                            //                     alignment: Alignment.center,
                            //                     padding:
                            //                         EdgeInsets.only(left: 20.w),
                            //                     child: Column(
                            //                       crossAxisAlignment:
                            //                           CrossAxisAlignment.start,
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment.center,
                            //                       children: [
                            //                         GlobalText(
                            //                             controller
                            //                                 .dishCategories[index]
                            //                                 .name,
                            //                             color: const Color(
                            //                                 0xff111c26),
                            //                             fontWeight:
                            //                                 FontWeight.w700,
                            //                             fontStyle:
                            //                                 FontStyle.normal,
                            //                             fontSize: 15.sp),
                            //                         SizedBox(
                            //                             height: controller
                            //                                         .dishCategories[
                            //                                             index]
                            //                                         .isOpened ==
                            //                                     false
                            //                                 ? 5.h
                            //                                 : 0),
                            //                         controller
                            //                                     .dishCategories[
                            //                                         index]
                            //                                     .isOpened ==
                            //                                 false
                            //                             ? GlobalText(
                            //                                 "${controller.dishCategories[index].items.length}  items",
                            //                                 color: const Color(
                            //                                     0xff888e94),
                            //                                 fontWeight:
                            //                                     FontWeight.w400,
                            //                                 fontStyle:
                            //                                     FontStyle.normal,
                            //                                 fontSize: 12.sp)
                            //                             : const SizedBox()
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     margin:
                            //                         EdgeInsets.only(right: 20.w),
                            //                     child: Icon(
                            //                         controller
                            //                                 .dishCategories[index]
                            //                                 .isOpened
                            //                             ? CupertinoIcons
                            //                                 .chevron_up
                            //                             : CupertinoIcons
                            //                                 .chevron_down,
                            //                         color: controller
                            //                                 .dishCategories[index]
                            //                                 .isOpened
                            //                             ? const Color(0xfffe7500)
                            //                             : Colors.black),
                            //                   )
                            //                 ],
                            //               )),
                            //         ),
                            //         SizedBox(
                            //             height: controller.dishCategories[index]
                            //                         .isOpened ==
                            //                     true
                            //                 ? 15.h
                            //                 : 0),
                            ListView.builder(
                                itemBuilder: (context, index2) {
                                  var category = controller.dishCategories[0];
                                  var bagItem = category.items[index2];
                                  var amount = 0.0.obs;
                                  amount.value = bagItem.price;
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(right: 20.w),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              var count = 1.obs;
                                              Api api = Api();
                                              add.value = await api.GetAddOns(
                                                  resID,
                                                  controller.dishCategories[0]
                                                      .items[index2].id);

                                              RxList a = [].obs;
                                              print(add.value.data);
                                              print(controller.dishCategories[0]
                                                  .items[index2].id);
                                              print(resID);
                                              if (controller.cart.value.items!
                                                  .isNotEmpty) {
                                                for (int i = 0;
                                                    i <
                                                        controller.cart.value
                                                            .items!.length;
                                                    i++) {
                                                  a.add(controller.cart.value
                                                      .items![i].itemId);
                                                  print(controller.cart.value
                                                      .items![i].itemId);
                                                }
                                                print(controller
                                                    .dishCategories[0]
                                                    .items[index2]
                                                    .id);
                                                if (a.contains(controller
                                                    .dishCategories[0]
                                                    .items[index2]
                                                    .id)) {
                                                  print("ok");
                                                  print(controller
                                                      .dishCategories[0]
                                                      .items[index2]
                                                      .id);
                                                  print(controller.cart.value
                                                      .items![0].qantity);
                                                  count.value = int.parse(
                                                      controller.cart.value
                                                          .items![0].qantity
                                                          .toString());
                                                  print("hii");
                                                  print(count.value);
                                                  // int a = int.parse(
                                                  //     controller
                                                  //         .cart
                                                  //         .value
                                                  //         .items![
                                                  //             index]
                                                  //         .qantity
                                                  //         .toString());
                                                  // double b = double
                                                  //     .parse(controller
                                                  //         .cart
                                                  //         .value
                                                  //         .items![
                                                  //             index]
                                                  //         .price
                                                  //         .toString());
                                                  // print(controller
                                                  //         .cart
                                                  //         .value
                                                  //         .items![
                                                  //             index]
                                                  //         .price
                                                  //         .toString());
                                                  amount.value = controller
                                                      .cart.value.subTotal;
                                                }
                                              }
                                              RxList<Map<int, int>> addons =
                                                  <Map<int, int>>[].obs;

                                              Get.bottomSheet(
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 32.h,
                                                        left: 11.3.w,
                                                        right: 19.w,
                                                        bottom: 10.h),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.7,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Image.network(controller.dishCategories[0].items[index2].picture),
                                                                              GlobalText(controller.dishCategories[0].items[index2].dishName, color: const Color(0xff111c26), fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 17.sp),
                                                                              SizedBox(height: 9.h),
                                                                              GlobalText(controller.dishCategories[0].items[index2].desc, color: const Color(0xff888e94), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 12.sp)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                            splashColor: Colors
                                                                                .transparent,
                                                                            highlightColor: Colors
                                                                                .transparent,
                                                                            onTap:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child: const Icon(Icons.close,
                                                                                color: Color(0xff000000),
                                                                                size: 30))
                                                                      ]),
                                                                  Container(
                                                                      height:
                                                                          1.053
                                                                              .h,
                                                                      margin: EdgeInsets.only(
                                                                          top: 20
                                                                              .h,
                                                                          bottom: 20
                                                                              .h),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: const Color(0xff979797).withOpacity(0.30000001192092896),
                                                                              width: 1.w))),
                                                                  add
                                                                          .value
                                                                          .data!
                                                                          .isNotEmpty
                                                                      ? GlobalText(
                                                                          "Add Ons",
                                                                          color: Color(
                                                                              0xff111C26),
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              15.sp)
                                                                      : Container(),
                                                                  //SizedBox(height:5.h),
                                                                  //  add.value.data!.isNotEmpty
                                                                  // ? GlobalText("Please Select any One Option",
                                                                  //     color: Color(0xff888E94),
                                                                  //     fontWeight: FontWeight.w400,
                                                                  //     fontSize: 12.sp)
                                                                  // : Container(),
                                                                  SizedBox(
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  ListView
                                                                      .builder(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              7,
                                                                              0,
                                                                              0),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: add
                                                                              .value
                                                                              .data!
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, index4) {
                                                                            return Column(
                                                                              children: [
                                                                                Container(
                                                                                  width: double.infinity,
                                                                                  color: const Color(0xff979797).withOpacity(0.30000001192092896),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w),
                                                                                    child: GlobalText(add.value.data![index4].nameOfAddon.toString(), color: const Color(0xff111c26), fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 15.sp),
                                                                                  ),
                                                                                ),
                                                                                ListView.builder(
                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                                                                  shrinkWrap: true,
                                                                                  itemCount: add.value.data![index4].addons!.length,
                                                                                  itemBuilder: (context, index3) {
                                                                                    if (a.contains(int.parse(add.value.data![index4].addons![index3].id.toString()))) {
                                                                                      add.value.data![index4].addons![index3].checked!.value = true;
                                                                                    }

                                                                                    return Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Obx(
                                                                                              () => Checkbox(
                                                                                                checkColor: Colors.white,
                                                                                                activeColor: Colors.red,
                                                                                                value: add.value.data![index4].addons![index3].checked!.value,
                                                                                                onChanged: (bool? value) {
                                                                                                  if (value == true) {
                                                                                                    // Uncheck all other checkboxes in the list
                                                                                                    for (var addon in add.value.data![index4].addons!) {
                                                                                                      addon.checked!.value = false;
                                                                                                    }

                                                                                                    // Check the current checkbox
                                                                                                    add.value.data![index4].addons![index3].checked!.value = true;

                                                                                                    // Update addons list with the current selection
                                                                                                    addons.clear();
                                                                                                    addons.add({index4: index3});
                                                                                                    // Update total and amount
                                                                                                    total3 = total3! + int.parse(add.value.data![index4].addons![index3].cost.toString());
                                                                                                    amount.value = total3 as double;
                                                                                                  } else {
                                                                                                    // Unselect the checkbox
                                                                                                    add.value.data![index4].addons![index3].checked!.value = false;

                                                                                                    // Remove the item from the addons list
                                                                                                    addons.removeWhere((item) => item[index4] == index3);

                                                                                                    // Remove the item from the bag if it exists
                                                                                                    final controller2 = Get.put(MyBagController());
                                                                                                    controller2.cart!.value.items!.removeWhere((item) => item.itemId == int.parse(add.value.data![index4].addons![index3].id.toString()));
                                                                                                    // Update total and amount
                                                                                                    total3 = 0 as RxInt?;
                                                                                                    amount.value = total3 as double;
                                                                                                  }
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: MediaQuery.of(context).size.width * 0.75,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w),
                                                                                                      child: GlobalText(add.value.data![index4].addons![index3].nameOfItem.toString(), color: const Color(0xff111c26), fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 15.sp),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w),
                                                                                                      child: GlobalText("R${double.parse(add.value.data![index4].addons![index3].cost!).toStringAsFixed(2)}", color: const Color(0xff111c26), fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 15.sp),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        // Divider or any other widget to separate each item
                                                                                        // You can add Divider(height: 1) here for example
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                )
                                                                              ],
                                                                            );
                                                                          }),
                                                                  SizedBox(
                                                                      height:
                                                                          30.h),
                                                                ]),
                                                          ),
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Obx(() =>
                                                                GlobalText(
                                                                  "R${amount.value.toStringAsFixed(2)}",
                                                                  fontSize:
                                                                      31.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ))),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Row(children: [
                                                            Container(
                                                                width:
                                                                    125.845.w,
                                                                height:
                                                                    62.131.h,
                                                                // ignore: sort_child_properties_last
                                                                child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child: InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () {
                                                                                if (count.value == 0) {
                                                                                  return;
                                                                                }

                                                                                if (count.value == 1) {
                                                                                  controller.removeFromCart(bagItem);
                                                                                  controller.removeCount(0);
                                                                                  count.value = 0;
                                                                                  amount.value = bagItem.price;
                                                                                  return;
                                                                                }
                                                                                count.value--;
                                                                                amount.value -= bagItem.price;
                                                                                //controller.updateCart(bagItem, count.value);
                                                                                controller.cart.refresh();
                                                                                controller.dishCategories.refresh();
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.remove,
                                                                                color: Color(0xff141f29),
                                                                              ))),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: Obx(() => GlobalText(
                                                                            "${count.value}",
                                                                            color:
                                                                                const Color(0xff141f29),
                                                                            fontWeight: FontWeight.w700,
                                                                            textAlign: TextAlign.center,
                                                                            fontStyle: FontStyle.normal,
                                                                            fontSize: 22.sp)),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child: InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () {
                                                                                count.value++;
                                                                                if (count.value == 1) {
                                                                                  amount.value == bagItem.price;
                                                                                } else if (count.value > 1) {
                                                                                  amount.value += bagItem.price;
                                                                                }
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.add,
                                                                                color: Color(0xff141f29),
                                                                              )))
                                                                    ]),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(6
                                                                            .r)),
                                                                    border: Border.all(
                                                                        color: const Color(
                                                                            0xff7d90aa),
                                                                        width: 2
                                                                            .w))),
                                                            SizedBox(
                                                                width: 10.5.w),
                                                            Expanded(
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  final cartController =
                                                                      Get.find<
                                                                          ReasurantMenuController>();

                                                                  if (cartController
                                                                      .cart
                                                                      .value
                                                                      .items!
                                                                      .isEmpty) {
                                                                    if (count.value >
                                                                            0 &&
                                                                        addons
                                                                            .isNotEmpty) {
                                                                      cartController.addToCart(
                                                                          bagItem,
                                                                          count
                                                                              .value,
                                                                          controller
                                                                              .resid);
                                                                    }

                                                                    if (addons
                                                                        .isEmpty) {
                                                                      Get.snackbar(
                                                                          'Alert',
                                                                          'Please select at least one addon to proceed.');
                                                                      print(
                                                                          '12===>');
                                                                      return; // Return here to prevent further execution
                                                                    }

                                                                    for (var addon
                                                                        in addons) {
                                                                      for (var kv
                                                                          in addon
                                                                              .entries) {
                                                                        final addonIndex =
                                                                            kv.key;
                                                                        final addonValue =
                                                                            kv.value;
                                                                        final addonCost = double.parse(add
                                                                            .value
                                                                            .data![addonIndex]
                                                                            .addons![addonValue]
                                                                            .cost
                                                                            .toString());
                                                                        final addonName = add
                                                                            .value
                                                                            .data![addonIndex]
                                                                            .addons![addonValue]
                                                                            .nameOfItem
                                                                            .toString();
                                                                        final addonId = int.parse(add
                                                                            .value
                                                                            .data![addonIndex]
                                                                            .addons![addonValue]
                                                                            .id
                                                                            .toString());

                                                                        cartController.addToCart2(
                                                                            bagItem,
                                                                            1,
                                                                            controller.resid,
                                                                            addonCost,
                                                                            addonName,
                                                                            addonId);
                                                                      }
                                                                    }

                                                                    Get.back();
                                                                  } else {
                                                                    if (addons
                                                                        .isEmpty) {
                                                                      Get.snackbar(
                                                                          'Alert',
                                                                          'Please select at least one addon to proceed.');
                                                                      print(
                                                                          '34===>');
                                                                      return; // Return here to prevent further execution
                                                                    }

                                                                    cartController.updateCart(
                                                                        bagItem,
                                                                        count
                                                                            .value);

                                                                    for (var addon
                                                                        in addons) {
                                                                      for (var kv
                                                                          in addon
                                                                              .entries) {
                                                                        final addonIndex =
                                                                            kv.key;
                                                                        final addonValue =
                                                                            kv.value;
                                                                        final addonCost = double.parse(add
                                                                            .value
                                                                            .data![addonIndex]
                                                                            .addons![addonValue]
                                                                            .cost
                                                                            .toString());
                                                                        final addonName = add
                                                                            .value
                                                                            .data![addonIndex]
                                                                            .addons![addonValue]
                                                                            .nameOfItem
                                                                            .toString();
                                                                        final addonId = int.parse(add
                                                                            .value
                                                                            .data![addonIndex]
                                                                            .addons![addonValue]
                                                                            .id
                                                                            .toString());

                                                                        cartController.updateCart2(
                                                                            bagItem,
                                                                            1,
                                                                            controller.resid,
                                                                            addonCost,
                                                                            addonName,
                                                                            addonId);
                                                                      }
                                                                    }

                                                                    Get.back();
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      62.131.h,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.r),
                                                                             color: Color(0xffEDCC40),
                                                                   /*  gradient:
                                                                        const LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                            0xfffe7500),
                                                                        Color(
                                                                            0xffe41b00)
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
                                                                    ), */
                                                                  ),
                                                                  child:
                                                                      GlobalText(
                                                                    "ADD TO CART",
                                                                    color: const Color(
                                                                        0xffffffff),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  isDismissible: true,
                                                  enableDrag: false,
                                                  backgroundColor:
                                                      Colors.white);
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: 100.h,
                                                      width: 100.w,
                                                      margin: EdgeInsets.only(
                                                          left: 19.w,
                                                          top: 15.h,
                                                          bottom: 27.w),
                                                      child: Image.network(
                                                        controller
                                                            .dishCategories[0]
                                                            .items[index2]
                                                            .picture,
                                                        width: 100.w,
                                                        height: 100.h,
                                                        fit: BoxFit.fill,
                                                      )),
                                                  SizedBox(width: 10.w),
                                                  Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            // width: MediaQuery.of(
                                                            //             context)
                                                            //         .size
                                                            //         .width *
                                                            //     0.5,
                                                            child: GlobalText(
                                                                bagItem
                                                                    .dishName,
                                                                color: const Color(
                                                                    0xff111c26),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: GlobalText(
                                                                bagItem.desc,
                                                                color: const Color(
                                                                    0xff111c26),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize:
                                                                    10.sp),
                                                          ),
                                                          GlobalText(
                                                              "from R${bagItem.price.toStringAsFixed(2)}",
                                                              color: const Color(
                                                                  0xff111c26),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 14.sp)
                                                        ]),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Image.asset(
                                                      "assets/images/rrow.png")
                                                ]),
                                          )),
                                      Container(
                                          height: 3.h,
                                          decoration: const BoxDecoration(
                                             color: Color(0xffEDCC40),
                                            /*   gradient: LinearGradient(
                                            colors: [
                                              Color(0xfff32a34),
                                              Color(0xffffb401)
                                            ],
                                            stops: [0, 1],
                                            begin: Alignment(-1.00, 0.00),
                                            end: Alignment(1.00, -0.00),
                                            // angle: 90,
                                            // scale: undefined,
                                          ) */)),
                                    ],
                                  );
                                },
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    controller.dishCategories[0].items.length)),
                        SizedBox(height: 17.h)
                      ]),
                ),
              ),
              // itemCount: controller.dishCategories.length,
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              // padding: EdgeInsets.only(
              //     bottom: 50.h, left: 32.w, right: 18.w),
            )));
  }

  Widget rowItem(String assetName, String name, int index) {
    return GestureDetector(
      onTap: () {
        // ignore: invalid_use_of_protected_member
        controller.updateOpen(name);
        //controller.dishCategories.refresh;
      },
      child: Column(children: [
        Image.asset(assetName, fit: BoxFit.fill, width: 65.w, height: 73.h),
        GlobalText(name,
            color: const Color(0xff131b26),
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 14.sp)
      ]),
    );
  }
}
