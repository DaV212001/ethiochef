import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class PromotionService {
  Future<List<dynamic>> fetchPromotions() async {
    final response = await http.get(
      Uri.parse('${Constants.url}/user/promotion'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch promotions');
    }
  }

  Future<List<dynamic>> fetchSecondLevelPromotions() async {
    final response = await http.get(
      Uri.parse('${Constants.url}/user/second-level-promotion'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch second level promotions');
    }
  }
}
