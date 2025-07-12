import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/ui/root.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

// ignore: must_be_immutable
class CovidQuestions extends StatefulWidget {
  String? restaurantId;
  CovidQuestions({Key? key, this.restaurantId}) : super(key: key);
  @override
  _CovidQuestionsState createState() => _CovidQuestionsState();
}

class _CovidQuestionsState extends State<CovidQuestions> {
  late bool contact;
  late bool symptoms;
  TextEditingController tempData = TextEditingController();

  setCovidData(var ans1, var ans2, var ans3) async {
    var res = await Api.setCovidData(widget.restaurantId, ans1, ans2, ans3);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      Get.to(() => const ThankYou());
    } else {
      print("Value Map ---> $valueMap");
      print("Set Covid API Error...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          MainAppBar("Health QA", false, () => Get.back()),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.blockSizeVertical,
                  ),
                  Text(
                    "Health QA",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 5,
                        fontFamily: 'Muli-Bold'),
                  ),
                  const Text(
                    'To your knowledge have you been in contact with Health QA?',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            contact = true;
                          });
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  color: contact == true
                                      ? const Color(0xffEDCC40)
                                      : Colors.white,
                                  width: 5)),
                          child: const Center(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'Muli-Light',
                                  color: Color(0xff0E0B20)),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            contact = false;
                          });
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  color: contact == false
                                      ? const Color(0xffEDCC40)
                                      : Colors.white,
                                  width: 5)),
                          child: const Center(
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontFamily: 'Muli-Light',
                                  color: Color(0xff0E0B20)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  const Text(
                    'Do you display any symptoms?',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            symptoms = true;
                          });
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  color: symptoms == true
                                      ? const Color(0xffEDCC40)
                                      : Colors.white,
                                  width: 5)),
                          child: const Center(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'Muli-Light',
                                  color: Color(0xff0E0B20)),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            symptoms = false;
                          });
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  color: symptoms == false
                                      ? const Color(0xffEDCC40)
                                      : Colors.white,
                                  width: 5)),
                          child: const Center(
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontFamily: 'Muli-Light',
                                  color: Color(0xff0E0B20)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  const Text(
                    'What is your temperature?',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 1,
                  ),
                  TextFormField(
                    controller: tempData,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    // keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontFamily: 'Muli-SemiBold', color: Color(0xff0E0B20)),
                    decoration: InputDecoration(
                        hintText: 'Temperature',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
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
                            fontSize: SizeConfig.blockSizeVertical * 2.2,
                            color: const Color(0xff0E0B20))),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Center(
                    child: CustomButton(
                      text: "CONFIRM",
                      onTap: () {
                        if (tempData.text.isEmpty) {
                          CommonMethods()
                              .showFlushBar("Please fill all data.", context);
                        } else {
                          setCovidData(contact, symptoms, tempData.text);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThankYou extends StatefulWidget {
  const ThankYou({Key? key}) : super(key: key);

  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: SizeConfig.blockSizeVertical * 30,
                width: SizeConfig.blockSizeHorizontal * 70,
                child: Image.asset('assets/images/pmck_logo.png'),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical,
            ),
            Text(
              "Health QA",
              style: TextStyle(
                  color: const Color(0xff0E0B20),
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockSizeVertical * 5,
                  fontFamily: 'Muli-Bold'),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
            const Text(
              'Thank you for entering your information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 10,
            ),
            CustomButton(
              text: 'Return',
              onTap: () {
                Get.to(() => RootView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
