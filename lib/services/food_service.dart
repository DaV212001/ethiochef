import 'dart:convert';

import 'package:ethio_chef/models/food.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/language.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'authorization_service.dart';

class FoodService {
  Future<List<Food>> fetchAllFood() async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      throw Exception("coming_soon");
    }

    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(Uri.parse(
          '${Constants.url}/user/food?limit=1000&lang=${Language.getLocaleCode()}'));
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
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      throw Exception("coming_soon");
    }
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(Uri.parse(
          '${Constants.url}/user/food/sub-category/$subCategoryId?&limit=1000&lang=${Language.getLocaleCode()}'));
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

  Future<List<Food>> fetchFoodByCategoryIdPaginated(
      int categoryId, int pageKey) async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      throw Exception("coming_soon");
    }
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(Uri.parse(
          '${Constants.url}/user/food/category/$categoryId?page=$pageKey&limit=1000&lang=${Language.getLocaleCode()}'));
      print("Response body ${Language.getLocaleCode()}");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        var foodReturned = foodList.map((json) => Food.fromJson(json)).toList();
        foodReturned.removeWhere(
            (element) => element.name == null || element.name == "null");
        return foodReturned;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Food>> fetchFoodByCategoryId(int categoryId) async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      throw Exception("coming_soon");
    }
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(Uri.parse(
          '${Constants.url}/user/food/category/$categoryId/?limit=1000&lang=${Language.getLocaleCode()}'));
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

  Map<String, dynamic> transformSteps(List<dynamic> stepList) {
    // Initialize the result object with empty maps for each language
    Map<String, Map<String, String>> steps = {
      'am': {},
      'en': {},
      'or': {},
      'tg': {},
      'so': {},
    };

    // Loop through each step in the list
    for (var i = 0; i < stepList.length; i++) {
      final step = stepList[i];

      // Add the step to each language map using the index as the key
      steps['am']![i.toString()] = step['step_am'];
      steps['en']![i.toString()] = step['step_en'];
      steps['or']![i.toString()] = step['step_or'];
      steps['tg']![i.toString()] = step['step_tg'];
      steps['so']![i.toString()] = step['step_so'];
    }

    // Return the final object
    return {'steps': steps};
  }

  Map<String, dynamic> transformIngredients(List<dynamic> stepList) {
    // Initialize the result object with empty maps for each language
    Map<String, Map<String, String>> steps = {
      'am': {},
      'en': {},
      'or': {},
      'tg': {},
      'so': {},
    };

    // Loop through each step in the list
    for (var i = 0; i < stepList.length; i++) {
      final step = stepList[i];

      // Add the step to each language map using the index as the key
      steps['am']![i.toString()] = step['ingredient_am'];
      steps['en']![i.toString()] = step['ingredient_en'];
      steps['or']![i.toString()] = step['ingredient_or'];
      steps['tg']![i.toString()] = step['ingredient_tg'];
      steps['so']![i.toString()] = step['ingredient_so'];
    }

    // Return the final object
    return {'ingredients': steps};
  }

  Future<Food> fetchFoodById(int foodId) async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      throw Exception("coming_soon");
    }

    try {
      await ErrorUtil.checkConnection();
      final accessToken = await AuthService.getAuthorizationToken();
      print("access_token $accessToken");
      final response = await http.get(
        Uri.parse(
            'https://adminv2.ethiochef.com/api/food/$foodId?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $accessToken',
        },
      );
      Logger().i(jsonDecode(response.body));
      var steps;
      var ingredients;
      try {
        steps = await http.get(
          Uri.parse('https://adminv2.ethiochef.com/api/steps/${foodId}'),
          headers: {
            'Authorization': 'JWT $accessToken',
          },
        );
        Logger().i(steps.body);
        ingredients = await http.get(
          Uri.parse('https://adminv2.ethiochef.com/api/ingrediant/${foodId}'),
          headers: {
            'Authorization': 'JWT $accessToken',
          },
        );
        Logger().i(jsonDecode(ingredients.body)['data']);
      } on Exception catch (error, stack) {
        Logger().t(error, stackTrace: stack);
        rethrow;
      }

      print("Response body ${Language.getLocaleCode()}");
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foodData = data['data'][0];
        final stepsData = jsonDecode(steps.body);
        final ingredientsData = jsonDecode(ingredients.body);
        print('CHECKING checkpointVIDEO FROM API: ${foodData['video']}');
        Food food = Food.fromSingleFoodJson(
            foodData,
            transformSteps(stepsData['data'])['steps'],
            transformIngredients(ingredientsData['data'])['ingredients']);
        return food;
      } else {
        print('EXCEPTION FOUND HEREEEEEEEEEEE');
        throw Exception(response.statusCode.toString());
      }
    } catch (error, stack) {
      Logger().t(error, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<Food>> fetchFoodBySearch(String query, int pageKey) async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      throw Exception("coming_soon");
    }
    try {
      await ErrorUtil.checkConnection();
      final accessToken = await AuthService.getAuthorizationToken();
      print("access_token $accessToken");
      final response = await http.post(
          Uri.parse(
              '${Constants.url}/user/food/search?&limit=1000&lang=${Language.getLocaleCode()}'),
          headers: {
            'Authorization': 'JWT $accessToken',
          },
          body: {
            "context": "$query"
          });
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

    var requestBody = jsonEncode({"food_id": foodId});
    print("requestBody $requestBody");
    var response = await http.post(Uri.parse("${Constants.url}/user/food/like"),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'JWT $accessToken',
        },
        body: requestBody);
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
