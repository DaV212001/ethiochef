import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/language.dart';

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
    String title = '';
    String body = '';
    if(Language.getLocaleCode() == 'en'){
      title = json['title_en'] ?? "";
      body = json['body_en'] ?? "";
    }else if(Language.getLocaleCode() == 'am'){
      title = json['title_am'] != null? json['title_en']??"":"";
      body = json['body_am'] != null? json['body_en']??"":"";
    }else if(Language.getLocaleCode() == 'or'){
      title = json['title_or'] != null? json['title_en']??"":"";
      body = json['body_or'] != null? json['body_en']??"":"";
    }else{
      title = json['title_tr'] != null? json['title_en']??"":"";
      body = json['body_tr'] != null? json['body_en']??"":"";
    }
    print("===================================================");
    print(json["id"]);
    print(json["is_read"]);
    print("===================================================");
    return NotificationData(
      id: json["id"] ?? 0,
      title: title,
      body: body,
      isRead: json["is_read"] ?? false,
      date: DateTime.parse(json['created_at']),
    );
  }
}
