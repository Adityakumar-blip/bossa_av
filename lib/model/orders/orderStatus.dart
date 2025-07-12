class OrderStatus {
  int? statusCode;
  String? description;
  String? timestamp;

  OrderStatus({this.statusCode, this.description, this.timestamp});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    description = json['description'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['description'] = description;
    data['timestamp'] = timestamp;
    return data;
  }
}
