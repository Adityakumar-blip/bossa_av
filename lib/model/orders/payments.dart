class Payments {
  String? status;
  int? amount;
  List<Payment>? payment;

  Payments({this.status, this.amount, this.payment});

  Payments.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    amount = json['amount'];
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['amount'] = amount;
    if (payment != null) {
      data['payment'] = payment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  String? paymentDate;
  String? paymentMethod;
  int? amount;
  String? reference;

  Payment({this.paymentDate, this.paymentMethod, this.amount, this.reference});

  Payment.fromJson(Map<String, dynamic> json) {
    paymentDate = json['paymentDate'];
    paymentMethod = json['paymentMethod'];
    amount = json['amount'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentDate'] = paymentDate;
    data['paymentMethod'] = paymentMethod;
    data['amount'] = amount;
    data['reference'] = reference;
    return data;
  }
}
