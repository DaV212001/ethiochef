import '../utils/constants.dart';

class PaymentMethods{
  int id;
  String bank_name;
  String? image;

  PaymentMethods({
    required this.id,
    required this.bank_name,
    this.image
      });

  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
  return PaymentMethods(
  id: json['id'],
  bank_name: json['bank_name'],
      image:thumbnail
  );
  }
}