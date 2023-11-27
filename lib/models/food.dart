import '../constants/constants.dart';
import 'language.dart';

class Food {
  final int? id;
  final int subcategoriesId;
  final int categoryId;
  final String name;
  final String? description;
  final String? mealTime;
  final Map<String, dynamic>? stepsList;
  final Map<String, dynamic>? ingredients;
  final int? servings;
  final int? preparationTime;
  final String? posterImage;
  final String thumbnail;
  final String? video;
  bool? isLiked;
  final List<Likes>? likes;
  final List<dynamic>? comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? nextPage;
  final int? prevPage;
  final int? page;

  Food({
    this.id,
    required this.subcategoriesId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.mealTime,
    this.stepsList,
    this.ingredients,
    this.servings,
    this.preparationTime,
    this.posterImage,
    required this.thumbnail,
    this.video,
    this.likes,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.nextPage,
    this.prevPage,
    this.page,
    this.isLiked
  });
  factory Food.fromSingleFoodJson(Map<String, dynamic> json) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    print("============================== $i");
    String meal = '';
    if(json['meal_time']['breakfast']==true){
      meal = "Breakfast";
    }else if(json['meal_time']['lunch']==true){
      meal = "Lunch";
    }else if(json['meal_time']['super']==true){
      meal = "Super";
    }else{
      meal = "dinner";
    }
    String thumbnail = Constants.ImageAPI + i;
    print("thumbnail $thumbnail");
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'][Language.getLocaleCode()] == ""?json['name']["en"]:json['name'][Language.getLocaleCode()]?? json['name']["en"],
      description: json['description'][Language.getLocaleCode()]?? json['name']["en"],
      mealTime: meal,
      preparationTime: json['cooking_time'],
      servings: json['serving'],
      stepsList: json['steps'][Language.getLocaleCode()]?? json['name']["en"],
      ingredients: json['ingredients'][Language.getLocaleCode()] ?? json['name']["en"],
      thumbnail: thumbnail,
      likes: List<Likes>.from(json['likes']?.map((dynamic like) => Likes.fromFood(like)) ?? []),
      comments: json['comments'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nextPage: json['next_page'] ?? 0,
      prevPage: json['prev_page'] ?? 0,
      page: json['page'],
    );
  }
  factory Food.fromJson(Map<String, dynamic> json) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    print("thumbnail $thumbnail");
    print("============================== $i");
    String meal = '';
    if(json['meal_time']['breakfast']==true){
      meal = "Breakfast";
    }else if(json['meal_time']['lunch']==true){
      meal = "Lunch";
    }else if(json['meal_time']['super']==true){
      meal = "Super";
    }else{
      meal = "dinner";
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'][Language.getLocaleCode()]?? "no localisation",
      description: json['description'][Language.getLocaleCode()]?? "no localisation",
      mealTime: meal,
      preparationTime: json['cooking_time'],
      servings: json['serving'],
      thumbnail: thumbnail,
      likes: List<Likes>.from(json['likes']?.map((dynamic like) => Likes.fromFood(like)) ?? []),
      comments: json['comments'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nextPage: json['next_page'] ?? 0,
      prevPage: json['prev_page'] ?? 0,
      page: json['page'],
    );
  }
  factory Food.fromMealJson(Map<String, dynamic> json, int type) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    print("thumbnail $thumbnail");
    print("============================== $i");
    String meal = '';
    if(type==1){
      meal = "Breakfast";
    }else if(type==2){
      meal = "Lunch";
    }else if(type==3){
      meal = "Super";
    }else{
      meal = "dinner";
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'][Language.getLocaleCode()]?? "no localisation",
      description: json['description'][Language.getLocaleCode()]?? "no localisation",
      mealTime: meal,
      preparationTime: json['cooking_time'],
      servings: json['serving'],
      thumbnail: thumbnail,
      likes: List<Likes>.from(json['likes']?.map((dynamic like) => Likes.fromFood(like)) ?? []),
      comments: json['comments'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nextPage: json['next_page'] ?? 0,
      prevPage: json['prev_page'] ?? 0,
      page: json['page'],
    );
  }
  factory Food.fromCommentJson(Map<String, dynamic> json) {
    print("fromCommentJson $json");
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    print("thumbnail $thumbnail");
    print("============================== $i");
    String meal = '';
    if(json['breakfast']==true){
      meal = "Breakfast";
    }else if(json['lunch']==true){
      meal = "Lunch";
    }else if(json['super']==true){
      meal = "Super";
    }else{
      meal = "dinner";
    }
    String name = '';
    String description = '';
    if(Language.getLocaleCode() == 'en'){
      name = json['name_en'];
      description = json['description_en'];
    }
    else if(Language.getLocaleCode() == 'am'){
      name = json['name_am'];
      description = json['description_am'];
    }
    else if(Language.getLocaleCode() == 'tr'){
      name = json['name_tr'];
      description = json['description_tr'];
    }else{
      name = json['name_or'];
      description = json['description_or'];
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['sub_category_id'],
      categoryId: json['category_id'] ?? 0,
      name: name,
      description: description,
      mealTime: meal,
      thumbnail: thumbnail
    );
  }
}

class Likes{
  int id;
  int user_id;
  int food_id;
  Likes({
    required this.id,
    required this.user_id,
    required this.food_id,
  });
  factory Likes.fromFood(Map<String, dynamic> json) {
    return Likes(
      id: json['id'],
      user_id: json['user_id'],
      food_id: json['food_id'],
    );
  }
}
/*
*
* Map<String, String> myMap = {
    "0": "Animi est dolore ir",
    "1": "Distinctio Est ut o",
    "2": "Eaque expedita fugit",
    "3": "Provident perferend"
  };

  // Using forEach method
  print("Using forEach method:");
  myMap.forEach((key, value) {
    print("$key: $value");
  });
* */