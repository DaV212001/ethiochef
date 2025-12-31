import 'dart:convert';

import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/user.dart';

class CategoryService {
  Future<List<Category>> fetchCategories() async {
    try {
      // Return dummy school subjects data instead of API call
      // print('LOADING SCHOOL SUBJECTS: ${PlaceHolderData.schoolSubjects.length} subjects');
      // return PlaceHolderData.schoolSubjects;

      // Original API call code (commented out):
      // await ErrorUtil.checkConnection();
      final response =
          await http.get(Uri.parse('https://api.asteghi.com/api/subject'));
      print('CHECKING CATEGORIES: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        return responseData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error, stack) {
      Logger().t(error, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<Category>> fetchCategoriesByGrade() async {
    try {
      // Return dummy school subjects data instead of API call
      // print('LOADING SCHOOL SUBJECTS: ${PlaceHolderData.schoolSubjects.length} subjects');
      // return PlaceHolderData.schoolSubjects;

      // Original API call code (commented out):
      // await ErrorUtil.checkConnection();
      UserService userService = UserService();
      final User? user = await userService.fetchLoggedInUser();
      if (user == null) {
        return await fetchCategories();
      }
      Logger().i(user.gradeId);
      final response = await http.get(Uri.parse(
          'https://api.asteghi.com/api/subject-for-specific-grade/${user.gradeId}'));
      print('CHECKING CATEGORIES: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        return responseData.map((json) => Category.fromJson(json)).toList();
      } else {
        if (jsonDecode(response.body).containsKey('message')) {
          return [];
        }
        throw Exception(response.statusCode.toString());
      }
    } catch (error, stack) {
      Logger().t(error, stackTrace: stack);
      rethrow;
    }
  }
}
