import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/restaurant_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:Bossa/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class RestaurantDetails extends StatefulWidget {
  var id;
  int navId = NavConst.homeNav;
  RestaurantDetails({super.key, data}) {
    id = data['id'];
    navId = data['navId'] ?? NavConst.homeNav;
  }
  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  List<String> daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
    'Public Holidays'
  ];
  Api api = Api();
  late bool _validURL;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Map? urlData;
  fetch() async {
    Map data = await api.geturl(widget.id);
    setState(() {
      urlData = data;
    });
  }

  void callRestaurant(url) async {
    try {
      await launchUrl(url);
    } catch (e) {
      CommonMethods().showFlushBar("Something went wrong.", context);
    }
  }

  void bookonline(url) async {
    if (url == null) {
      CommonMethods().showFlushBar(
          "Sorry, you cannot order from this restaurant.", context);
    } else {
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        CommonMethods().showFlushBar("Something went wrong.", context);
      }
    }
  }

  void openMap(url) async {
    try {
      await launchUrl(
        url,
      );
    } catch (e) {
      CommonMethods().showFlushBar("Location not found on map.", context);
    }
  }

  void openRatingPage(ratingURL) async {
    try {
      await launchUrl(
        Uri.parse("https://www.google.com/"),
      );
    } catch (e) {
      CommonMethods().showFlushBar("Something went wrong.", context);
    }
  }

  void openBooking(ratingURL) async {
    try {
      await launchUrl(
        ratingURL,
      );
    } catch (e) {
      CommonMethods().showFlushBar("Something went wrong.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
          "Restaurants Detail", false, () => Get.back(id: widget.navId)),
      body: SafeArea(
          bottom: false,
          child: FutureBuilder<Resource<RestaurantModel>>(
            future: api.restaurantDetails(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: SizeConfig.screenHeight * 0.855,
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                                  snapshot.data!.data!.image,
                                  fit: BoxFit.fill,
                                  height: double.infinity,
                                  width: double.infinity,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                          child: CommonMethods().loader());
                                    }
                                  },
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  // height: SizeConfig.blockSizeVertical*18,
                                  margin: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 6,
                                    right: SizeConfig.blockSizeHorizontal * 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.data!.resName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontFamily: 'Muli-Bold',
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  3.4,
                                          color: const Color(0xff0E0B20),
                                        ),
                                      ),
                                      //SizedBox(height: 5.0,),
                                      Row(
                                        children: [
                                          SizedBox(
                                            // color: Colors.green,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    40,
                                            child: Text(
                                              snapshot.data!.data!.location,
                                              style: TextStyle(
                                                  fontFamily: 'Muli-SemiBold',
                                                  fontSize: SizeConfig
                                                          .blockSizeVertical *
                                                      2.2,
                                                  color: const Color.fromRGBO(
                                                      14, 11, 32, 0.8)),
                                            ),
                                          ),
                                          Container(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    7,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                color: const Color(0xffEDCC40),
                                                width: 6.0,
                                              ),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                'Get Direction',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Muli-Bold',
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        2.1,
                                                    color: const Color(
                                                        0xff222222)),
                                              ),
                                              onPressed: () {
                                                print(
                                                    "direction ${snapshot.data!.data!.location}");
                                                print(
                                                    'https://www.google.com/maps/search/?api=1&query=${snapshot.data!.data!.location.replaceAll(' ', "%20")}');
                                                openMap(
                                                    'https://www.google.com/maps/search/?api=1&query=${snapshot.data!.data!.location.replaceAll(' ', "%20")}');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical * 35,
                          margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 6,
                            right: SizeConfig.blockSizeHorizontal * 6,
                          ),
                          child: Column(
                            children: [
                              CustomButton(
                                width: 200,
                                text: 'Call Now',
                                onTap: () {
                                  callRestaurant(
                                      'tel:${snapshot.data!.data!.phoneNo}');
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Opening Hours",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  3.8,
                                          fontFamily: 'Muli-Bold',
                                          color: const Color(0xff0E0B20)),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: daysList.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                daysList[index],
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        2.5,
                                                    fontFamily: 'Muli-SemiBold',
                                                    color: const Color.fromRGBO(
                                                        14, 11, 32, 0.8)),
                                              ),

                                              // Text("8:00am - 5:00pm", style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5, fontFamily: 'Muli-SemiBold',color: Color.fromRGBO(14, 11, 32,0.8)),),
                                              Text(
                                                snapshot.data!.data!
                                                        .openingTime[index] +
                                                    " - " +
                                                    snapshot.data!.data!
                                                        .closingTime[index],
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        2.5,
                                                    fontFamily: 'Muli-SemiBold',
                                                    color: const Color.fromRGBO(
                                                        14, 11, 32, 0.8)),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3,
                              bottom: SizeConfig.blockSizeVertical * 3),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: SizeConfig.blockSizeVertical * 3),
                                child: CustomButton(
                                  width: 200,
                                  text: 'Rate Restaurant',
                                  onTap: () {
                                    setState(() {
                                      _validURL = Uri.parse(
                                              snapshot.data!.data!.rateLink)
                                          .isAbsolute;
                                    });
                                    if (_validURL == true) {
                                      var data = [
                                        widget.id,
                                        snapshot.data!.data!.resName,
                                        snapshot.data!.data!.resName,
                                        snapshot.data!.data!.image,
                                        snapshot.data!.data!.rateLink,
                                        widget.navId,
                                        "Rate Restaurant"
                                      ];
                                      Get.toNamed(Routes.RATESRESTAURANT,
                                          arguments: data, id: widget.navId);
                                    } else {
                                      CommonMethods().showFlushBar(
                                          "Something went wrong.", context);
                                    }
                                    // openRatingPage(snapshot.data.data.rateLink);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: SizeConfig.blockSizeVertical * 3),
                                child: CustomButton(
                                  width: 200,
                                  text: 'Book Online',
                                  onTap: () {
                                    var data = [
                                      widget.id,
                                      snapshot.data!.data!.resName,
                                      snapshot.data!.data!.resName,
                                      snapshot.data!.data!.image,
                                      urlData!["data"]["booking_url"],
                                      widget.navId,
                                      "Book Online"
                                    ];
                                    Get.toNamed(Routes.RATESRESTAURANT,
                                        arguments: data, id: widget.navId);
                                    // print(urlData);
                                    // bookonline(urlData!["data"]["booking_url"]);
                                  },
                                ),
                              ),
                              //---WhatsApp---//
                              review(context),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: SizeConfig.blockSizeVertical * 3),
                                child: CustomButton(
                                  width: 200,
                                  text: 'Contact Restaurant',
                                  onTap: () {
                                    Get.toNamed(Routes.CONTACTRESTUARANT,
                                        arguments: [
                                          snapshot.data!.data!.resName,
                                          snapshot.data!.data!.location,
                                          widget.id,
                                          snapshot.data!.data!.image,
                                          widget.navId
                                        ],
                                        id: widget.navId);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  "No Detail Found",
                  style: TextStyle(fontSize: 18),
                ));
              }

              return Container();
            },
          )),
    );
  }

  //---WhatsApp---//
  Widget review(context) {
    return GestureDetector(
        onTap: () async {
          var res = await Api().getCustomerCare();
          print(res);
          var whatsappAndroid = Uri.parse(
              "whatsapp://send?phone=${res["data"]["whatsapp_number"]}&text=HowZaT");
          if (await canLaunchUrl(whatsappAndroid)) {
            await launchUrl(whatsappAndroid);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("WhatsApp is not installed on the device"),
              ),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 3),
          height: SizeConfig.blockSizeVertical *
              (SizeConfig.isDeviceLarge ? 5 : 10),
          width: 200,
          decoration: BoxDecoration(
              color: const Color(0xff1bd741),
              border: Border.all(color: const Color(0xff1bd741), width: 10),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: [
              Image.asset(
                'assets/images/whatsapp_icon.png',
                height: 40,
                width: 40,
              ),
              const Text(
                "WhatsApp",
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: 'Muli-Bold'),
              ),
            ],
          ),
        ));
  }
}
