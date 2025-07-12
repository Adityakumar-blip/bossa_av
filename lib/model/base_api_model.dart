class BaseApiModel {
  String? status;
  // String message;

  Map<String, dynamic>? data;

  BaseApiModel();

  BaseApiModel.fromJson(Map<String, dynamic> json) {
    status = json["status"] as String;
    //  message = json["message"] as String;
    if (json["data"] == null) {
      data = null;
    } else {
      data = json["data"] as Map<String, dynamic>;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    //   data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
