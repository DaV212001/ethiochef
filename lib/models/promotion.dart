import '../utils/constants.dart';

class Promotion {
  final int id;
  final String name;
  final String image;

  const Promotion({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }

    String image = ((json['image'] ?? "") as String).replaceAll('\\', '');
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    return Promotion(
        id: json.containsKey('id') ? json['id'] : 0,
        name: "Promotion" ?? "",
        image: image ?? "");
  }
}
