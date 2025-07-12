import 'dart:convert';

import 'package:Bossa/network/api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/commonWidgets/textField.dart';
import 'package:Bossa/ui/new_password.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';

import '../util/main_app_bar.dart';

// ignore: must_be_immutable
class EnterCode extends StatefulWidget {
  bool? isForgot;
  var code;
  var uuid;
  String? email;
  String? countryCode; // Add country code parameter

  EnterCode(
      {Key? key,
      this.code,
      this.uuid,
      this.isForgot,
      this.email,
      this.countryCode})
      : super(key: key);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  TextEditingController enterCode = TextEditingController();
  String newCode = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    print("details of forgot password");
    print(widget.code);
    print(widget.uuid);

    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            widget.isForgot! ? "Forgot Password" : "Change Password",
            false,
            null),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Please enter the code you received via SMS",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.7,
                              color: const Color(0xff0E0B20),
                              height: SizeConfig.blockSizeVertical * 0.28,
                              fontFamily: 'Muli-Light'),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 5),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Enter Code*",
                              style: TextStyle(
                                  color: const Color(0xff0E0B20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 3.6,
                                  fontFamily: 'Muli-SemiBold'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 2,
                        ),
                        CommonTextField(
                          hintText: "Enter Code",
                          controller: enterCode,
                          obscureText: false,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Center(
                            child: CustomButton(
                          text: "NEXT",
                          onTap: () async {
                            if (widget.code == enterCode.text ||
                                newCode == enterCode.text) {
                              Get.to(() => NewPassword(
                                    uuid: widget.uuid,
                                    isForgot: widget.isForgot,
                                  ));
                            } else {
                              CommonMethods()
                                  .showFlushBar("Invalid code enter", context);
                            }
                          },
                        )),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 2.7,
                                color: const Color(0xff0E0B20),
                                height: SizeConfig.blockSizeVertical * 0.18,
                                fontFamily: 'Muli-Bold'),
                            children: <TextSpan>[
                              TextSpan(text: 'Didn\'t receive code? '),
                              TextSpan(
                                text: loading ? 'SENDING...' : 'SEND AGAIN',
                                style: TextStyle(
                                  color: Color(0xffEDCC40),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: loading
                                    ? null
                                    : (TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (loading) return;

                                        setState(() {
                                          loading = true;
                                        });

                                        try {
                                          // Generate a new UUID for the resend request
                                          String uuid = const Uuid().v4();

                                          var res = await Api.forgotPassword(
                                            widget.email.toString(),
                                            widget.countryCode ??
                                                '27', // Use stored country code or default
                                            uuid,
                                          );

                                          print(res);
                                          print(res.runtimeType);
                                          Map valueMap = jsonDecode(res);

                                          setState(() {
                                            loading = false;
                                          });

                                          switch (valueMap['status']) {
                                            case "success":
                                              // Update the code and uuid for verification
                                              setState(() {
                                                newCode = valueMap['code'];
                                              });

                                              // Update the widget's uuid for the new request
                                              widget.uuid = valueMap['uuid'];

                                              CommonMethods().showFlushBar(
                                                  "Code sent successfully!",
                                                  context);
                                              break;
                                            case "failed":
                                              CommonMethods().showFlushBar(
                                                  valueMap['message'] ??
                                                      "Your phone number doesn't exist",
                                                  context);
                                              break;
                                            default:
                                              CommonMethods().showFlushBar(
                                                  "Something went wrong",
                                                  context);
                                          }
                                        } catch (e) {
                                          setState(() {
                                            loading = false;
                                          });
                                          print("error: $e");
                                          CommonMethods().showFlushBar(
                                              "An error occurred. Please try again.",
                                              context);
                                        }
                                      }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
