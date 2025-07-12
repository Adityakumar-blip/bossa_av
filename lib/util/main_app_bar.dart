import 'package:Bossa/util/global_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool showNotification;
  final Function? onTap;

  const MainAppBar(this.text, this.showNotification, this.onTap, {super.key});

  Widget backButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      onTap == null
          ? Container()
          : InkWell(
              onTap: () {
                onTap!();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(CupertinoIcons.chevron_back, size: 30.h)),
      GlobalText(text,
          color: Colors.white,
          fontSize: 26.sp,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 2.166666732788086),
      showNotification
          ? SvgPicture.asset("assets/images/notificationIcon.svg",
              width: 25.w, height: 25.h, fit: BoxFit.fill)
          : SizedBox(width: 20.w, height: 5.h)
    ]);
  }

  Widget normalDisplay() {
    return GlobalText(text,
        color: Colors.white,
        fontSize: 26.sp,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        letterSpacing: 2.166666732788086);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75.h,
        width: 375.w,
        decoration: const BoxDecoration(
          color: Color(0xffEDCC40),
          /*  gradient: LinearGradient(
          colors: [Color(0xffed2024), Color(0xfff47729), Color(0xfffbb042)],
          stops: [0, 0.4827589988708496, 1],
          begin: Alignment(-1.00, 0.00),
          end: Alignment(1.00, -0.00),
          // angle: 90,
          // scale: undefined,
        ) */
        ),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 9.h),
        child: onTap == null ? normalDisplay() : backButton());
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(200);
}
