import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/commonWidgets/button.dart';
import 'package:Bossa/model/store_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/common_methods.dart';
import 'package:Bossa/util/main_app_bar.dart';

// ignore: must_be_immutable
class PreferredStore extends StatefulWidget {
  var uuid;
  var navId;
  PreferredStore({this.uuid, navId});
  @override
  _PreferredStoreState createState() => _PreferredStoreState();
}

late List<StoresList> allVData;

class _PreferredStoreState extends State<PreferredStore> {
  var streamBuilder;
  var searchBuilder;
  List tempName = [];
  List tempId = [];
  TextEditingController searchEditingController = TextEditingController();
  Api api = Api();
  var userData;
  bool isLoading = false;
  List locationList = [];
  List locationListId = [];

  getStoresData() async {
    userData = await api.fetchUserDetails();
    setState(() {
      isLoading = false;
    });
  }

  loadData() {
    streamBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (allVData.isEmpty) {
            allVData = snapshot.data!.stores;
            if (widget.uuid != null) {
              var prepData = userData.data.prefStores;
              for (var s in prepData) {
                for (int i = 0; i < allVData.length; i++) {
                  if (s['id'] == allVData[i].id) {
                    allVData[i].isSelect = true;
                    tempName.add(s['name']);
                    tempId.add(s['id']);
                  }
                }
              }
              locationList = tempName;
              locationListId = tempId;
            }
            locationList = tempName;
            locationListId = tempId;
          }

          return SizedBox(
            width: double.infinity,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: allVData.length,
              itemBuilder: (context, index) {
                return ListTileStore(
                  index: index,
                  onSwitch: addListName,
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

  @override
  void initState() {
    allVData = [];
    if (widget.uuid != null) {
      isLoading = true;
      getStoresData();
    }
    loadData();

    super.initState();
  }

  searchData(String value) {
    searchBuilder = FutureBuilder<Stores>(
      future: Api.preferredStore(),
      builder: (context, snapshot) {
        return SizedBox(
          height: SizeConfig.screenHeight * 0.87,
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allVData.length,
            itemBuilder: (context, index) {
              if (allVData[index]
                  .name
                  .toLowerCase()
                  .contains(value.toLowerCase())) {
                return ListTileStore(
                  index: index,
                  onSwitch: addListName,
                );
              } else {
                return Container();
              }
            },
          ),
        );
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

  addListName(var list, var list2) {
    locationList = list;
    locationListId = list2;
  }

  Widget searchBar() {
    return Container(
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
          hintText: 'Search',
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
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Preferred Stores",
            false,
            () =>
                widget.navId != null ? Get.back(id: widget.navId) : Get.back()),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: isLoading == true
              ? Center(child: CommonMethods().loader())
              : Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: SizeConfig.screenHeight * 0.85,
                  width: SizeConfig.screenWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                        //call
                        searchEditingController.text.isNotEmpty
                            ? searchBuilder
                            : streamBuilder,

                        Container(
                          // height: 50,
                          width: SizeConfig.screenWidth,
                          margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                          // margin: EdgeInsets.all(15.0),
                          child: CustomButton(
                            text: "CONFIRM",
                            onTap: () {
                              if (locationList.isNotEmpty &&
                                  locationListId.isNotEmpty) {
                                Map map = {
                                  'name': locationList,
                                  "id": locationListId
                                };
                                Navigator.pop(context, map);
                              } else {
                                CommonMethods().showFlushBar(
                                    "Please select atleast one store", context);
                              }
                            },
                          ),
                        )
                      ],
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
  int index;
  ListTileStore({required this.index, required this.onSwitch});
  Function onSwitch;

  @override
  _ListTileStoreState createState() => _ListTileStoreState();
}

class _ListTileStoreState extends State<ListTileStore> {
  late int index;
  @override
  void initState() {
    index = widget.index;
    firstTrue();
    super.initState();
  }

  void firstTrue() {
    List selected = [];
    List selectedId = [];
    for (var item in allVData) {
      if (item.isSelect == true) {
        selected.add(item.name);
        selectedId.add(item.id);
      }
    }
    widget.onSwitch(selected, selectedId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          allVData[index].isSelect = !allVData[index].isSelect;
        });

        List selected = [];
        List selectedId = [];

        for (var item in allVData) {
          if (item.isSelect == true) {
            selected.add(item.name);
            selectedId.add(item.id);
          }
        }
        widget.onSwitch(selected, selectedId);
        setState(() {});
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 9,
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
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
                  "${allVData[index].name} (${allVData[index].location})",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2.2,
                      color: const Color(0xff0E0B20),
                      fontFamily: 'Muli'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                            color: allVData[index].isSelect
                                ? const Color(0xffEDCC40)
                                : const Color(0xffF1F2F4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                      Align(
                        alignment: allVData[index].isSelect
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.fastOutSlowIn,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 3),
                                shape: BoxShape.circle,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
