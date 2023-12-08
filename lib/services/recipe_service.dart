import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';
class RecipeService{
  Future<void> createFood(Recipe recipe) async {
    print("==============");
    int stepNumber = 1;
    recipe.stepToCreate = {};
    for (String instruction in recipe.steps!) {
      recipe.stepToCreate?["$stepNumber"] = instruction;
      stepNumber++;
    }
    recipe.steps = null;

    print("STEPS ${recipe.stepToCreate}");
    recipe.ingredientToCreate = {};
    for (var map in recipe.ingredient!) {
      recipe.ingredientToCreate?.addAll(map);
    }
    recipe.ingredient = null;
    print("==============");

    print("INGREDIENTS ${recipe.ingredientToCreate}");
    print("==============");
print(json.encode(recipe.toServiceJson()));

    final access_token = await AuthService.getAuthorizationToken();

    var response = await http.post(Uri.parse("${Constants.url}/user/food/create"),
        headers: {
      "Content-type": "application/json",
        "Authorization": "JWT $access_token"
        },
        body: json.encode(recipe.toServiceJson()));
    print("Response Body  == ${response.body} == Response Body");
    // return response;
  }
}