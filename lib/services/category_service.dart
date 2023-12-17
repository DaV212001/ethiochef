import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

import 'package:ethio_chef/models/category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/error_util.dart';
class CategoryService {
  Future<List<Category>> fetchCategories() async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
          Uri.parse('${Constants.url}/user/category')
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        return responseData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
}

