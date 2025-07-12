import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/model/store_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/routes.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/main_app_bar.dart';

class RestaurantsPage extends StatefulWidget {
  int id = NavConst.profile;

  RestaurantsPage({Key? key, id}) : super(key: key);

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  var streamBuilder;
  var searchBuilder;
  List<StoresList>? allVData;
  double height = SizeConfig.screenHeight;
  double width = SizeConfig.screenWidth;
  TextEditingController searchEditingController = TextEditingController();

  loadData() {
    streamBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allVData = snapshot.data!.stores;

          return SizedBox(
            height: SizeConfig.screenHeight,
            width: double.infinity,
            child: ListView.builder(
              itemCount: allVData!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTileStore(
                  allData: allVData,
                  index: index,
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
            height: SizeConfig.screenHeight,
            width: double.infinity,
            child: ListView.builder(
              itemCount: allVData!.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (allVData![index]
                    .name
                    .toLowerCase()
                    .contains(value.toLowerCase())) {
                  return ListTileStore(
                    allData: allVData,
                    index: index,
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

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget searchBar() {
    return Container(
      // height: height * 0.12,
      width: width,
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
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
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
    height = SizeConfig.screenHeight;
    width = SizeConfig.screenHeight;

    var one = Get.arguments ?? "";
    var back = widget.id;

    var bar = MainAppBar("Restaurants", false, () => Get.back(id: widget.id));
    if (one != "") {
      bar = MainAppBar("Restaurants", false, () => Get.back());
    }

    return SafeArea(
      child: Scaffold(
        appBar: bar,
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              height: SizeConfig.screenHeight * 0.8,
              width: SizeConfig.screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),

                    Text(
                      "Toggle on your preferred stores",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.6,
                          color: const Color(0xff0E0B20),
                          height: SizeConfig.blockSizeVertical * 0.16,
                          fontFamily: 'Muli-Light'),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),

                    searchBar(),

                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),

                    //call
                    searchEditingController.text.isNotEmpty
                        ? searchBuilder
                        : streamBuilder,
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

// ignore: must_be_immutable
class ListTileStore extends StatefulWidget {
  List<StoresList>? allData;
  int? index;
  int? navId;
  ListTileStore({this.allData, this.index, this.navId});

  @override
  _ListTileStoreState createState() => _ListTileStoreState();
}

class _ListTileStoreState extends State<ListTileStore> {
  late int index;
  @override
  void initState() {
    index = widget.index!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.RESTAURANTDETAILS,
            arguments: {"id": widget.allData![index].id, "navId": widget.navId},
            id: widget.navId);
      },
      child: Container(
        // height: SizeConfig.blockSizeVertical*8,
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
        padding:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // height: SizeConfig.blockSizeVertical*8,
              width: SizeConfig.blockSizeHorizontal * 85,
              // color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.allData![index].name} "
                  "(${widget.allData![index].location})",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2.2,
                      color: const Color(0xff0E0B20),
                      fontFamily: 'Muli'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
