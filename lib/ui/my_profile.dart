import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/model/user_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:Bossa/util/resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Bossa/util/common_methods.dart';

class MyProfile extends StatefulWidget {
  var navId = NavConst.homeNav;

  MyProfile({Key? key, data}) : super(key: key) {
    if (data != null) {
      navId = data['navId'] ?? NavConst.profile;
    } else {
      navId = NavConst.profile;
    }
  }

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late String name, email;
  var uuid;
  late String firstName, lastName;

  @override
  void initState() {
    super.initState();
  }

  Api api = Api();

  @override
  Widget build(BuildContext context) {
    var one = Get.arguments ?? "";
    var back = widget.navId;

    if (one != "") {
      back = NavConst.homeNav;
    }
    var bar = const MainAppBar("My Profile", false, null);
    if (back == NavConst.homeNav) {
      bar = MainAppBar("My Profile", false, () => Get.back());
    } else if (back == NavConst.rewardnav) {
      bar = MainAppBar("My Profile", false, () => Get.back(id: widget.navId));
    }
    return SafeArea(
      child: Scaffold(
        appBar: bar,
        body: Container(
          height: SizeConfig.screenHeight * 0.8,
          color: const Color.fromRGBO(241, 242, 244, 1),
          child: FutureBuilder<Resource<UserModel>>(
            future: api.fetchUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var uData = snapshot.data!.data;
                firstName = uData!.name;
                lastName = uData.lastName!;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 3),
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 3),
                        // height: SizeConfig.blockSizeVertical * 20,
                        width: double.infinity,
                        color: const Color(0xfff1f2f4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 5,
                            ),
                            Text(
                              uData.name + " " + uData.lastName,
                              style: TextStyle(
                                  color: const Color(0xff0E0B20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 3,
                                  fontFamily: 'Muli-Bold'),
                            ),
                            Text(
                              uData.email!,
                              style: TextStyle(
                                  color: const Color(0xff0E0B20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: 'Muli-Bold'),
                            ),
                          ],
                        ),
                      ),
                      MyProfileButtons(
                        text: 'Edit Information',
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          var uuid = preferences.getString("uuid");

                          Get.toNamed(Routes.CREATEACCOUNT,
                              arguments: {'uuid': uuid, 'navId': widget.navId},
                              id: widget.navId);
                        },
                      ),
                      MyProfileButtons(
                          text: 'Change Password',
                          onTap: () {
                            Get.toNamed(Routes.FORGOTPASSWORD,
                                arguments: {
                                  'isForget': false,
                                  'emailID': uData.email,
                                  'navId': widget.navId
                                },
                                id: widget.navId);
                          }),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.MEMBERCARD,
                              arguments: {
                                "firstName": firstName,
                                "lastName": lastName,
                                "navId": widget.navId
                              },
                              id: widget.navId);
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical *
                              (SizeConfig.isDeviceLarge ? 7.5 : 7.5),
                          width: SizeConfig.blockSizeHorizontal * 88,
                          margin: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeVertical * 3),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Center(
                            child: Text(
                              'BOSSA REWARDS Membership Number',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xff0E0B20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 2.3,
                                  fontFamily: 'Muli-Bold'),
                            ),
                          ),
                        ),
                      ),

                      /*     MyProfileButtons(
                        text: 'Spur Family Card',
                        onTap: () {
                          Get.toNamed(Routes.SPURCARD,
                              arguments: {
                                "firstName": firstName,
                                lastName: lastName,
                                "navId": widget.navId
                              },
                              id: widget.navId);
                        },
                      ),
                      MyProfileButtons(
                        text: 'Panarottis BOSSA REWARDS Card',
                        onTap: () {
                          Get.toNamed(Routes.PANAROTTISCARD,
                              arguments: {
                                "firstName": firstName,
                                lastName: lastName,
                                "navId": widget.navId
                              },
                              id: widget.navId);
                        },
                      ),
                      MyProfileButtons(
                        text: "John's Club Card",
                        onTap: () {
                          Get.toNamed(Routes.JOHNCARD,
                              arguments: {
                                "firstName": firstName,
                                lastName: lastName,
                                "navId": widget.navId
                              },
                              id: widget.navId);
                        },
                      ),
                      MyProfileButtons(
                        text: 'Roco Love Card',
                        onTap: () {
                          Get.toNamed(Routes.ROCCOCARD,
                              arguments: {
                                "firstName": firstName,
                                lastName: lastName,
                                "navId": widget.navId
                              },
                              id: widget.navId);
                        },
                      ),
                      */
                      MyProfileButtons(
                        text: 'Share Referral Code',
                        onTap: () async {
                          await api.shareReferral().then((value) {
                            print(value["status"]);
                            CommonMethods()
                                .customShare(context, value["referel_code"]);
                          });
                        },
                      ),
                      MyProfileButtons(
                        text: 'Log Out',
                        onTap: () {
                          CommonMethods().customAlert(context, () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setBool("isLogin", false);
                            Get.offAllNamed(Routes.LOGIN);
                          });
                        },
                      ),
                      MyProfileButtons(
                        text: "Delete Profile",
                        onTap: () async {
                          CommonMethods().customAlertDelete(context, () async {
                            final delete = await Api.delete();
                            if (delete) {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setBool("isLogin", false);
                              Get.offAllNamed(Routes.LOGIN);
                            } else {
                              Get.snackbar("Problem",
                                  "Problem deleting profile. Please contact Rewards support.");
                            }
                          });
                        },
                      )
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffEDCC40)),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyProfileButtons extends StatefulWidget {
  Function onTap;
  String text;
  MyProfileButtons({Key? key, required this.onTap, required this.text})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyProfileButtonsState createState() => _MyProfileButtonsState();
}

class _MyProfileButtonsState extends State<MyProfileButtons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: SizeConfig.blockSizeVertical *
            (SizeConfig.isDeviceLarge ? 6.5 : 7.5),
        width: SizeConfig.blockSizeHorizontal * 88,
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 3),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                color: const Color(0xff0E0B20),
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.blockSizeVertical * 2.3,
                fontFamily: 'Muli-Bold'),
          ),
        ),
      ),
    );
  }
}
