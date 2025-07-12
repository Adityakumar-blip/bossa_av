import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/notifications_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationsList> notificationData;
  var one = Get.arguments ?? "";
  @override
  Widget build(BuildContext context) {
    var bar = const MainAppBar("Notifications", false, null);
    if (one != "") {
      bar = MainAppBar("Notifications", false, () => Get.back());
    }
    return SafeArea(
      child: Scaffold(
        appBar: bar,
        body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
              height: SizeConfig.screenHeight * 0.78,
              child: FutureBuilder<Notifications>(
                  future: Api.getNotificationList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      notificationData = snapshot.data!.notifications;
                      return SafeArea(
                        bottom: false,
                        child: notificationData.length == 0
                            ? Center(
                                child: Text(
                                'No notifications found',
                                style: TextStyle(fontSize: 17),
                              ))
                            : Container(
                                width: SizeConfig.screenWidth * 1.2,
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0, top: 10),
                                        child: Container(
                                            height:
                                                SizeConfig.screenHeight * 1.49,
                                            width: SizeConfig.screenWidth,
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff1f2f4),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: ListView.builder(
                                              itemCount:
                                                   notificationData.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 60,
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.8,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      color: Colors.white,
                                                    ),
                                                    child: ListTile(
                                                      leading: Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: notificationData[
                                                                        index]
                                                                    .read ==
                                                                "0"
                                                            ? const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(
                                                                    0xfffb6e37),
                                                              )
                                                            : BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: const Color(
                                                                      0xfffb6e37),
                                                                )),
                                                      ),
                                                      title: Text(
                                                        notificationData[index]
                                                            .title,
                                                        style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                'Muli-Bold',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onTap: () async {
                                                        if (notificationData[
                                                                    index]
                                                                .read ==
                                                            "0") {
                                                          setState(() {
                                                            notificationData[
                                                                    index]
                                                                .read = "1";
                                                          });
                                                          // ignore: unused_local_variable
                                                          var res = Api
                                                              .viewNotification(
                                                                  notificationData[
                                                                          index]
                                                                      .id);
                                                        }

                                                        Get.toNamed(
                                                            Routes
                                                                .DISPLAYNOTIFCATION,
                                                            arguments: [
                                                              notificationData[
                                                                      index]
                                                                  .title,
                                                              notificationData[
                                                                      index]
                                                                  .date,
                                                              notificationData[
                                                                      index]
                                                                  .message,
                                                              notificationData[
                                                                      index]
                                                                  .link,
                                                            ],
                                                            id: NavConst
                                                                .notifyNav);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        child: Text('data'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
                    );
                  })),
        ),
      ),
    );
  }
}

class DisplayNotification extends StatefulWidget {
  String title = '';
  String date = "";
  String message = '';
  String link = "";
  var data;

  DisplayNotification({Key? key, dynamic data}) : super(key: key) {
    title = data[0];
    date = data[1];
    message = data[2];
    link = data[3];
  }

  @override
  _DisplayNotificationState createState() => _DisplayNotificationState();
}

class _DisplayNotificationState extends State<DisplayNotification> {
  final List<String> _listItems = [
    "About Us",
    "BOSSA REWARDS",
    "Notifications",
    "Share App",
    "Restaurants",
    "News & Promotions",
    "My Profile"
  ];
  final List<String> _newPage = [
    Routes.ABOUTUS,
    Routes.REWARDDASH,
    Routes.NOTIFICATION,
    Routes.SHAREDAPP,
    Routes.RESTUARANTPAGE,
    Routes.NEWS,
    Routes.PROFILE,
  ];

  void _launchPage(pageName) {
    if (_listItems.contains(pageName)) {
      var name = _newPage[_listItems.indexOf(pageName)];

      Get.toNamed(name, id: NavConst.notifyNav);
    } else {
      CommonMethods().showFlushBar("Invalid Page Request", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        MainAppBar("Display Notifications", false,
            () => Get.back(id: NavConst.notifyNav)),
        SafeArea(
          bottom: false,
          child: Container(
            height: SizeConfig.screenHeight * 0.78,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                      height: 50,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                        'Notifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Muli-Bold',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: SizedBox(
                      height: SizeConfig.screenHeight * 0.8,
                      width: SizeConfig.screenWidth,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontFamily: 'Muli-Bold',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '(${widget.date})',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Muli-Bold',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                height: SizeConfig.screenHeight * 0.4,
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      widget.message,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontFamily: 'Muli-Bold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 4),
                              child: CustomButton(
                                width: 150,
                                text: 'View',
                                onTap: () {
                                  _launchPage(widget.link);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
