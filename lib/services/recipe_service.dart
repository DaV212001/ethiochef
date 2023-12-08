import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';
class RecipeService{
  Future<void> createFood(Recipe recipe) async {
var body = jsonEncode(recipe.toServiceJson());
    print("==== $body ====");
    final access_token = await AuthService.getAuthorizationToken();
    print("====== $access_token ========");
    var response = await http.post(
        Uri.parse("${Constants.url}/user/food-video/create"),
        headers: {
        'Accept': 'application/json',
        "Authorization": "JWT $access_token"
        },
        body: body
    );
    print("Response statusCode  == ${response.statusCode} == Response statusCode");
    print("Response Body  == ${response.body} == Response Body");
    // return response;
  }
}