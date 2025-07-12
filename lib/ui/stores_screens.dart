import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/model/partners.dart';
import 'package:Bossa/ui/StoresController.dart';
import 'package:Bossa/ui/partnersWebView.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/app_bar.dart';
import 'package:Bossa/util/main_app_bar.dart';

class StoresScreen extends StatelessWidget {
  int navId = NavConst.homeNav;
  StoresScreen({Key? key, data}) : super(key: key) {
    if (data != null) {
      navId = data["navId"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar("Proud Partners", false, () => Get.back(id: navId)),
        body: GetBuilder<StoresController>(
          init: StoresController(),
          builder: (contr) {
            return contr.res.value.partners.isEmpty
                ? circleWid()
                : SizedBox(
                    height: SizeConfig.screenHeight,
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          "Support Our Loyal Partners and Earn Even More BOSSA REWARDS",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Muli-Bold',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      builderStores(contr.res.value)
                    ]));
          },
        ),
      ),
    );
  }

  Widget builderStores(Partners stores) {
    return Expanded(
      child: GridView.builder(
        itemCount: stores.partners.length,
        padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 17.w),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 20.w,
            childAspectRatio: 1.28),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(
                  () => PartnerswebView(newUrl: stores.partners[index].website));
            },
            child: Container(
                width: 181.w,
                height: 80.h,
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
                child: Center(
                  child: Image.network(
                    stores.partners[index].logo!,
                    fit: BoxFit.fill,
                    height: 80.h,
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget circleWid() {
    return const Center(
      child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
    );
  }
}
