import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/ui/newsController.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

class NewsPage extends StatelessWidget {
  var _navID = NavConst.notifyNav;
  String? res;

  get navID => _navID;

  set navID(navID) {
    _navID = navID;
  }

  NewsPage({Key? key, data}) : super(key: key) {
    _navID = NavConst.notifyNav;
    if (data != null) {
      _navID = data['navId'] ?? NavConst.notifyNav;
      res = data['res'];
      cont.setRestId(res);
    }
  }

  var newsList;
  bool isLoading = false;
  NewsController cont = Get.put(NewsController());

  Widget newsWidget(String title, String details, String image, String id,
      Image? icon, var navID) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            height: SizeConfig.screenHeight * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              color: Colors.black,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: icon ??
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(child: CommonMethods().loader());
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title.isNotEmpty ? title : 'Name',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                // Description
                Text(
                  details.isNotEmpty ? details : 'Description',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15.0),
                // Details Button
                // SizedBox(
                //   width: double.infinity,
                //   child: CustomButton(
                //     text: 'Details',
                //     onTap: () {
                //       Get.toNamed(Routes.NEWSDETAIL,
                //           arguments: {"id": id, "navId": navID}, id: navID);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? Color(0xffEDCC40) : Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    return GetBuilder<NewsController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FILTER',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  _buildTabButton(
                    "ALL",
                    controller.selectedType == null,
                    () => controller.setFilterType(null),
                  ),
                  const SizedBox(width: 10.0),
                  _buildTabButton(
                    "FOOD",
                    controller.selectedType == "Food",
                    () => controller.setFilterType("Food"),
                  ),
                  const SizedBox(width: 12.0),
                  _buildTabButton(
                    "BAR",
                    controller.selectedType == "Bar",
                    () => controller.setFilterType("Bar"),
                  ),
                  const SizedBox(width: 12.0),
                  _buildTabButton(
                    "COMPETITION",
                    controller.selectedType == "Competition",
                    () => controller.setFilterType("Competition"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var one = Get.arguments ?? "";

    var bar = MainAppBar('Bossa Good Times', false, () => Get.back(id: _navID));
    if (one != "") {
      bar = MainAppBar("Bossa Good Times", false, () => Get.back());
    }

    return GetBuilder<NewsController>(
        init: cont,
        builder: (controller) => SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xfff1f2f4),
                appBar: bar,
                body: Column(
                  children: [
                    _buildTabSection(),
                    Expanded(
                      child: controller.isLoading.value
                          ? Center(child: CommonMethods().loader())
                          : controller.newsList.newsData.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No data Found',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : ListView(
                                  children: [
                                    SafeArea(
                                      bottom: false,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0, top: 10.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: controller
                                                  .newsList.newsData.length ??
                                              0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var newsItem = controller
                                                .newsList.newsData[index];
                                            return newsWidget(
                                                newsItem.title ?? '',
                                                newsItem.details ?? '',
                                                newsItem.image ?? '',
                                                newsItem.id ?? '',
                                                null,
                                                _navID);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class NewsDetails extends StatefulWidget {
  String? id;
  var navId;
  NewsDetails({Key? key, data}) : super(key: key) {
    if (data != null && data != "") {
      id = data['id'] ?? "";
      navId = data['navId'] ?? NavConst.notifyNav;
    } else {
      navId = NavConst.notifyNav;
    }
  }
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  late bool isLoading;
  var newsList;
  String? image, title, details, promotionType, restaurantID;

  @override
  void initState() {
    isLoading = true;
    newsData();
    super.initState();
  }

  newsData() async {
    try {
      var response = await Api.getPromotionType('');
      var data = jsonDecode(response);
      print(data);
      if (data['status'] == 'success') {
        for (var item in data['data']) {
          if (item['id'] == widget.id) {
            setState(() {
              image = item['image'];
              title = item['title'];
              details = item['details'];
              promotionType = item['promotion_type'];
              // restaurantID = item['restaurant']; // Add if available in API
            });
            break;
          }
        }
      }
    } catch (e) {
      print("Error fetching news details: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
          'Promotions Details', false, () => Get.back(id: widget.navId)),
      backgroundColor: const Color(0xfff1f2f4),
      body: isLoading == true
          ? Center(child: CommonMethods().loader())
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight * 0.25,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: image != null
                                              ? Image.network(
                                                  image!,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                          child: CommonMethods()
                                                              .loader());
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child:
                                                      CommonMethods().loader()),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          title ?? '',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (promotionType != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Text(
                                              promotionType!,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 10.0),
                              child: Container(
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    details ?? '',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            if (restaurantID != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: CustomButton(
                                  text: 'View Restaurant',
                                  onTap: () {
                                    Get.toNamed(Routes.RESTAURANTDETAILS,
                                        arguments: {
                                          'id': restaurantID,
                                          "navId": widget.navId
                                        },
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
              ),
            ),
    );
  }
}
