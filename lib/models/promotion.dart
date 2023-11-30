import 'dart:convert';
import 'package:http/http.dart' as http;

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
    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    print("thumbnail $thumbnail");
    print("============================== $i");
    return Promotion(
      id: json['id'] as int,
      name: thumbnail,
      image: json['image'] as String,
    );
  }
}