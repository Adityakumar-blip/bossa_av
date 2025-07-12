class Client {
  int? id;
  String? name;
  String? email;
  String? contactNumber;
  String? address;
  String? identifyCode;

  Client(
      {this.id,
      this.name,
      this.email,
      this.contactNumber,
      this.address,
      this.identifyCode});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    address = json['address'];
    identifyCode = json['identifyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['address'] = address;
    data['identifyCode'] = identifyCode;
    return data;
  }
}
