import 'package:ethio_chef/models/language.dart';

class SubscriptionPlans{
  int? id;
  String? plan;
  int? price;
  int? duration;
  DateTime? created_at;
  DateTime? updated_at;
  List<String>? promo_code;


  SubscriptionPlans({
    this.id,
    this.plan,
    this.price,
    this.duration,
    this.created_at,
    this.updated_at,
    this.promo_code,
  });

  SubscriptionPlans.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    if(json['plan_en'] != null){
      plan = json['plan_en'];
    }else{
      plan = json['plan'][Language.getLocaleCode()] ?? json['plan']['en'];
    }
    id = json['id'];

    price = json['price'];
    duration = json['duration']??0;
    created_at = DateTime.parse(json['created_at']);
    updated_at = DateTime.parse(json['updated_at']);
    promo_code = json.containsKey('promo_code')?json['promo_code'] != []? json['promo_code'].cast<String>() : []: null;
    print("Subscriptions done");
}
}