import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bossa/util/SizeConfig.dart';

// ignore: must_be_immutable
class CommonTextField extends StatefulWidget {
  String? hintText;
  @override
  Key? key;
  TextEditingController? controller;
  Function? onChanged;
  bool? obscureText;
  bool? enabled;
  double fontSize;
  List<TextInputFormatter>? formatter;
  TextInputType? keyboardType;
  CommonTextField(
      {this.key,
      this.hintText,
      this.controller,
      this.onChanged,
      this.obscureText,
      this.enabled,
      this.fontSize = 3.0,
      this.formatter,
      this.keyboardType});

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        key: widget.key,
        controller: widget.controller!,
        obscureText: widget.obscureText!,
        enabled: widget.enabled,
        inputFormatters: widget.formatter ?? [],
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!();
          }
        },
        style: const TextStyle(
            fontFamily: 'Muli-SemiBold', color: Color(0xff0E0B20)),
        decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //border: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white),
            ),
            hintStyle: TextStyle(
                fontFamily: 'Muli-Light',
                fontSize: SizeConfig.blockSizeVertical * widget.fontSize,
                color: const Color(0xff0E0B20))),
      ),
    );
  }
}
