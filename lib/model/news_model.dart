class News {
  List<NewsList> newsData;

  News(List<dynamic> data)
      : newsData = data.map((item) {
          if (item is Map<String, dynamic>) {
            return NewsList.fromJson(item);
          } else if (item is NewsList) {
            return item;
          } else {
            // Handle other types if needed
            return NewsList.fromJson(item.toJson());
          }
        }).toList();

  // Alternative constructor for empty list
  News.empty() : newsData = [];

  // Factory constructor for API response
  factory News.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'success' && json['data'] != null) {
      List<dynamic> dataList = json['data'];
      return News(dataList);
    } else {
      return News.empty();
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': 'success',
      'data': newsData.map((item) => item.toJson()).toList(),
    };
  }
}

class NewsList {
  String? id;
  String? title;
  String? details;
  String? image;
  String? promotionType;
  String? restaurant;

  NewsList({
    this.id,
    this.title,
    this.details,
    this.image,
    this.promotionType,
    this.restaurant,
  });

  factory NewsList.fromJson(Map<String, dynamic> json) {
    return NewsList(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      details: json['details']?.toString(),
      image: json['image']?.toString(),
      promotionType: json['promotion_type']?.toString(),
      restaurant: json['restaurant']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'image': image,
      'promotion_type': promotionType,
      'restaurant': restaurant,
    };
  }
}
