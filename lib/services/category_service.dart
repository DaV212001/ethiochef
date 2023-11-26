import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import 'package:ethio_chef/models/category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import 'authorization_service.dart';

class CategoryService {
  Future<List<Category>> fetchAllCategories(int pageKey) async{
    if(pageKey > 15) {
      throw Exception();
    }
    await Future.delayed(Duration(seconds: 1));
    return PlaceHolderData.categories;
  }
  Future<List<Category>> fetchCategories() async {
    print("fetchCategories");
    final access_token = await AuthService.getAuthorizationToken();
    print("access_token $access_token");
    try {
      print("1");
      final response = await http.get(
        Uri.parse('${Constants.url}/user/category'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );
      print("2");
      print(response.body);
      if (response.statusCode == 200) {
        print("3");
        print(response.statusCode);
        print("4");
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        print(jsonDecode(response.body));
        // print("responseData $responseData");
        return responseData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    }
  }
}

