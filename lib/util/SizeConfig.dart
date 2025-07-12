import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  static double screenWidth = ScreenUtil().screenWidth;
  static double screenHeight = ScreenUtil().screenHeight;
  static double blockSizeHorizontal = screenWidth / 100;
  static double blockSizeVertical = screenHeight / 100;
  static bool isDeviceLarge = (screenHeight >= 750);
  static bool isDeviceExtraLarge = (screenHeight >= 800);
}
