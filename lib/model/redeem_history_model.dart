class RedeemHistoryModel {
  late List<RedeemHistoryList> history;
  RedeemHistoryModel({required this.history});

  RedeemHistoryModel.fromJson(Map<String, dynamic> json) {
    List historyList = json['data'] as List;

    history =
        historyList.map((item) => RedeemHistoryList.fromJson(item)).toList();
  }
}

class RedeemHistoryList {
  var id;
  var rewardName;
  var userId;
  var rewardId;
  var rewardPoints;
  var date;

  RedeemHistoryList(
      {this.id,
      this.rewardName,
      this.rewardPoints,
      this.rewardId,
      this.date,
      this.userId});

  RedeemHistoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rewardName = json['reward_name'];
    rewardId = json['reward_id'];
    userId = json['user_id'];
    rewardPoints = json['points'];
    date = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['rewardName'] = rewardName;
    data['rewardId'] = rewardId;
    data['rewardPoints'] = rewardPoints;
    data['userId'] = userId;
    data['date'] = date;

    return data;
  }
}
