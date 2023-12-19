import 'package:easy_localization/easy_localization.dart';

import '../utils/constants.dart';
import 'language.dart';

class Food {
  final int? id;
  final int subcategoriesId;
  final int categoryId;
  final Map<String, dynamic> name;
  final String? description;
  final int? mealTime;
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
    int meal = 0;

    if(json['meal_time']['breakfast']==true){
      meal = 1;
    }else if(json['meal_time']['lunch']==true){
      meal = 2;
    }else if(json['meal_time']['super']==true){
      meal = 3;
    }else{
      meal = 4;
    }
    String thumbnail = Constants.ImageAPI + i;
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'],
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
    int meal = 0;

    if(json['meal_time']['breakfast']==true){
      meal = 1;
    }else if(json['meal_time']['lunch']==true){
      meal = 2;
    }else if(json['meal_time']['super']==true){
      meal = 3;
    }else{
      meal = 4;
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'],
      description: json['description'][Language.getLocaleCode()]?? json['description']['en']??'',
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
    int meal = 0;
    if(type==1){
      meal = 1;
    }else if(type==2){
      meal = 2;
    }else if(type==3){
      meal = 3;
    }else{
      meal = 4;
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'],
      description: json['description'][Language.getLocaleCode()]?? json['name']['en'],
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
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    int meal = 0;
    if(json['breakfast']==true){
      meal = 1;
    }else if(json['lunch']==true){
      meal = 2;
    }else if(json['super']==true){
      meal = 3;
    }else{
      meal = 4;
    }
    Map<String, dynamic> name = {
      'name': '',
    };
    String description = '';
    if(Language.getLocaleCode() == 'en'){
      name['name'] = json['name_en'];
      description = json['description_en'];
    }
    else if(Language.getLocaleCode() == 'am'){
      name['name'] = json['name_am'];
      description = json['description_am'];
    }
    else if(Language.getLocaleCode() == 'tr'){
      name['name'] = json['name_tr'];
      description = json['description_tr'];
    }else{
      name['name'] = json['name_or'];
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
