import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import 'dart:convert';

import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import '../constants/constants.dart';
import 'authorization_service.dart';
import 'package:http/http.dart' as http;

class FoodService{
 // https://apiv2.ethiochef.com/user/food
  Future<List<Food>> fetchDishesForCategory(int id,int pageKey) async{
    if(pageKey > 5) {
      throw Exception();
    }
    await Future.delayed(Duration(seconds: 1));
    return PlaceHolderData.dishes;
  }
  Future<List<Food>> fetchAllFood() async {
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
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
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/food/sub-category/$subCategoryId'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
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
  Future<http.Response> createComment(String comment, int foodId) async {
    var response = await http.post(Uri.parse("${Constants.url}/user/signup"),
        headers: {"Content-type": "application/json"},
        body: {
          "food_id": foodId,
          "comment": comment
        }
    );
    print("Response Body  == ${response.body} == Response Body");
    print(response.statusCode);
    return response;
  }
}
