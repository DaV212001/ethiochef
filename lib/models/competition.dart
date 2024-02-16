import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import 'contestants.dart';
import 'language.dart';



class Competition {
  String? name;
  String? description;
  String? prepTime;
  String? servingSize;
  String? videoFromContestant;
  String? imageFromContestant;
  List<String>? steps;
  File? imageFile;
  File? videoFile;
  List<Map<String, String>>? ingredient = [];
  String? image;
  String? video;
  int? votes;
  int? daysLeft;
  List<Contestant>? competitor;
  int? id;
  String? winner;
  Competition(
      {
        this.ingredient,
        this.name,
        this.description,
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
        this.videoFile,
        this.videoFromContestant,
        this.imageFromContestant,
        this.winner
      });

  factory Competition.fromJson(Map<String, dynamic> json) {
    print("==== ${json['contestant']}");
    print("json $json");
    String? imagePath = json['image'];
    String videoPath = json['video'];
    print(json['video']);
    print("'''''''''''''''''''''''''''''''''''''''''''''''''''''''''");
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
    List<Contestant>? competitorss1;
if(competitors.isNotEmpty){
  competitorss1 = competitors.map((e) => Contestant.fromJson(e)).toList();
}


      DateTime fromtheresponse = DateTime.parse(json['end_date']);
  DateTime now =  DateTime.now();
  Duration daysleff = fromtheresponse.difference(now);
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String poster_image = json['poster_image'];
    String i = clearPath(poster_image);
    String thumbnail = Constants.ImageAPI + i;

    return Competition(
        name: json['name'][Language.getLocaleCode()]??json['name']['en'],
        description: json['description'][Language.getLocaleCode()]??json['description']['en'],
        id: json['id'],
        image: thumbnail,
        daysLeft: daysleff.inDays,
        votes: vote.length,
        competitor: competitorss1??[],
        imageFromContestant: poster_image,
        videoFromContestant: json['video'],
        winner: json['winner'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_en': name,
      'description_en': description,
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
