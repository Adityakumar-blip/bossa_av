import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/commonWidgets/textField.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';

import '../util/main_app_bar.dart';

// ignore: must_be_immutable
class NewPassword extends StatefulWidget {
  bool? isForgot;
  String? uuid;
  NewPassword({Key? key, this.uuid, this.isForgot}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
          widget.isForgot! ? "Forgot Password" : "Change Password",
          false,
          null),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical * 6,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "New Password*",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2.6,
                        fontFamily: 'Muli-SemiBold'),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              CommonTextField(
                hintText: "Password",
                controller: newPassword,
                obscureText: true,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Confirm Password*",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2.6,
                        fontFamily: 'Muli-SemiBold'),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              CommonTextField(
                hintText: "Password",
                controller: confirmPassword,
                obscureText: true,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Center(
                  child: loading
                      ? CommonMethods().loader()
                      : CustomButton(
                          text: "CHANGE PASSWORD",
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });

                            if (newPassword.text == confirmPassword.text) {
                              changePasswordApi();
                            } else {
                              setState(() {
                                loading = false;
                              });
                              CommonMethods().showFlushBar(
                                  "Password doesn't match", context);
                            }
                          },
                        )),
            ],
          ),
        ),
      ),
    );
  }

  changePasswordApi() async {
    Map<String, dynamic> body = {
      "action": "CHANGE_PASSWORD",
      "uuid": widget.uuid,
      "password": newPassword.text
    };

    print("body of change password $body");
    var res = await Api.changePassword(body);
    Map map = jsonDecode(res);
    print(map);

    if (map['status'] == "success") {
      setState(() {
        loading = false;
      });

      if (widget.isForgot!) {
        Get.toNamed(Routes.LOGIN);
      } else {
        Get.toNamed(Routes.PROFILE, id: NavConst.profile);
      }
    } else {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(map['message'], context);
    }
  }
}
