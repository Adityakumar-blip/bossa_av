import 'package:Bossa/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/color_gradient.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  Function onTap;
  String text;
  double? width;
  CustomButton(
      {Key? key, required this.onTap, required this.text, this.width = 200})
      : super(key: key);
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height:
            SizeConfig.blockSizeVertical * (SizeConfig.isDeviceLarge ? 5 : 10),
        width: widget.width ?? SizeConfig.blockSizeHorizontal * 25,
        decoration: BoxDecoration(
            color: Color(0xffEDCC40),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Center(
          child: Text(
            widget.text,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'Muli-Bold'),
          ),
        ),
      ),
    );
  }
}
