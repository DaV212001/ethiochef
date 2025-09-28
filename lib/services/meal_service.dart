import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/food.dart';
import '../models/language.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import '../utils/place_holder_data.dart';
import 'authorization_service.dart';

class MealService {
  Future<List<Food>> fetchAllBreakfast() async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      return [];
    }
    try {
      // Return lessons with mealTime = 1 (breakfast) instead of API call
      print("LOADING BREAKFAST LESSONS");
      List<Food> allLessons = PlaceHolderData.getAllLessons();
      return allLessons.where((lesson) => lesson.mealTime == 1).toList();
      
      // Original API call code (commented out):
      // await ErrorUtil.checkConnection();
      // final access_token = await AuthService.getAuthorizationToken();
      // final response = await http.get(
      //   Uri.parse(
      //       '${Constants.url}/user/food/breakfast?&limit=1000&lang=${Language.getLocaleCode()}'),
      //   headers: {'Authorization': 'JWT $access_token'},
      // );

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   Logger().f(data);
      //   final List<dynamic> foodList = data['data'];
      //   return foodList
      //       .map((json) => Food.fromMealJson(json, 1, false))
      //       .toList();
      // } else {
      //   throw Exception(response.statusCode.toString());
      // }
    } catch (error) {
      throw Exception('Failed to fetch breakfast: $error');
    }
  }

  Future<List<Food>> fetchAllLunch() async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      return [];
    }
    try {
      // Return lessons with mealTime = 2 (lunch) instead of API call
      print("LOADING LUNCH LESSONS");
      List<Food> allLessons = PlaceHolderData.getAllLessons();
      return allLessons.where((lesson) => lesson.mealTime == 2).toList();
      
      // Original API call code (commented out):
      // await ErrorUtil.checkConnection();
      // final access_token = await AuthService.getAuthorizationToken();
      // final response = await http.get(
      //   Uri.parse(
      //       '${Constants.url}/user/food/lunch?&limit=1000&lang=${Language.getLocaleCode()}'),
      //   headers: {
      //     'Authorization': 'JWT $access_token',
      //   },
      // );

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final List<dynamic> foodList = data['data'];
      //   return foodList
      //       .map((json) => Food.fromMealJson(json, 2, false))
      //       .toList();
      // } else {
      //   throw Exception(response.statusCode.toString());
      // }
    } catch (error) {
      throw Exception('Failed to fetch lunch: $error');
    }
  }

  Future<List<Food>> fetchAllSuper() async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      return [];
    }
    try {
      // Return lessons with mealTime = 3 (supper) instead of API call
      print("LOADING SUPPER LESSONS");
      List<Food> allLessons = PlaceHolderData.getAllLessons();
      return allLessons.where((lesson) => lesson.mealTime == 3).toList();
      
      // Original API call code (commented out):
      // await ErrorUtil.checkConnection();
      // final access_token = await AuthService.getAuthorizationToken();
      // final response = await http.get(
      //   Uri.parse(
      //       '${Constants.url}/user/food/super?&limit=1000&lang=${Language.getLocaleCode()}'),
      //   headers: {
      //     'Authorization': 'JWT $access_token',
      //   },
      // );

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final List<dynamic> foodList = data['data'];
      //   return foodList
      //       .map((json) => Food.fromMealJson(json, 3, false))
      //       .toList();
      // } else {
      //   throw Exception(response.statusCode.toString());
      // }
    } catch (error) {
      throw Exception('Failed to fetch supper: $error');
    }
  }

  Future<List<Food>> fetchAllDinner() async {
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      return [];
    }
    try {
      // Return lessons with mealTime = 4 (dinner) instead of API call
      print("LOADING DINNER LESSONS");
      List<Food> allLessons = PlaceHolderData.getAllLessons();
      return allLessons.where((lesson) => lesson.mealTime == 4).toList();
      
      // Original API call code (commented out):
      // await ErrorUtil.checkConnection();
      // final access_token = await AuthService.getAuthorizationToken();
      // final response = await http.get(
      //   Uri.parse(
      //       '${Constants.url}/user/food/dinner?&limit=1000&lang=${Language.getLocaleCode()}'),
      //   headers: {
      //     'Authorization': 'JWT $access_token',
      //   },
      // );

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final List<dynamic> foodList = data['data'];
      //   return foodList
      //       .map((json) => Food.fromMealJson(json, 4, false))
      //       .toList();
      // } else {
      //   throw Exception(response.statusCode.toString());
      // }
    } catch (error) {
      throw Exception('Failed to fetch dinner: $error');
    }
  }
}
