import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';
class RecipeService{
  Future<http.Response> createFood(Recipe recipe) async {
    int stepNumber = 1;

    for (String instruction in recipe.steps!) {
      recipe.stepToCreate?["$stepNumber"] = instruction;
      stepNumber++;
    }

    print("STEPS ${recipe.stepToCreate}");
    List<Map<String, String>> listOfMaps = [
      {"1": "1/2 kg ground beef"},
      {"2": "5 thinly sliced mortadello"},
      {"3": "3 cups of flour"},
      {"4": "5 thinly sliced cheese"},
    ];
    for (var map in recipe.ingredient!) {
      recipe.ingredientToCreate?.addAll(map);
    }

    print("INGREDIENTS ${recipe.ingredient}");

    final access_token = await AuthService.getAuthorizationToken();

    var response = await http.post(Uri.parse("${Constants.url}/user/food/create"),
        headers: {
      "Content-type": "application/json",
        "Authorization": "JWT $access_token"
        },
        body: json.encode(recipe.toJson()));
    print("Response Body  == ${response.body} == Response Body");
    return response;
  }
}