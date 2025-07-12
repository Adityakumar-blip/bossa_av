import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Bossa/model/redeem_history_model.dart';
import 'package:Bossa/network/api.dart';
import 'package:Bossa/util/NavConst.dart';
import 'package:Bossa/util/SizeConfig.dart';
import 'package:Bossa/util/main_app_bar.dart';
import 'package:Bossa/util/top_part.dart';

class RedeemHistory extends StatefulWidget {
  var navId;
  RedeemHistory({Key? key, data}) : super(key: key) {
    if (data != null) {
      navId = data['navId'] ?? NavConst.rewardnav;
    } else {
      navId = NavConst.rewardnav;
    }
  }

  @override
  _RedeemHistoryState createState() => _RedeemHistoryState();
}

class _RedeemHistoryState extends State<RedeemHistory> {
  var streamBuilder;
  late List<RedeemHistoryList> allData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    streamBuilder = FutureBuilder<RedeemHistoryModel>(
      future: Api.redeemHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allData = snapshot.data!.history;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: SizeConfig.screenHeight * 0.52,
            width: double.infinity,
            child: allData.length == 0
                ? Center(
                    child: Text(
                    'No Voucher History found',
                    style: TextStyle(fontSize: 17),
                  ))
                : ListView.builder(
                    // shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: allData.length,

                    itemBuilder: (context, index) {
                      return ListTileHistory(
                        allData: allData,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            "Voucher History", false, () => Get.back(id: widget.navId)),
        body: SizedBox(
          height: SizeConfig.screenHeight * 0.85,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TopPart(title: "Voucher History"),
                  ),
                  streamBuilder,
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
  List<RedeemHistoryList> allData;
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
    String formattedDate = DateFormat('dd/MM/yyyy')
        .format((DateTime.tryParse(widget.allData[index].date)!));
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
                    widget.allData[index].rewardName,
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
