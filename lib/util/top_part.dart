import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Bossa/util/SizeConfig.dart';

class TopPart extends StatelessWidget {
  final String title;
  const TopPart({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 15.0),
                height: SizeConfig.blockSizeVertical *
                    (SizeConfig.isDeviceLarge ? 6 : 7),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Muli-Bold',
                    fontSize: 35.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
