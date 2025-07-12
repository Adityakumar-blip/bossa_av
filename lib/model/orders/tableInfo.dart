class TableInfo {
  String? invoiceRef;
  int? tableCovers;
  String? stationId;
  bool? ignoreNoStock;
  String? tableNumber;
  String? waiterNumber;
  String? transactionId;
  String? proformaRef;

  TableInfo(
      {this.invoiceRef,
      this.tableCovers,
      this.stationId,
      this.ignoreNoStock,
      this.tableNumber,
      this.waiterNumber,
      this.transactionId,
      this.proformaRef});

  TableInfo.fromJson(Map<String, dynamic> json) {
    invoiceRef = json['invoiceRef'];
    tableCovers = json['tableCovers'];
    stationId = json['stationId'];
    ignoreNoStock = json['ignoreNoStock'];
    tableNumber = json['tableNumber'];
    waiterNumber = json['waiterNumber'];
    transactionId = json['transactionId'];
    proformaRef = json['proformaRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceRef'] = invoiceRef;
    data['tableCovers'] = tableCovers;
    data['stationId'] = stationId;
    data['ignoreNoStock'] = ignoreNoStock;
    data['tableNumber'] = tableNumber;
    data['waiterNumber'] = waiterNumber;
    data['transactionId'] = transactionId;
    data['proformaRef'] = proformaRef;
    return data;
  }
}
