import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/store_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/ui/covidQuestions.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CovidPage extends StatefulWidget {
  const CovidPage({super.key});

  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar("Health QA", false, () => Get.back()),
        body: isLoading == true
            ? Center(child: CommonMethods().loader())
            : SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            height: SizeConfig.screenHeight * 0.52,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Store Select',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xffEDCC40)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 3.0,
                                      left: SizeConfig.screenWidth / 6,
                                      right: SizeConfig.screenWidth / 6),
                                  child: const Divider(
                                    thickness: 3,
                                    height: 0,
                                    color: Color(0xffEDCC40),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'Select Store',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey[600]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: CustomButton(
                                    text: 'Click Here to Create',
                                    onTap: () {
                                      Get.to(() => const SelectStoreCovid());

                                      // Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2,
                              bottom: SizeConfig.blockSizeVertical),
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 4),
                          child: CustomButton(
                            text: 'Go Back',
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class SelectStoreCovid extends StatefulWidget {
  const SelectStoreCovid({super.key});

  @override
  _SelectStoreCovidState createState() => _SelectStoreCovidState();
}

class _SelectStoreCovidState extends State<SelectStoreCovid> {
  var streamBuilder;
  var searchBuilder;
  late List<StoresList>? allVData;
  late String tempName;
  late String tempID;
  late int selectedIndex;
  var uuid;
  TextEditingController searchEditingController = TextEditingController();
  @override
  void initState() {
    getUUID();
    loadData();
    super.initState();
  }

  getUUID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uuid = preferences.getString("uuid");
  }

  loadData() {
    streamBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allVData = snapshot.data!.stores;

          return SizedBox(
            height: SizeConfig.blockSizeVertical *
                (SizeConfig.isDeviceLarge ? 45 : 40),
            width: double.infinity,
            child: ListView.builder(
              itemCount: allVData!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tempName = allVData![index].name;
                      tempID = allVData![index].id;
                      selectedIndex = index;
                      loadData();
                    });
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 9,
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical * 2),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${allVData![index].name} "
                              "(${allVData![index].location})",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.2,
                                  color: const Color(0xff0E0B20),
                                  fontFamily: 'Muli'),
                            ),
                          ),
                        ),
                        index == selectedIndex
                            ? const SizedBox(
                                width: 50,
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xffEDCC40),
                                  size: 30,
                                ))
                            : Container(width: 50),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (snapshot.hasError) {
          return Container();
        }
        return const Center(
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
        );
      },
    );
  }

  searchData(String value) {
    searchBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        if (allVData != null) {
          return SizedBox(
            // height: SizeConfig.blockSizeVertical*(SizeConfig.isDeviceLarge ? 45 : 40),
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allVData!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (allVData![index]
                    .name
                    .toLowerCase()
                    .contains(value.toLowerCase())) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tempName = allVData![index].name;
                        tempID = allVData![index].id;
                        selectedIndex = index;
                        searchData(value);
                      });
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 9,
                      margin: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeVertical * 2),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${allVData![index].name} "
                                "(${allVData![index].location})",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.2,
                                    color: const Color(0xff0E0B20),
                                    fontFamily: 'Muli'),
                              ),
                            ),
                          ),
                          index == selectedIndex
                              ? const SizedBox(
                                  width: 50,
                                  child: Icon(
                                    Icons.check,
                                    color: Color(0xffEDCC40),
                                    size: 30,
                                  ))
                              : Container(width: 50),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }
        if (snapshot.hasError) {
          return Container();
        }
        return const Center(
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
        );
      },
    );
  }

  Widget searchBar() {
    return Container(
      // height: height * 0.12,
      width: SizeConfig.screenWidth,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextField(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        controller: searchEditingController,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        cursorWidth: 2.5,
        onChanged: (value) {
          setState(() {
            searchData(value);
          });
        },
        onEditingComplete: () {
          setState(() {
            FocusScope.of(context).unfocus();
          });
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: 'search',
          hintStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.only(left: 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F2F4),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: SizeConfig.blockSizeVertical * 25,
                    width: SizeConfig.blockSizeHorizontal * 70,
                    child: Image.asset('assets/images/pmck_logo.png'),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical,
                ),
                Text(
                  "Select Store",
                  style: TextStyle(
                      color: const Color(0xff0E0B20),
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 5,
                      fontFamily: 'Muli-Bold'),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 3,
                ),
                searchBar(),
                searchEditingController.text.isNotEmpty
                    ? searchBuilder
                    : streamBuilder,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // height: 50,
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        // margin: EdgeInsets.all(15.0),
        child: CustomButton(
          text: "CONFIRM",
          onTap: () {
            Get.to(() => CovidQuestions(
                  restaurantId: tempID,
                ));
          },
        ),
      ),
    );
  }
}
