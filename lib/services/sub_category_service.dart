import 'dart:convert';

import '../utils/constants.dart';
import '../models/sub_category.dart';
import 'package:http/http.dart' as http;

import '../utils/error_util.dart';
import 'authorization_service.dart';

class SubCategoryService{
  Future<List<SubCategory>> fetchSubCategoriesByCategoryId(int categoryId) async {
      try{
        await ErrorUtil.checkConnection();
        final access_token = await AuthService.getAuthorizationToken();
        print("access_token $access_token");

          final response = await
          http.get(Uri.parse('${Constants.url}/user/sub-category/category/$categoryId'),
            headers: {
              'Authorization': 'JWT $access_token',
            },
          );

          if (response.statusCode == 200) {
            final List<dynamic> responseData = jsonDecode(response.body)['data'];
            return responseData.map((json) => SubCategory.fromJson(json)).toList();
          } else {
            throw Exception(response.statusCode.toString());
          }
      }catch (error) {
        throw Exception('Failed to fetch subcategory by id: $error');
      }
  }
  Future<List<SubCategory>> fetchAllSubCategories() async {
    try{
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      print("access_token $access_token");
        final response = await http.get(
          Uri.parse('${Constants.url}/user/sub-category'),
          headers: {
            'Authorization': 'JWT $access_token',
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          final List<dynamic> responseData = jsonDecode(response.body)['data'];
          return responseData.map((json) => SubCategory.fromJson(json)).toList();
        } else {
          throw Exception(response.statusCode.toString());
        }
    }catch (error) {
      throw Exception('Failed to fetch all subcategories: $error');
    }
  }
}