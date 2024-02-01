import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import 'dart:convert';


import '../models/language.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'authorization_service.dart';
import 'package:http/http.dart' as http;

class FoodService{
  Future<List<Food>> fetchAllFood() async {

    try{
      await ErrorUtil.checkConnection();
      final response = await http.get(
          Uri.parse('${Constants.url}/user/food?limit=1000&lang=${Language.getLocaleCode()}')
      );
      print("Response body ${Language.getLocaleCode()}");
      print(response.body);
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
          Uri.parse('${Constants.url}/user/food/sub-category/$subCategoryId?&limit=1000&lang=${Language.getLocaleCode()}')
      );
      print("Response body ${Language.getLocaleCode()}");
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
          Uri.parse('${Constants.url}/user/food/category/$categoryId?page=$pageKey&limit=1000&lang=${Language.getLocaleCode()}')
      );
      print("Response body ${Language.getLocaleCode()}");
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
          Uri.parse('${Constants.url}/user/food/category/$categoryId/?limit=1000&lang=${Language.getLocaleCode()}')
      );
      print("fetchFoodByCategoryId");
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
        Uri.parse('${Constants.url}/user/food/$foodId?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $accessToken',
        },
      );

      print("Response body ${Language.getLocaleCode()}");
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foodData = data['data'];
        print('CHECKING VIDEO FROM API: ${foodData['video']}');
        return Food.fromSingleFoodJson(foodData);
      } else {
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      rethrow;
    }
  }
  Future<List<Food>> fetchFoodBySearch(String query, int pageKey) async {
    try {
      await ErrorUtil.checkConnection();
      final accessToken = await AuthService.getAuthorizationToken();
      print("access_token $accessToken");
      final response = await http.post(
          Uri.parse('${Constants.url}/user/food/search?&limit=1000&lang=${Language.getLocaleCode()}'),
          headers: {
            'Authorization': 'JWT $accessToken',
          },
      body: {
        "context":"$query"
      }
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> products = jsonData["data"];
        final List<Food> listOfFood = products.map((food) {
          return Food.fromCommentJson(food);
        }).toList();
        return listOfFood;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<http.Response> likeFood(int foodId) async {
    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");

    var requestBody = jsonEncode({
      "food_id": foodId
    });
    print("requestBody ${{
      "food_id": foodId
    }}");
    var response = await http.post(
        Uri.parse("${Constants.url}/user/food/like"),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'JWT $accessToken',
        },
        body: jsonEncode({
          "food_id": foodId
        })
    );
    print("Response Body  == ${response.body} == Response Body");
    print(response.statusCode);
    return response;
  }
  Future<http.Response> unLikeFood(int foodId) async {
    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");
    print("unlike food");
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