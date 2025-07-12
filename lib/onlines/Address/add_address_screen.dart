import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import '../Checkout/checkout_screen.dart';
import 'address_controller.dart';
import 'package:Bossa/util/global_text.dart';

import 'address_list.dart';

class AddAddressScreen extends GetView<AddressController> {
  @override
  final controller = Get.put(AddressController());
final List? result;
int index;final String dn;
final bool c;
  AddAddressScreen({Key? key,required this.result,required this.index,required this.c,required this.dn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try{
     controller.name.text=result![index]["nickname"]??"";
     controller.address.text=result![index]["address"]??"";
     controller.flat.text=result![index]["apart"]??"";
     controller.road.text=result![index]["road"]??"";
     controller.business.text=result![index]["business"]??"";
     controller.area.text=result![index]["area"]??"";
     controller.postalCode.text=result![index]["postal_code"]??"";}catch(e){
        controller.name.text="";
     controller.address.text="";
     controller.flat.text="";
     controller.road.text="";
     controller.business.text="";
     controller.area.text="";
     controller.postalCode.text="";
     }
   
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff2f6f9),
        appBar: MainAppBar("Delivery Address", false, () => Get.back()),
        body: SafeArea(
                bottom: false,
                child: SizedBox(
                  child: controller.loadAddress.value
                      ? Center(child: CommonMethods().loader())
                      : SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(height: 50.h),
                            Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffffffff)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 19.h,
                                              left: 24.w,
                                              bottom: 23.h),
                                          child: GlobalText("Address",
                                              color: const Color(0xff111c26),
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20.sp)),
                                               commonEditText(
                                          controller.name,
                                          "Enter name",
                                          "",
                                          true),
                                      SizedBox(height: 28.h),
                                      commonEditText(
                                          controller.address,
                                          "Enter Address",
                                          "New York, New York, United States",
                                          true),
                                      SizedBox(height: 28.h),
                                      commonEditText(
                                          controller.flat,
                                          "Apart, Flat ( or ) Floor Number ( Required ) ",
                                          "",
                                          true),
                                      SizedBox(height: 28.h),
                                      commonEditText(controller.road,
                                          "Road name", "", true),
                                      SizedBox(height: 28.h),
                                      commonEditText(
                                          controller.business,
                                          "Business ( Or ) Building Name*",
                                          "",
                                          true),
                                      SizedBox(height: 28.h),
                                      commonEditText(controller.area,
                                          "Area / District*", "", true),
                                      SizedBox(height: 28.h),
                                      commonEditText(controller.postalCode,
                                          "Postal code", "", true),
                                      SizedBox(height: 28.h)
                                    ])),
                            // const Spacer(flex: 2),
                            result!.isEmpty?Container(): Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () async {
                                 Map res=await Api().deleteaddr(result![index]["id"]);
                                 if(res["status"]=="success"){
                                  Fluttertoast.showToast(
        msg: "Successfully Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
    if(c==true){
        Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => CheckOutScreen(dn:dn),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    }else{
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddressList(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));}
                                 }else{
                                                               Fluttertoast.showToast(
        msg: "Unable to delete",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
                                 }
                                },
                                child: Container(
                                    height: 59.h,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 37.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.r),
                                       
                                          // angle: 90,
                                          // scale: undefined,
                                        ),
                                    alignment: Alignment.center,
                                    child: controller.isloading.value
                                        ? CommonMethods().loader(white: true)
                                        : GlobalText("DELETE ADDRESS",
                                            color:  Colors.red,
                                            fontWeight: FontWeight.w900,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20.sp)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!controller.isloading.value) {
                                  controller.isloading.value = true;
                                  controller.isloading.refresh();
                                  String id;
                                  try{
                                    id=result![index]["id"];
                                  }catch(e){
                                    id="0";
                                  }
                                  controller.validate(id,c,dn,context,);
                                }
                              },
                              child: Container(
                                  height: 59.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 37.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xfffe7500),
                                          Color(0xffe41b00)
                                        ],
                                        stops: [0, 1],
                                        begin: Alignment(-1.00, 0.00),
                                        end: Alignment(1.00, -0.00),
                                        // angle: 90,
                                        // scale: undefined,
                                      )),
                                  alignment: Alignment.center,
                                  child: controller.isloading.value
                                      ? CommonMethods().loader(white: true)
                                      : GlobalText("Save Address",
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w900,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20.sp)),
                            ),
                            //const Spacer(flex: 1),
                          ]),
                        ),
                ),
              )),
        );
     
  }

  Widget commonEditText(TextEditingController controller, String hintText,
      String defaultValue, bool showUnderline) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        textInputAction: TextInputAction.done,
        style: TextStyle(
            color: const Color(0xff141f29),
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 16.sp),
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        obscureText: false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          isDense: true,
          border: showUnderline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                )
              : InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 17.h),
          hintStyle: TextStyle(
              color: const Color(0xff888e94),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 16.sp),
          hintText: hintText,
        ),
      ),
    );
  }
}
