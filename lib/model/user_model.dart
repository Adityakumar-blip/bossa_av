class UserModel {
  var name;
  var id;
  late String? lastName;
  late String? email;
  var dob;
  var uuid;
  late String? spurCardNo;
  late List? prefStores;
  late List? childData;

  UserModel(
      {this.name,
      this.id,
      this.lastName,
      this.email,
      this.dob,
      this.spurCardNo,
      this.prefStores});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['first_name'] ?? " ";
    id = json['id'] ?? " ";
    lastName = json['last_name'] ?? " ";
    email = json['email'] ?? " ";
    dob = json['birth_date'] ?? " ";
    uuid = json['uuid'] ?? " ";
    spurCardNo = json['spur_family_card_number'] ?? " ";
    prefStores = json['preferred_store'];
    childData = json['childs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['lastName'] = lastName;
    data['email'] = email;
    data['dob'] = dob;
    data['uuid'] = uuid;
    data['spurCardNo'] = spurCardNo;
    data['prefStores'] = prefStores;
    data['childData'] = childData;

    return data;
  }
}
