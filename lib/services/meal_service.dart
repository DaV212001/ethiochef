import 'dart:convert';


import '../models/language.dart';
import '../utils/constants.dart';
import '../models/food.dart';
import '../utils/error_util.dart';
import 'authorization_service.dart';
import 'package:http/http.dart' as http;

class MealService{
  Future<List<Food>> fetchAllBreakfast() async {
    try{
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/breakfast?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $access_token'
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        return foodList.map((json) => Food.fromMealJson(json,1, false)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      throw Exception('Failed to fetch breakfast: $error');
    }
  }
  Future<List<Food>> fetchAllLunch() async {
    try{
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/lunch?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        return foodList.map((json) => Food.fromMealJson(json,2, false)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      throw Exception('Failed to fetch lunch: $error');
    }
  }
  Future<List<Food>> fetchAllSuper() async {
   try{
     await ErrorUtil.checkConnection();
     final access_token = await AuthService.getAuthorizationToken();
     final response = await http.get(
       Uri.parse('${Constants.url}/user/food/super?&limit=1000&lang=${Language.getLocaleCode()}'),
       headers: {
         'Authorization': 'JWT $access_token',
       },
     );

     if (response.statusCode == 200) {
       final data = jsonDecode(response.body);
       final List<dynamic> foodList = data['data'];
       return foodList.map((json) => Food.fromMealJson(json,3, false)).toList();
     } else {
       throw Exception(response.statusCode.toString());
     }
   }catch (error) {
     throw Exception('Failed to fetch supper: $error');
   }
  }
  Future<List<Food>> fetchAllDinner() async {
    try{
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/dinner?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        return foodList.map((json) => Food.fromMealJson(json,4, false)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    }catch (error) {
      throw Exception('Failed to fetch dinner: $error');
    }
  }
}