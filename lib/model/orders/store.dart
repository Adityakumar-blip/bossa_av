class Store {
  String? storeId;
  List<PluItems>? pluItems;
  bool? status;
  String? message;

  Store({this.storeId, this.pluItems, this.status, this.message});

  Store.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    if (json['PluItems'] != null) {
      pluItems = <PluItems>[];
      json['PluItems'].forEach((v) {
        pluItems!.add(PluItems.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    if (pluItems != null) {
      data['PluItems'] = pluItems!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class PluItems {
  String? plu;
  String? itemName;
  int? price;
  String? dtab;
  List<Options>? options;

  PluItems({this.plu, this.itemName, this.price, this.dtab, this.options});

  PluItems.fromJson(Map<String, dynamic> json) {
    plu = json['Plu'];
    itemName = json['ItemName'];
    price = json['Price'];
    dtab = json['Dtab'];
    if (json['Options'] != null) {
      options = <Options>[];
      json['Options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Plu'] = plu;
    data['ItemName'] = itemName;
    data['Price'] = price;
    data['Dtab'] = dtab;
    if (options != null) {
      data['Options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? optionName;
  List<OptionItems>? optionItems;

  Options({this.optionName, this.optionItems});

  Options.fromJson(Map<String, dynamic> json) {
    optionName = json['OptionName'];
    if (json['OptionItems'] != null) {
      optionItems = <OptionItems>[];
      json['OptionItems'].forEach((v) {
        optionItems!.add(OptionItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OptionName'] = optionName;
    if (optionItems != null) {
      data['OptionItems'] = optionItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionItems {
  String? plu;
  String? itemName;
  int? price;
  String? dtab;

  OptionItems({this.plu, this.itemName, this.price, this.dtab});

  OptionItems.fromJson(Map<String, dynamic> json) {
    plu = json['Plu'];
    itemName = json['ItemName'];
    price = json['Price'];
    dtab = json['Dtab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Plu'] = plu;
    data['ItemName'] = itemName;
    data['Price'] = price;
    data['Dtab'] = dtab;
    return data;
  }
}
