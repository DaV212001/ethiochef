class SubscriptionPlans{
  int? id;
  String? plan;
  int? price;
  DateTime? duration;
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

  SubscriptionPlans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plan = json['plan'];
    price = json['price'];
    duration = json['duration']!=null? DateTime.parse(json['duration']):null;
    created_at = DateTime.parse(json['created_at']);
    updated_at = DateTime.parse(json['updated_at']);
    promo_code = json['promo_code'] != []? json['promo_code'].cast<String>() : [];
}
}