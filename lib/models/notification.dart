import 'package:easy_localization/easy_localization.dart';

class NotificationData {
  int id;
  String title;
  String body;
  bool isRead;
  DateTime date;
  Function? onTap;

  NotificationData(
      {required this.id,
        required this.title,
        required this.body,
        required this.isRead,
        required this.date,
        this.onTap
      });

  factory NotificationData.fromJson(Map<String, dynamic> json) {

    return NotificationData(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      isRead: json["is_read"] ?? false,
      date: DateTime.parse(json['created_at']),
    );
  }
}
