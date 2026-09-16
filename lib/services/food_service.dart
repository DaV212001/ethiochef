import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/food.dart';
import '../models/language.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'authorization_service.dart';

class FoodService {
  Future<List<Food>> fetchAllFood() async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food?limit=1000&lang=${Language.getLocaleCode()}',
        ),
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
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/sub-category/$subCategoryId?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
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
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchFoodByCategoryIdPaginated(
    int categoryId,
    int pageKey,
  ) async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/category/$categoryId?page=$pageKey&limit=15&lang=${Language.getLocaleCode()}',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      rethrow;
    }
  }

  Future<List<Food>> fetchFoodByCategoryId(int categoryId) async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/category/$categoryId/?limit=1000&lang=${Language.getLocaleCode()}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Logger().d(data);
        final List<dynamic> foodList = data['data'];
        return foodList.map((json) => Food.fromJson(json)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      rethrow;
    }
  }

  Future<Food> fetchFoodById(int foodId) async {
    try {
      await ErrorUtil.checkConnection();
      final accessToken = await AuthService.getAuthorizationToken();
      String? userData = await AuthService.getUserData();
      dynamic userId;
      if (userData != null && userData != "none" && userData.isNotEmpty) {
        try {
          var userDataDecoded = jsonDecode(userData);
          userId = userDataDecoded['id'];
        } catch (e) {
          debugPrint("Error parsing userData: $e");
        }
      }
      Logger().d(userData);
      print("access_token $accessToken");
      final headers = <String, String>{};
      if (accessToken != null && accessToken != "none" && accessToken.isNotEmpty) {
        headers['Authorization'] = 'JWT $accessToken';
      }
      final targetUserId = userId ?? 1551;
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/$foodId?user_id=$targetUserId&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: headers,
      );

      print("Response body ${Language.getLocaleCode()}");
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Logger().d(data);
        final foodData = data['data'];
        print('CHECKING checkpointVIDEO FROM API: ${foodData['video']}');
        Food food = Food.fromSingleFoodJson(foodData);
        return food;
      } else {
        print('EXCEPTION FOUND HEREEEEEEEEEEE');
        throw Exception(response.statusCode.toString());
      }
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      rethrow;
    }
  }

  Future<List<Food>> fetchFoodBySearch(String query, int pageKey) async {
    try {
      await ErrorUtil.checkConnection();
      final accessToken = await AuthService.getAuthorizationToken();
      print("access_token $accessToken");
      final headers = <String, String>{};
      if (accessToken != null && accessToken != "none" && accessToken.isNotEmpty) {
        headers['Authorization'] = 'JWT $accessToken';
      }
      final response = await http.post(
        Uri.parse(
          '${Constants.url}/user/food/search-food?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: headers,
        body: {"context": query},
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
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      rethrow;
    }
  }

  Future<http.Response> likeFood(int foodId) async {
    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");
    String? userData = await AuthService.getUserData();
    var userDataDecoded = jsonDecode(userData ?? '');
    var requestBody = jsonEncode({
      "food_id": foodId,
      "user_id": userDataDecoded['id'],
    });
    print("requestBody $requestBody");
    var response = await http.post(
      Uri.parse("${Constants.url}/user/food/like"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'JWT $accessToken',
      },
      body: requestBody,
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
      headers: {'Authorization': 'JWT $accessToken'},
    );
    print("Response Body  == ${response.body} == Response Body");
    print(response.statusCode);
    return response;
  }
}
