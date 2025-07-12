import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Bossa/ui/root_controller.dart';
import 'global_text.dart';

class BottomBar extends StatelessWidget {
  final RxInt selectedIndex;

  RootControler controller = Get.put(RootControler());

  BottomBar(this.selectedIndex, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          height: 60.h,
          margin:
              EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h, top: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x21000000),
                  offset: Offset(0, 2),
                  blurRadius: 48,
                  spreadRadius: 0)
            ],
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottomItem(0),
                bottomItem(1),
                SizedBox(width: 70.w),
                bottomItem(3),
                bottomItem(4)
              ])),
      InkWell(
          onTap: () async {
            if (selectedIndex.value == 2) {
              return;
            }
            await controller.onTapNav(2);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Image.asset("assets/images/bottomMenuLogo.png",
              fit: BoxFit.fill, height: 68.6123046875.h)),
    ]);
  }

  Widget bottomItem(int index) {
    return InkWell(
      onTap: () async {
        await controller.onTapNav(index);
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
            index == 0
                ? "assets/images/home.png"
                : index == 1
                    ? "assets/images/notification.png"
                    : index == 3
                        ? "assets/images/about.png"
                        : "assets/images/setting.png",
            fit: BoxFit.fill,
            width: 25.w,
            color: const Color(0xff000000)),
        SizedBox(height: 3.h),
        GlobalText(
            index == 0
                ? "Home"
                : index == 1
                    ? "Notifications"
                    : index == 3
                        ? "About"
                        : "Settings",
            color: selectedIndex.value == index
                ? const Color(0xffEDCC40)
                : const Color(0xff756F6F),
            fontSize: 8.sp,
            sfProText: true,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.8)
      ]),
    );
  }
}
