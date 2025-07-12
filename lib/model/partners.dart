class Partners {
  List<Partner> partners = [];
  Partners(this.partners);

  Partners.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      partners = [];
      json['data'].forEach((v) {
        partners.add(Partner.fromJson(v));
      });
    }
  }
}

class Partner {
  String? id;
  String? logo;
  String? website;
  String? status;

  Partner({
    this.id,
    this.logo,
    this.website,
    this.status,
  });

  Partner.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    logo = json['logo'] ?? "";
    website = json['website_address'] ?? "";
    status = json['status'] ?? "";
  }
}
