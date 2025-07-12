import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/commonWidgets/textField.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/ui/restaurants_page.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

// ignore: must_be_immutable
class ContactRestaurant extends StatefulWidget {
  String? name;
  String? location;
  var id;
  var image;
  var navId;
  ContactRestaurant({Key? key, data}) : super(key: key) {
    name = data[0];
    location = data[1];
    id = data[2];
    image = data[3];
    navId = data[4];
  }
  @override
  _ContactRestaurantState createState() => _ContactRestaurantState();
}

class _ContactRestaurantState extends State<ContactRestaurant> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  bool loading = false;

  InputDecoration customDecoration(String hintText) {
    return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(
          fontFamily: 'Muli-Light',
          fontSize: SizeConfig.blockSizeVertical * 2.2,
          color: const Color(0xff0E0B20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Display Notifications", false, () => Get.back(id: widget.navId)),
        body: SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          SizeConfig.blockSizeHorizontal * 6,
                          SizeConfig.blockSizeVertical * 4,
                          SizeConfig.blockSizeHorizontal * 6,
                          SizeConfig.blockSizeVertical * 4),
                      height: SizeConfig.blockSizeVertical * 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        color: Colors.white,
                      ),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(child: CommonMethods().loader());
                          }
                        },
                      ),
                    ),
                    Container(
                      // height: SizeConfig.blockSizeVertical*10,
                      margin: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 6,
                        right: SizeConfig.blockSizeHorizontal * 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name!,
                            style: TextStyle(
                              fontFamily: 'Muli-Bold',
                              fontSize: SizeConfig.blockSizeVertical * 4,
                              color: const Color(0xff0E0B20),
                            ),
                          ),
                          //SizedBox(height: 5.0,),
                          Text(
                            widget.location!,
                            style: TextStyle(
                                fontFamily: 'Muli-SemiBold',
                                fontSize: SizeConfig.blockSizeVertical * 2.2,
                                color: const Color.fromRGBO(14, 11, 32, 0.8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Please fill in the below information",
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Muli-Bold'),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    CommonTextField(
                      hintText: "Full Name",
                      controller: fullName,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    CommonTextField(
                      hintText: "Your Email",
                      controller: email,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    CommonTextField(
                      hintText: "Subject",
                      controller: subject,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: SizeConfig.screenHeight * 0.25,
                          ),
                          child: TextFormField(
                            minLines: 6,
                            maxLines: null,
                            controller: message,
                            style: const TextStyle(
                                fontFamily: 'Muli-SemiBold',
                                color: Color(0xff0E0B20)),
                            decoration: customDecoration('Message'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    loading
                        ? CommonMethods().loader()
                        : CustomButton(
                            text: 'SEND',
                            onTap: () {
                              setState(() {
                                loading = true;
                              });
                              if (fullName.text == "" ||
                                  email.text == "" ||
                                  subject.text == "" ||
                                  message.text == "") {
                                setState(() {
                                  loading = false;
                                });
                                CommonMethods().showFlushBar(
                                    "Please fill all the details.", context);
                              } else {
                                contactApi();
                              }
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  contactApi() async {
    Map<String, dynamic> body = {
      "action": "CONTACT_US",
      "fullname": fullName.text,
      "email": email.text,
      "subject": subject.text,
      "message": message.text
    };
    print("contact body $body");
    var res = await Api.contactRestaurant(body);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });
      CommonMethods().customDialog(context,
          msg:
              "Thank you for your contact.\nWe will respond to the email provided",
          onTap: () {
        Get.to(() => RestaurantsPage());
      });
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'][0], context);
    }
  }
}
