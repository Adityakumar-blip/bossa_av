class Delivery {
  int? agentId;
  String? agentName;
  String? companyName;
  String? email;
  String? contactNumber;
  String? address;
  int? deliveryCost;
  String? deliveryNote;
  String? estimatedDeliveryTime;
  String? deliveryMethod;

  Delivery(
      {this.agentId,
      this.agentName,
      this.companyName,
      this.email,
      this.contactNumber,
      this.address,
      this.deliveryCost,
      this.deliveryNote,
      this.estimatedDeliveryTime,
      this.deliveryMethod});

  Delivery.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'];
    agentName = json['agentName'];
    companyName = json['companyName'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    address = json['address'];
    deliveryCost = json['deliveryCost'];
    deliveryNote = json['deliveryNote'];
    estimatedDeliveryTime = json['estimatedDeliveryTime'];
    deliveryMethod = json['deliveryMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['companyName'] = companyName;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['address'] = address;
    data['deliveryCost'] = deliveryCost;
    data['deliveryNote'] = deliveryNote;
    data['estimatedDeliveryTime'] = estimatedDeliveryTime;
    data['deliveryMethod'] = deliveryMethod;
    return data;
  }
}
