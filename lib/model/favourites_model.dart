class Favourites {
  List<Favourites> fav = [];
  String name = "";
  String imageUrl = "";
  String restName = "";
  String location = "";

  Favourites.fromJsonList(List<dynamic> json) {
    if (json.isNotEmpty) {
      fav = json.map((e) => Favourites.fromMap(e)).toList();
    }
  }

  Favourites.fromMap(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    imageUrl = json['picture'] ?? "";
    restName = json['restName'] ?? "";
    location = json['location'] ?? "";
  }
}
