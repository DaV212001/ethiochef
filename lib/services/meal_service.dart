import 'dart:convert';


import '../constants/constants.dart';
import '../models/food.dart';
import 'authorization_service.dart';
import 'package:http/http.dart' as http;

class MealService{
  Future<List<Food>> fetchAllBreakfast() async {
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/breakfast'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromMealJson(json,1)).toList();
    } else {
      throw Exception('Failed to fetch breakfast');
    }
  }
  Future<List<Food>> fetchAllLunch() async {
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/lunch'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromMealJson(json,2)).toList();
    } else {
      throw Exception('Failed to fetch lunch');
    }
  }
  Future<List<Food>> fetchAllSuper() async {
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/super'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromMealJson(json,3)).toList();
    } else {
      throw Exception('Failed to fetch super');
    }
  }
  Future<List<Food>> fetchAllDinner() async {
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/dinner'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromMealJson(json,4)).toList();
    } else {
      throw Exception('Failed to fetch dinner');
    }
  }
}