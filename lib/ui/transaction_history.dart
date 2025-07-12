import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:Bossa/model/redeem_history_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/ui/reward_dashboard.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:Bossa/util/top_part.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/TransactionHistory_model.dart';

class TransactionHistory extends StatefulWidget {
  var navId;
  TransactionHistory({Key? key, data}) : super(key: key) {
    if (data != null) {
      navId = data['navId'] ?? NavConst.rewardnav;
    } else {
      navId = NavConst.rewardnav;
    }
  }

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  var streamBuilder;
  List<dynamic> allData = [];

  @override
  void initState() {
    super.initState();
    loadDataOfBuilder();
  }

  loadDataOfBuilder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    print('get login id ===>>>>$uuid');
    Map<String, String> headers = {'Authorization': Api.basicAuth};

    Map<String, dynamic> body = {
      "action": "GET_USER_TRANSACTIONS",
      // "membership_number": "0658804440"
      "membership_number": membershipNumber
    };

    print("body=====${json.encode(body)}");

    Response response = await post(
      Api.url,
      headers: headers,
      body: json.encode(body),
    );
    final valueMap = jsonDecode(response.body);
    print('====>>transaction body==>${response.body}');
    allData = valueMap['data'];
    setState(() {});
  }

  // loadData() {
  //   streamBuilder = FutureBuilder<TransactionHistoryModel>(
  //     future: Api.transactionHistory(),
  //     builder: (context, snapshot) {
  //       print('hasData :::: ' + snapshot.hasData.toString());
  //       print('SnapShort :::: ' + snapshot.data.toString());

  //       if (snapshot.hasData) {
  //         allData = snapshot.data?.data ?? [];
  //         return Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 10),
  //           height: SizeConfig.screenHeight * 0.52,
  //           width: double.infinity,
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             // physics: const BouncingScrollPhysics(),
  //             itemCount: allData.length,
  //             itemBuilder: (context, index) {
  //               return ListTileHistory(
  //                 allData: allData,
  //                 index: index,
  //               );
  //             },
  //           ),
  //         );
  //       }
  //       if (snapshot.hasError) {
  //         return Container();
  //       }

  //       return const Center(
  //         child: CircularProgressIndicator(
  //             strokeWidth: 2,
  //             valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEDCC40))),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Transaction history", false, () => Navigator.pop(context)),
        body: SizedBox(
          height: SizeConfig.screenHeight * 0.85,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TopPart(title: "Transaction history"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // streamBuilder,
                  allData.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: SizeConfig.screenHeight * 0.52,
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            // physics: const BouncingScrollPhysics(),
                            itemCount: allData.length,
                            itemBuilder: (context, index) {
                              return ListTileHistory(
                                allData: allData,
                                index: index,
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                          'No Transaction found',
                          style: TextStyle(fontSize: 17),
                        ))
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
class ListTileHistory extends StatefulWidget {
  List<dynamic> allData;
  int index;
  ListTileHistory({Key? key, required this.allData, required this.index})
      : super(key: key);

  @override
  _ListTileHistoryState createState() => _ListTileHistoryState();
}

class _ListTileHistoryState extends State<ListTileHistory> {
  late int index;
  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(
        (DateTime.tryParse(widget.allData[index]['time_stamp'].toString())!));
    // print(formattedDate.toString());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  // color: Colors.blue,
                  width: SizeConfig.blockSizeHorizontal * 45,
                  child: Text(
                    widget.allData[index]['payment_amount'].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Muli-Bold',
                        fontWeight: FontWeight.bold),
                  )),
              Text.rich(
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                      text: '(',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.3,
                          color: const Color(0xffEDCC40),
                          fontFamily: 'Muli-Bold')),
                  TextSpan(
                      text: formattedDate,
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.3,
                          color: Colors.black,
                          fontFamily: 'Muli-Bold')),
                  TextSpan(
                      text: ')',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.3,
                          color: const Color(0xffEDCC40),
                          fontFamily: 'Muli-Bold')),
                ]),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.black,
          thickness: 2.0,
        )
      ],
    );
  }
}
