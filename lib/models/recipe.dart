import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recipe {
  String? name;
  String? description;
  String? prepTime;
  String? servingSize;
  List<String>? steps;
  File? image;
  File? video;
  List<Map<String, String>>? ingredient = [];

  Recipe(
      {
        this.ingredient,
        this.name,
        this.description,
        this.steps,
        this.prepTime,
        this.servingSize,
        this.image,
        this.video
      });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    print("json $json");
    String? imagePath = json['image'];
    String videoPath = json['video'];
    File? image;
    File? video;
    if (imagePath != null) {
      image = File(imagePath);
    }
    if(videoPath != null){
      video = File(videoPath);
    }
    final ingredients = json['ingredient'] as List<dynamic>?;

    final ingredientList = ingredients?.map((ingredient) {
      return Map<String, String>.from(ingredient as Map<dynamic, dynamic>);
    }).toList() ?? [];

    return Recipe(
      name: json['name'],
      description: json['description'],
      prepTime: json['prepTime'],
      servingSize: json['servingSize'],
      steps: List<String>.from(json['steps']),
      image: image,
      ingredient: ingredientList,
      video: video
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'prepTime': prepTime,
      'servingSize': servingSize,
      'steps': steps,
      'image': image?.path, // Store the file path instead of the File object
      'ingredient': ingredient ?? [],
      'video': video?.path
    };
  }

  static List<Recipe> savedRecipes = [];

  static void addRecipe(Recipe recipe) {
    savedRecipes.add(recipe);
    saveRecipesToSharedPrefs();
  }


  static List<Recipe> getSavedRecipes() {

    return savedRecipes;
  }
  static void deleteRecipe(Recipe recipe) {
    savedRecipes.remove(recipe);
    saveRecipesToSharedPrefs();
  }
  static void saveRecipesToSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = json
        .encode(Recipe.savedRecipes.map((recipe) => recipe.toJson()).toList());
    await sharedPreferences.setString('savedRecipes', jsonString);
  }

  static Future<List<Recipe>> loadRecipesFromSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString('savedRecipes') ?? '[]';
    final recipes = json.decode(jsonString) as List<dynamic>;
    return recipes.map((recipe) => Recipe.fromJson(recipe)).toList();
  }
}
