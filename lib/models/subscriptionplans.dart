import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/models/user.dart';

class SubscriptionPlans {
  int? id;
  String? plan;
  int? price;
  int? duration;
  DateTime? created_at;
  DateTime? updated_at;
  List<String>? promo_code;
  User? user;
  DateTime? lastPaidDate;
  SubscriptionPlans(
      {this.id,
      this.plan,
      this.price,
      this.duration,
      this.created_at,
      this.updated_at,
      this.promo_code,
      this.user});

  SubscriptionPlans.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    if (json['subscription']['plan_en'] != null) {
      plan = json['plan_en'];
    } else {
      plan = json['subscription']['plan'][Language.getLocaleCode()] ??
          json['subscription']['plan']['en'];
    }
    if (json.containsKey("user")) {
      user = User.fromJson(json['user']);
    }
    price = json['subscription']['price'];
    duration = json['subscription']['duration'] ?? 0;
    lastPaidDate = json.containsKey('last_paid_date')
        ? DateTime.parse(json['last_paid_date'])
        : null;
    // promo_code = json.containsKey('promo_code')?json['subscription']['promo_code'] != []? json['subscription']['promo_code'].cast<String>() : []: null;
    print("Subscriptions done");
  }

  SubscriptionPlans.fromAllSubscriptionPlansJson(Map<dynamic, dynamic> json) {
    print(json);
    id = json['id'];
    if (json.containsKey("user")) {
      user = User.fromJson(json['user']);
    }
    plan = json['plan'][Language.getLocaleCode()] ?? json['plan']['en'];
    price = json['price'];
    duration = json['duration'] ?? 0;
    created_at = DateTime.parse(json['created_at']);
    updated_at = DateTime.parse(json['updated_at']);
    // promo_code = json.containsKey('promo_code')?json['subscription']['promo_code'] != []? json['subscription']['promo_code'].cast<String>() : []: null;
    print("Subscriptions done");
  }
}

dynamic transformSubscriptionResponse(Map<String, dynamic> response) {
  final List data = response['data'];
  return data.map((item) {
    return {
      "id": item['subscription_id'],
      "plan": {
        "en": item['plan_en'],
        "am": item['plan_am'],
        "or": item['plan_or'],
        "tr": item['plan_tr'],
      },
      "price": int.tryParse(item['price'] ?? '0'),
      "duration": int.tryParse(item['duration'] ?? '0'),
      "created_at": item['created_at'] ?? DateTime.now().toIso8601String(),
      "updated_at": item['updated_at'] ?? DateTime.now().toIso8601String(),
      "last_paid_date": item['last_paid_date'],
      "user": {
        "id": item['id'],
        "first_name": item['first_name'] ?? '',
        "last_name": item['last_name'] ?? '',
        "email": item['email'],
        "phone_number": null,
        "profile_picture": item['avatar'],
        "email_verified_at": item['email_verified_at'],
        "created_at": item['created_at'],
        "updated_at": item['updated_at'],
      }
    };
  }).toList();
}
