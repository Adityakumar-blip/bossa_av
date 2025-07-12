

class Order {
  String? callbackUrl;

  Order.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['callbackUrl'] = callbackUrl;
    return data;
  }
}
