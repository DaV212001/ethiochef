import 'package:ethio_chef/models/competitor.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language.dart';



class Competition {
  String? name_en;
  String? name_am;
  String? name_or;
  String? name_tr;
  String? description_en;
  String? description_am;
  String? description_or;
  String? description_tr;
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
        this.name_tr,
        this.name_en,
        this.name_am,
        this.name_or,
        this.description_en,
        this.description_am,
        this.description_or,
        this.description_tr,
        this.id,
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
List vote = json['vote'] as List;

var competitors = json['contestant'] as List;
    List<Competitor>? competitorss1;
if(competitors.isNotEmpty){
  competitorss1 = competitors.map((e) => Competitor.fromJson(e)).toList();
}


    DateTime fromtheresponse = DateTime.parse(json['end_date']);
DateTime now =  DateTime.now();
Duration daysleff = fromtheresponse.difference(now);
    return Competition(
        name_en: json['name_en']??"en",
        name_am: json['name_am']??'am',
        name_or: json['name_or']??'or',
        name_tr: json['name_tr']??'tr',
        description_en: json['description_en']??'en',
        description_am: json['description_am']??'am',
        description_or: json['description_or']??'or',
        description_tr: json['description_tr']??'tr',
        id: json['id'],
        image: "https://apiv2.ethiochef.com/" + json['poster_image'],
        daysLeft: daysleff.inDays,
        votes: vote.length,
        competitor: competitorss1??[],

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
      'name_en': name_en,
      'name_am': name_am,
      'name_or': name_or,
      'name_tr': name_tr,
      'description_en': description_en,
      'description_am': description_am,
      'description_or': description_or,
      'description_tr': description_tr,
      'id': id,
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
