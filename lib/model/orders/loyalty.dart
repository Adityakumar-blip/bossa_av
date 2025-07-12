class Loyalty {
  int? vendorId;
  String? reference;
  String? identifyCode;
  int? paymentAmount;
  int? discountAmount;
  bool? accumulate;

  Loyalty(
      {this.vendorId,
      this.reference,
      this.identifyCode,
      this.paymentAmount,
      this.discountAmount,
      this.accumulate});

  Loyalty.fromJson(Map<String, dynamic> json) {
    vendorId = json['VendorId'];
    reference = json['Reference'];
    identifyCode = json['identifyCode'];
    paymentAmount = json['paymentAmount'];
    discountAmount = json['discountAmount'];
    accumulate = json['Accumulate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VendorId'] = vendorId;
    data['Reference'] = reference;
    data['identifyCode'] = identifyCode;
    data['paymentAmount'] = paymentAmount;
    data['discountAmount'] = discountAmount;
    data['Accumulate'] = accumulate;
    return data;
  }
}
