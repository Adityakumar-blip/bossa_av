// To parse this JSON data, do
//
//     final transactionHistoryModel = transactionHistoryModelFromJson(jsonString);

import 'dart:convert';

TransactionHistoryModel transactionHistoryModelFromJson(String str) =>
    TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) =>
    json.encode(data.toJson());

class TransactionHistoryModel {
  String? status;
  String? message;
  List<Datum>? data;

  TransactionHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  TransactionId? transactionId;
  DateTime? timeStamp;
  String? paymentAmount;

  Datum({
    this.transactionId,
    this.timeStamp,
    this.paymentAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        transactionId: transactionIdValues.map[json["transactionId"]]!,
        timeStamp: json["time_stamp"] == null
            ? null
            : DateTime.parse(json["time_stamp"]),
        paymentAmount: json["payment_amount"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionIdValues.reverse[transactionId],
        "time_stamp": timeStamp?.toIso8601String(),
        "payment_amount": paymentAmount,
      };
}

enum TransactionId { THE_5594_A4_TW31, THE_5594_A4_W671, THE_5594_A505_D1 }

final transactionIdValues = EnumValues({
  "5594-A4TW31": TransactionId.THE_5594_A4_TW31,
  "5594-A4W671": TransactionId.THE_5594_A4_W671,
  "5594-A505D1": TransactionId.THE_5594_A505_D1
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
