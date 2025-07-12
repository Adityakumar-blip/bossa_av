class Notifications {
  late List<NotificationsList> notifications;
  Notifications({required this.notifications});

  Notifications.fromJson(Map<String, dynamic> json) {
    List notificationList = json['data'] as List;

    notifications = notificationList
        .map((item) => NotificationsList.fromJson(item))
        .toList();

    // print("Notifications List");
    // print(notifications);
  }
}

class NotificationsList {
  late String id;
  late String title;
  late String message;
  late String date;
  late String read;
  late String link;

  NotificationsList(
      {required this.id,
      required this.title,
      required this.message,
      required this.date,
      required this.read,
      required this.link});

  NotificationsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    date = json['created_at'];
    read = json['is_read'];
    link = json['link'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    data['created_at'] = date;
    data['is_read'] = read;
    data['link'] = link;

    return data;
  }
}
