class OrderCallback {
  bool? status;
  String? message;
  int? code;
  String? reference;
  OrderCallback({this.status, this.message, this.code, this.reference});

  OrderCallback.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    code = json["Code"];
    reference = json["Reference"];
  }
}
