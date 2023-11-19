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

  SubscriptionPlans.fromJson(Map<dynamic, dynamic> json) {
    print('CHECK $json');
    print('check ${json['plan']}');
    id = json['id'];
    plan = json['plan'];
    price = json['price'];
    print('SubscriptionPlans object: ${this.plan}');
    duration = json['duration']!=null? DateTime.parse(json['duration']):null;
    print('SubscriptionPlans object1: ${this.plan}');
    created_at = DateTime.parse(json['created_at']);
    print('SubscriptionPlans object2: ${this.plan}');
    updated_at = DateTime.parse(json['updated_at']);
    print('SubscriptionPlans object3: ${this.plan}');
    promo_code = json.containsKey('promo_code')?json['promo_code'] != []? json['promo_code'].cast<String>() : []: null;

    print('SubscriptionPlans object4: ${this.plan}');
}
}