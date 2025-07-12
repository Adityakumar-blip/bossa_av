
class ReturnOrder {
  late bool status;
  late int orderID;
  late String paymentLink;

  ReturnOrder({
    required this.status,
    required this.orderID,
    required this.paymentLink,
  });

  ReturnOrder.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null && json['status'] == "success" ? true : false;
    orderID = json['orderID'] != null ? json['orderID'] as int : 0;
    paymentLink = json['PaymentLink'] ?? "";
  }

  get paymentUrl => null;
}
