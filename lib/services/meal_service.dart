import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/language.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'authorization_service.dart';

class MealService {
  Future<List<dynamic>> fetchAllBreakfast() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      Logger().d(Language.getLocaleCode());
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/breakfast?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Logger().d(data);
        return data['data'];
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error, stackTrace) {
      Logger().t(error, stackTrace: stackTrace);
      throw Exception('Failed to fetch breakfast: $error');
    }
  }

  Future<List<dynamic>> fetchAllLunch() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/lunch?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch lunch: $error');
    }
  }

  Future<List<dynamic>> fetchAllSuper() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/supper?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );
      Logger().d(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      throw Exception('Failed to fetch supper: $error');
    }
  }

  Future<List<dynamic>> fetchAllDinner() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/food/dinner?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch dinner: $error');
    }
  }
}
