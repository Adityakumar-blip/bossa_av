import 'package:flutter/material.dart';

abstract class AppStyles {
  static const white = Color(0xfff1f2f4);

  static const dark = Color.fromARGB(255, 252, 71, 0);
  static const light = Color.fromARGB(255, 252, 113, 0);

  static const lgColor = LinearGradient(
      colors: [dark, light],
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(0.5, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);
}
