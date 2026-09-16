import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/language.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';

class CategoryService {
  Future<List<dynamic>> fetchCategories() async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse(
          '${Constants.url}/user/category?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
      );
      print('CHECKING CATEGORIES: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
}
