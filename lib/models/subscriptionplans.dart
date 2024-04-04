import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/models/user.dart';

class SubscriptionPlans{
  int? id;
  String? plan;
  int? price;
  int? duration;
  DateTime? created_at;
  DateTime? updated_at;
  List<String>? promo_code;
  User? user;

  SubscriptionPlans({
    this.id,
    this.plan,
    this.price,
    this.duration,
    this.created_at,
    this.updated_at,
    this.promo_code,
    this.user
  });

  SubscriptionPlans.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    if(json['subscription']['plan_en'] != null){
      plan = json['plan_en'];
    }else{
      plan = json['subscription']['plan'][Language.getLocaleCode()] ?? json['subscription']['plan']['en'];
    }
    if(json.containsKey("user")) {
      user = User.fromJson(json['user']);
    }
    price = json['subscription']['price'];
    duration = json['subscription']['duration']??0;
    // promo_code = json.containsKey('promo_code')?json['subscription']['promo_code'] != []? json['subscription']['promo_code'].cast<String>() : []: null;
    print("Subscriptions done");
}

  SubscriptionPlans.fromAllSubscriptionPlansJson(Map<dynamic, dynamic> json) {
    print(json);
    id = json['id'];
    if(json.containsKey("user")) {
      user = User.fromJson(json['user']);
    }
    plan = json['plan'][Language.getLocaleCode()] ?? json['plan']['en'];
    price = json['price'];
    duration = json['duration']??0;
    created_at = DateTime.parse(json['created_at']);
    updated_at = DateTime.parse(json['updated_at']);
    // promo_code = json.containsKey('promo_code')?json['subscription']['promo_code'] != []? json['subscription']['promo_code'].cast<String>() : []: null;
    print("Subscriptions done");
  }
}