import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../models/promotion.dart';
class PromotionService{
  Future<List<Promotion>> fetchPromotions() async {
    final response = await http.get(Uri.parse('${Constants.url}/user/promotion'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final promotions = data['data'] as List<dynamic>;
      return promotions.map((promotion) => Promotion.fromJson(promotion)).toList();
    } else {
      throw Exception('Failed to fetch promotions');
    }
  }
}