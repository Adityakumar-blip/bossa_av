class ProudPartners {
  List<ProudPartner> partners = [];

  ProudPartners();

  ProudPartners.fromJson(Map<String, dynamic> json);
}

class ProudPartner {
  String? id;
  String? logo;
  String? webSite;
  String? status;

  ProudPartner.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    logo = json['logo'] ?? "";
    webSite = json['website_address'] ?? "";
    status = json['status'] ?? "";
  }
}
