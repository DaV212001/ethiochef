import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import 'dart:convert';


import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'authorization_service.dart';
import 'package:http/http.dart' as http;

class FoodService{
  Future<List<Food>> fetchAllFood() async {

    try{
      await ErrorUtil.checkConnection();
      final response = await http.get(
          Uri.parse('${Constants.url}/user/food')
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        return foodList.map((json) => Food.fromJson(json)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<List<Food>> fetchFoodBySubCategoryId(int subCategoryId) async {
    try{
      await ErrorUtil.checkConnection();
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
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      rethrow;
    }
  }
  Future<List<Food>> fetchFoodByCategoryIdPaginated(int categoryId, int pageKey) async {
    try{
      await ErrorUtil.checkConnection();
      final response = await http.get(
          Uri.parse('${Constants.url}/user/food/category/$categoryId?page=$pageKey&limit=30')
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        return foodList.map((json) => Food.fromJson(json)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      rethrow;
    }
  }
  Future<List<Food>> fetchFoodByCategoryId(int categoryId) async {
    try {
      await ErrorUtil.checkConnection();
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
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<Food> fetchFoodById(int foodId) async {
    try{
      await ErrorUtil.checkConnection();
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
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      rethrow;
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