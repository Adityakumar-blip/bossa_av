import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Bossa/onlines/Address/address_list.dart';
import 'package:Bossa/ui/my_profile.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/global_text.dart';

import 'add_address_screen.dart';
import 'address_controller.dart';

class AddressScreen extends GetView<AddressController> {
  //final controller = Get.put(AddressController());
  @override
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AddressController>(
        builder: ((cont) => WillPopScope(
          
          onWillPop: () {  
      //       Navigator.pushReplacement(
      // context,
      // PageRouteBuilder(
      //   pageBuilder: (context, animation1, animation2) => MyProfile(),
      //   transitionDuration: Duration.zero,
      //   reverseTransitionDuration: Duration.zero,
      // ));
      return Future.value(true); },
          child: SafeArea(
                child: Column(children: [
                  appBar("My Address", false, () => Get.back()),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/address.svg"),
                          SizedBox(height: 25.h),
                          GlobalText(
                              cont.addr == null
                                  ? "Address not added"
                                  : "Address is set",
                              color: const Color(0xff111c26),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 22.sp),
                          SizedBox(height: 55.h),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                             //Get.to(() => AddAddressScreen());
                           cont.addr==null?Get.to(() => AddAddressScreen(result: [],index: 0,c:false,dn:"")):  Navigator.push(
              context,
              PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => AddressList(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
              ));
                            },
                            child: Container(
                                height: 59.h,
                                margin: EdgeInsets.symmetric(horizontal: 37.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                     color: Color(0xffEDCC40),
                                   /*  gradient: const LinearGradient(
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
                                child: GlobalText(
                                    cont.addr == null
                                        ? "Add Address"
                                        : "View Address",
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.sp)),
                          )
                        ]),
                  )
                ]),
              ),
        )),
      ),
    );
  }
}
