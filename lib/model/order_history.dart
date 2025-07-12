
class OrderHistoy {
  List<OrderHistoy> histories = [];
  String orderNo = "";
  String res = "";
  String total = "0.00";
  String status = "";

  OrderHistoy();

  OrderHistoy.fromJsonList(List<dynamic> json) {
    if (json.isNotEmpty) {
      histories = json.map((e) => OrderHistoy.fromMap(e)).toList();
    }
  }

  OrderHistoy.fromMap(Map<String, dynamic> json) {
    orderNo = json['id'] ?? "";
    res = json['res'] ?? "";
    total = json['total'] ?? "0.00";
    status = json['status'] ?? "NEW";
  }
}
