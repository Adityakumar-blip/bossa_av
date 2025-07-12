import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalText extends StatelessWidget {
  final String text;
  final Color? color;
  final bool? sfProText;
  final bool? rubikText;
  final double? fontSize, letterSpacing;
  final TextOverflow? textOverflow;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final double? height;
  final int? maxLine;

  const GlobalText(this.text,
      {Key? key,
      this.height,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.textDecoration,
      this.textOverflow,
      this.fontStyle = FontStyle.normal,
      this.letterSpacing,
      this.rubikText,
      this.sfProText,
      this.textAlign,
      this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: textOverflow,
        textAlign: textAlign,
        maxLines: maxLine,
        style: rubikText == true
            ? GoogleFonts.rubik(
                color: color,
                height: height,
                fontSize: fontSize,
                fontWeight: fontWeight,
                decoration: textDecoration,
                fontStyle: fontStyle,
                letterSpacing: letterSpacing)
            : TextStyle(
                fontFamily: sfProText == true ? "Sf-Pro-Text" : "Future PT",
                color: color,
                height: height,
                fontSize: fontSize,
                fontWeight: fontWeight,
                decoration: textDecoration,
                fontStyle: fontStyle,
                letterSpacing: letterSpacing));
  }
}
