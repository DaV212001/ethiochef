import '../models/language.dart';

class NotificationData {
  int id;
  String title;
  String body;
  bool isRead;
  DateTime date;
  Function? onTap;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.date,
    this.onTap,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    String title = '';
    String body = '';
    print(json);
    print(json["is_read"]);
    if (Language.getLocaleCode() == 'en') {
      title = json['title_en'] ?? "";
      body = json['body_en'] ?? "";
    } else if (Language.getLocaleCode() == 'am') {
      title = json['title_am'] != null ? json['title_am'] ?? "" : "";
      body = json['body_am'] != null ? json['body_am'] ?? "" : "";
    } else if (Language.getLocaleCode() == 'or') {
      title = json['title_or'] != null ? json['title_or'] ?? "" : "";
      body = json['body_or'] != null ? json['body_or'] ?? "" : "";
    } else {
      title = json['title_tr'] != null ? json['title_tr'] ?? "" : "";
      body = json['body_tr'] != null ? json['body_tr'] ?? "" : "";
    }
    return NotificationData(
      id: json["id"] ?? 0,
      title: title,
      body: body,
      isRead: json["is_read"] ?? false,
      date: DateTime.parse(json['created_at']),
    );
  }
}
