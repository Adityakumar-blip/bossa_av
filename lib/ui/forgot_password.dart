import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/enter_code.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  bool isForgot = false;
  String? emailID;
  var navId;
  @override
  Key? key;
  ForgotPassword({Key? key, data}) : super(key: key) {
    isForgot = data["isForget"];
    emailID = data["emailID"];
    if (!isForgot) {
      navId = data['navId'];
    }
  }
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailPhone = TextEditingController();
  String selectedCountryCode = '+27'; // Default to South Africa
  final List<Map<String, String>> countryCodes = [
    {'name': 'South Africa', 'code': '+27'},
    {'name': 'Namibia', 'code': '+264'},
  ];
  bool loading = false;
  ScrollController scollBarController = ScrollController();

  @override
  void initState() {
    emailPhone.text = widget.emailID ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            widget.isForgot ? "Forgot Password" : "Change Password",
            false,
            widget.isForgot
                ? null
                : () => widget.navId == null
                    ? Get.back()
                    : Get.back(id: widget.navId)),
        body: SafeArea(
          bottom: false,
          child: Container(
            height: SizeConfig.screenHeight * 0.85,
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Enter your Phone Number below & we'll send you a verification code to change your password",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xff0E0B20),
                        height: SizeConfig.blockSizeVertical * 0.29,
                        fontFamily: 'Muli-SemiBold',
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Phone Number*",
                          style: TextStyle(
                              color: const Color(0xff0E0B20),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              fontFamily: 'Muli-SemiBold'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    // Combined Country Code and Phone Number Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                        children: [
                          // Country Code Dropdown
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedCountryCode,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xff0E0B20),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Muli-SemiBold',
                                  color: Color(0xff0E0B20),
                                  fontSize: 16,
                                ),
                                items: countryCodes.map((country) {
                                  return DropdownMenuItem<String>(
                                    value: country['code'],
                                    child: Text(
                                      '${country['code']}',
                                      style: const TextStyle(
                                        fontFamily: 'Muli-SemiBold',
                                        color: Color(0xff0E0B20),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCountryCode = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          // Divider
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          // Phone Number Input
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: emailPhone,
                              style: const TextStyle(
                                  fontFamily: 'Muli-SemiBold',
                                  color: Color(0xff0E0B20)),
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontFamily: 'Muli-Light',
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.5,
                                    color: const Color(0xff0E0B20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    Center(
                      child: loading
                          ? CommonMethods().loader()
                          : CustomButton(
                              width: 200,
                              text: "SEND",
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (emailPhone.text.isEmpty) {
                                  setState(() {
                                    loading = false;
                                  });
                                  CommonMethods().showFlushBar(
                                      "Please fill the required fields",
                                      context);
                                } else {
                                  try {
                                    // Generate a UUID for the request
                                    String uuid = const Uuid().v4();
                                    var res = await Api.forgotPassword(
                                      emailPhone.text,
                                      selectedCountryCode.replaceAll('+', ''),
                                      uuid,
                                    );

                                    print(res);
                                    Map valueMap = jsonDecode(res);

                                    switch (valueMap['status']) {
                                      case "success":
                                        setState(() {
                                          loading = false;
                                        });
                                        Get.to(() => EnterCode(
                                              code: valueMap['code'],
                                              uuid: valueMap['uuid'],
                                              isForgot: widget.isForgot,
                                              email: emailPhone.text,
                                              countryCode: selectedCountryCode
                                                  .replaceAll('+', ''),
                                            ));
                                        break;
                                      case "failed":
                                        setState(() {
                                          loading = false;
                                        });
                                        CommonMethods().showFlushBar(
                                            valueMap['message'] ??
                                                "Your phone number doesn't exist",
                                            context);
                                        break;
                                      default:
                                        setState(() {
                                          loading = false;
                                        });
                                        CommonMethods().showFlushBar(
                                            "Something went wrong", context);
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
                                }
                              }),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    widget.isForgot
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3.3,
                                      color: const Color(0xff0E0B20),
                                      height:
                                          SizeConfig.blockSizeVertical * 0.18,
                                      fontFamily: 'Muli-Bold'),
                                  children: const <TextSpan>[
                                    TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                          color: Color(0xffEDCC40),
                                          decoration: TextDecoration.underline,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 20,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
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
