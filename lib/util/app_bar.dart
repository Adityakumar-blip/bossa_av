import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Bossa/util/global_text.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool showNotification;
  final Function onTap;

  const appBar(this.text, this.showNotification, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  onTap();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Icon(CupertinoIcons.chevron_back, size: 30.h)),
            GlobalText(text,
                color: const Color(0xff111c26),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 20.sp),
            showNotification
                ? SvgPicture.asset("assets/images/notificationIcon.svg",
                    width: 25.w, height: 25.h, fit: BoxFit.fill)
                : SizedBox(width: 20.w, height: 5.h)
          ]),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75.h);
}
