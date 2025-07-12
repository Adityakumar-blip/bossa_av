import 'dart:convert';

class RestaurantModel {
  var id;
  var resName;
  var location;
  var rating;
  var phoneNo;
  late List openingTime;
  late List closingTime;
  var rateLink;
  var image;
  RestaurantModel(
      {this.id,
      this.resName,
      this.location,
      this.rating,
      this.image,
      this.rateLink});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    print("json============ $json");
    List openingTimeList = jsonDecode(json['opening_time']) as List;
    List closingTimeList = jsonDecode(json['closing_time']) as List;

    id = json['id'];
    resName = json['name'];
    location = json['location'];
    openingTime = openingTimeList;
    //openingTimeList.map((item) => ClosingOpeningList()).toList();
    closingTime = closingTimeList;
    //closingTimeList.map((item) => ClosingOpeningList()).toList();
    rating = json['rating'];
    image = json['logo'];
    phoneNo = json['contact'];
    rateLink = json['rate_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['resName'] = resName;
    data['location'] = location;
    data['openingTime'] = openingTime;
    data['closingTime'] = closingTime;
    data['rating'] = rating;
    data['image'] = image;
    data['phoneNo'] = phoneNo;
    data['rateLink'] = rateLink;

    return data;
  }
}
