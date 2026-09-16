import '../models/language.dart';
import '../models/user.dart';

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
  SubscriptionPlans({
    this.id,
    this.plan,
    this.price,
    this.duration,
    this.created_at,
    this.updated_at,
    this.promo_code,
    this.user,
  });

  SubscriptionPlans.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    // if (json['subscription']['plan']['en'] != null) {
    //   plan = json['plan_en'];
    // } else {
    plan = json['plan'][Language.getLocaleCode()] ?? json['plan']['en'];
    // }
    if (json.containsKey("user")) {
      user = User.fromJson(json['user']);
    }
    price = json['price'];
    duration = json['duration'] ?? 0;
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
    price = json['price'] is String
        ? int.parse(json['price'])
        : json['price'] ?? 0;
    duration = json['duration'] is String
        ? int.parse(json['duration'])
        : json['duration'] ?? 0;
    // created_at = DateTime.parse(json['created_at']);
    // updated_at = DateTime.parse(json['updated_at']);
    // promo_code = json.containsKey('promo_code')?json['subscription']['promo_code'] != []? json['subscription']['promo_code'].cast<String>() : []: null;
    print("Subscriptions done");
  }
}
