import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../models/submitted_recipe.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';

class RecipeService{
    Future<http.Response> createFood(Recipe recipe) async {
        final access_token = await AuthService.getAuthorizationToken();
        print(recipe);
        var request = http.MultipartRequest(
            'POST',
            Uri.parse("${Constants.url}/user/food-video/create"),
        );
        request.headers['Authorization'] = 'JWT $access_token';
        print(recipe.steps);
        String steps = jsonEncode(recipe.stepToCreate);
        String ingredient = jsonEncode(recipe.ingredientToCreate);
        request.fields['title'] = recipe.name!;
        request.fields['description'] = recipe.description!;
        request.fields['cooking_time'] = "0";
        request.fields['serving'] = "0";
        request.fields['steps'] = steps;
        request.fields['ingredients'] = ingredient;
        request.fields['video'] = recipe.videoUrl!;
            print("Uploading 3");
            var fileStream = http.ByteStream(recipe.image!.openRead());
            var length = await recipe.image?.length();

            var multipartFile = http.MultipartFile(
                'image',
                fileStream,
                length!,
                filename: recipe.image?.path.split('/').last,
            );
            print("Uploading 4");

            request.files.add(multipartFile);
            print("Uploading 5");


        print("Uploading 6");
        var response = await request.send();

        print("Uploading 7");
        var responseString = await response.stream.bytesToString();

        print("Response Body  == ${response.statusCode} == Response Body");
        print("Response Body  == $responseString == Response Body");

        return http.Response(responseString, response.statusCode);
    }
    Future<void> deleteUserFoodRecipe(int id) async {
        print("id $id");
        try {
            final access_token = await AuthService.getAuthorizationToken();
            final response = await http.post(
                Uri.parse(
                    '${Constants.url}/user/food-video/delete/$id'),
                headers: {
                    'Authorization': 'JWT $access_token'
                });
            print("response.body== ${response.body}==response.body");
            print("response.statusCode ${response.statusCode}");
            if (response.statusCode == 200) {
                print(response.body);
            } else {
                throw Exception(response.statusCode.toString());
            }
        } catch (error) {
            rethrow;
        }
    }
    Future<List<MySubmittedRecipe>> fetchDishes() async {

        final access_token = await AuthService.getAuthorizationToken();
        final response = await http.get(
            Uri.parse('${Constants.url}/user/food-video/'),
            headers: {
                'Authorization': 'JWT $access_token'
            },);
        print(response.body);
        if (response.statusCode == 200) {
            Map<String, dynamic> jsonData = jsonDecode(response.body);
            List<dynamic> dishesData = jsonData['data'];

            List<MySubmittedRecipe> dishes = dishesData.map((dishData) => MySubmittedRecipe.fromJson(dishData)).toList();
            return dishes;
        } else {
            throw Exception('Failed to fetch dishes');
        }
    }

}