import 'package:ethio_chef/models/competitor.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language.dart';



class Competition {
  String? name;
  String? description;
  String? prepTime;
  String? servingSize;
  List<String>? steps;
  File? imageFile;
  File? videoFile;
  List<Map<String, String>>? ingredient = [];
  String? image;
  String? video;
  int? votes;
  int? daysLeft;
  List<Competitor>? competitor;
  int? id;

  // poster_image
  // video
  // start_date
  // end_date
  // winner
  // vote
  // contest_like
  // contestant
  // created_at
  // updated_at
  Competition(
      {
        this.ingredient,
        this.name,
        this.description,
        this.steps,
        this.prepTime,
        this.servingSize,
        this.imageFile,
        this.video,
        this.image,
        this.daysLeft,
        this.votes,
        this.competitor,
        this.videoFile
      });

  factory Competition.fromJson(Map<String, dynamic> json) {
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



    DateTime fromtheresponse = DateTime.parse(json['end_date']);
DateTime now =  DateTime.now();
Duration daysleff = fromtheresponse.difference(now);
    return Competition(
        name: json['name_${Language.getLocaleCode()}']??'sampleunkownlang',
        description: json['name_${Language.getLocaleCode()}']??'sampleunkownlang',
        image: "https://apiv2.ethiochef.com/" + json['poster_image'],
        daysLeft: daysleff.inDays
        // prepTime: json['prepTime'],
        // servingSize: json['servingSize'],
        // steps: List<String>.from(json['steps']),
        // imageFile: image,
        // ingredient: ingredientList,
        // videoFile: video
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'prepTime': prepTime,
      'servingSize': servingSize,
      'steps': steps,
      'image': imageFile?.path, // Store the file path instead of the File object
      'ingredient': ingredient ?? [],
      'video': videoFile?.path
    };
  }

  static List<Competition> savedCompetitions = [];

  static void addCompetition(Competition recipe) {
    savedCompetitions.add(recipe);
    saveCompetitionsToSharedPrefs();
  }


  static List<Competition> getSavedCompetitions() {

    return savedCompetitions;
  }
  static void deleteCompetition(Competition recipe) {
    savedCompetitions.remove(recipe);
    saveCompetitionsToSharedPrefs();
  }
  static void saveCompetitionsToSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = json
        .encode(Competition.savedCompetitions.map((recipe) => recipe.toJson()).toList());
    await sharedPreferences.setString('savedCompetitions', jsonString);
  }

  static Future<List<Competition>> loadCompetitionsFromSharedPrefs() async {

    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString('savedCompetitions') ?? '[]';
    final recipes = json.decode(jsonString) as List<dynamic>;
    return recipes.map((recipe) => Competition.fromJson(recipe)).toList();
  }
}
