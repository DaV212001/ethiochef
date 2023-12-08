import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import 'dart:convert';


import '../utils/constants.dart';
import 'authorization_service.dart';
import 'package:http/http.dart' as http;

class FoodService{
  Future<List<Food>> fetchDishesForCategory(int id,int pageKey) async{
    if(pageKey > 5) {
      throw Exception();
    }
    await Future.delayed(Duration(seconds: 1));
    return PlaceHolderData.dishes;
  }
  Future<List<Food>> fetchAllFood() async {
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch food');
    }
  }
  Future<List<Food>> fetchFoodBySubCategoryId(int subCategoryId) async {
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/sub-category/$subCategoryId')
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch food');
    }
  }
  Future<List<Food>> fetchFoodByCategoryIdPaginated(int categoryId, int pageKey) async {
    final response = await http.get(
        Uri.parse('${Constants.url}/user/food/category/$categoryId?page=${pageKey}&limit=15')
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch food');
    }
  }
  Future<List<Food>> fetchFoodByCategoryId(int categoryId) async {
    final response = await http.get(
        Uri.parse('${Constants.url}/user/food/category/$categoryId')
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> foodList = data['data'];
      return foodList.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch food');
    }
  }
  Future<Food> fetchFoodById(int foodId) async {

    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");

    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/$foodId'),
      headers: {
        'Authorization': 'JWT $accessToken',
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final foodData = data['data'];
      return Food.fromSingleFoodJson(foodData);
    } else {
      throw Exception('Failed to fetch food');
    }
  }
  Future<http.Response> likeFood(int foodId) async {
    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");

    var requestBody = jsonEncode({
      "food_id": foodId
    });
    var response = await http.post(Uri.parse("${Constants.url}/user/food/like"),
        headers: {
          'Authorization': 'JWT $accessToken',
        },
        body: requestBody
    );
    print("Response Body  == ${response.body} == Response Body");
    print(response.statusCode);
    return response;
  }
  Future<http.Response> unLikeFood(int foodId) async {
    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");

    var response = await http.delete(
        Uri.parse("${Constants.url}/user/food/unlike/$foodId"),
        headers: {
          'Authorization': 'JWT $accessToken',
        });
    print("Response Body  == ${response.body} == Response Body");
    print(response.statusCode);
    return response;
  }
}