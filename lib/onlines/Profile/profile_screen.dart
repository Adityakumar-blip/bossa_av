import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Bossa/onlines/Address/address_controller.dart';
import 'package:Bossa/onlines/Address/address_screen.dart';
import 'package:Bossa/onlines/Order_Favourite/order_favourite_screen.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/global_text.dart';

import '../Order_History/order_history_screen.dart';
import '../Order_Main_Page/order_main_controller.dart';
import 'profile_controller.dart';

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

class ProfileScreen extends GetView<ProfileController> {
  @override
  final controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: ((cont) => SafeArea(
              child: Container(
                color: const Color(0xfff2f6f9),
                child: Stack(children: [
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                        height: 275.h,
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        )),
                  ),
                  ListView(
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        appBar("My Profile", false, () {
                          Get.find<OrderMainController>().selectedIndex.value =
                              0;
                        }),
                        SizedBox(height: 56.h),
                        Center(
                            child: Column(children: [
                          GlobalText(
                              controller.user.value.name +
                                  " " +
                                  controller.user.value.lastName,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 28.sp),
                          SizedBox(height: 3.h),
                          GlobalText(controller.user.value.email!,
                              color: const Color(0xff797f84),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.sp)
                        ])),
                        Container(
                            width: 364.w,
                            height: 247.h,
                            margin: EdgeInsets.symmetric(
                                horizontal: 25.w, vertical: 103.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x23000000),
                                    offset: Offset(0, 5),
                                    blurRadius: 13,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: Column(children: [
                              singleItem(
                                  "assets/images/foodIcon.svg", "My Orders",
                                  () {
                                Get.to(() => OrderHistoryScreen());
                              }),
                              singleItem("assets/images/heartIcon.svg",
                                  "My Favourites", () {
                                Get.to(() => OrderFavouriteScreen());
                              }),
                              singleItem(
                                  "assets/images/addressIcon.svg", "My Address",
                                  () {
                                Get.to(() => const AddressScreen(),
                                    binding: BindingsBuilder.put(
                                        () => AddressController()));
                              })
                            ]))
                      ])
                ]),
              ),
            )));
  }

  Widget singleItem(String svgPath, String name, Function tap) {
    return Expanded(
        flex: 1,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => tap(),
          child: Container(
              margin: EdgeInsets.only(left: 24.w, right: 15.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      SvgPicture.asset(svgPath),
                      SizedBox(width: 19.w),
                      GlobalText(name,
                          color: const Color(0xff111c26),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.sp)
                    ]),
                    Icon(CupertinoIcons.chevron_forward,
                        color: const Color(0xffd1d1d1), size: 22.h)
                  ])),
        ));
  }
}
