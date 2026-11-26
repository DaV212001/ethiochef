import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import 'language.dart';

class Food {
  final int? id;
  final int subcategoriesId;
  final int categoryId;
  final String? name;
  final String? Name;
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
  final List<Food>? related_recipe;
  Food({
    this.id,
    required this.subcategoriesId,
    required this.categoryId,
    required this.name,
    this.Name,
    required this.description,
    required this.mealTime,
    this.related_recipe,
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
    this.isLiked,
  });

  bool get hasVideo => video != null && video!.trim().isNotEmpty;

  static String? parseVideoUrl(dynamic raw) {
    if (raw == null) return null;
    if (raw is num && raw <= 0) return null;
    if (raw is bool && !raw) return null;

    String str = raw.toString().trim();
    if (str.isEmpty) return null;

    final lower = str.toLowerCase();
    // Falsy or placeholder values commonly returned by APIs/databases
    if (lower == 'null' ||
        lower == '0' ||
        lower == '-1' ||
        lower == 'false' ||
        lower == 'none' ||
        lower == 'undefined' ||
        lower == 'no' ||
        lower == 'n/a') {
      return null;
    }

    // Strip query parameters and hash fragments to check the actual file path
    final cleanPath = lower.split('?').first.split('#').first;

    // Check if the URL/file points to a non-video format (e.g. PDF, documents, static images)
    const nonVideoExtensions = [
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
      '.txt',
      '.zip',
      '.rar',
      '.csv',
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.gif',
      '.svg',
      '.bmp',
      '.ico',
    ];
    for (final ext in nonVideoExtensions) {
      if (cleanPath.endsWith(ext)) {
        return null;
      }
    }

    // Special check: prevent URLs pointing to a root 0 or invalid path like https://www.ethiochef.com/0 or /0
    if (cleanPath == '/0' || cleanPath.endsWith('/0')) {
      return null;
    }

    // If it's already an absolute HTTP/HTTPS URL
    if (str.startsWith('http://') || str.startsWith('https://')) {
      return str;
    }

    // Direct YouTube video ID (standard 11-char alphanumeric + '-' or '_')
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(str)) {
      return 'https://www.youtube.com/watch?v=$str';
    }

    // Relative path on server (e.g. /uploads/video.mp4 or uploads/video.mp4)
    if (str.startsWith('/')) {
      return '${Constants.ImageAPI}$str';
    } else if (str.startsWith('uploads/') ||
        str.startsWith('storage/') ||
        str.startsWith('videos/')) {
      return '${Constants.ImageAPI}/$str';
    }

    // Fallback: If it has a known video extension (e.g. "myvideo.mp4")
    const videoExtensions = [
      '.mp4',
      '.m4v',
      '.mov',
      '.webm',
      '.mkv',
      '.avi',
      '.3gp',
      '.ts',
      '.m3u8',
      '.flv',
    ];
    for (final ext in videoExtensions) {
      if (cleanPath.endsWith(ext)) {
        return '${Constants.ImageAPI}/$str';
      }
    }

    // Any other arbitrary non-path string (like random text or numbers) is not a valid video
    return null;
  }

  factory Food.fromSingleFoodJson(Map<String, dynamic> json) {
    print("==============================================================");
    print("==============================================================");
    print("Likes = ${json['likes']}");
    print("==============================================================");
    print("==============================================================");
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }

    String image = json['image'];

    String i = clearPath(image);
    int meal = 0;

    if (json.containsKey('meal_time') &&
        json['meal_time']['breakfast'] == true) {
      meal = 1;
    } else if (json.containsKey('meal_time') &&
        json['meal_time']['lunch'] == true) {
      meal = 2;
    } else if (json.containsKey('meal_time') &&
        json['meal_time']['super'] == true) {
      meal = 3;
    } else {
      meal = 4;
    }
    String thumbnail = Constants.ImageAPI + i;
    // print('CHECKING VIDEO FROM API: ${json['steps']['en']["0"]}');
    print('parsing food');
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'] is String
          ? int.parse(json['subcategories_id'])
          : json['subcategories_id'] ??
              (json['subcategories-id'] is String
                  ? int.parse(json['subcategories-id'])
                  : json['subcategories-id'] ?? 0),
      categoryId: json['category_id'] is String
          ? int.parse(json['category_id'])
          : json['category_id'] ?? 0,
      // name: json['name'][Language.getLocaleCode()] ?? json['name']["en"],
      // description:
      //     json['description'][Language.getLocaleCode()] ??
      //     json['description']["en"],
      name: json['name'],
      description: json['description'],
      mealTime: meal,
      related_recipe: json.containsKey('similar_recipies')
          ? (json['similar_recipies'] as List)
                .map((product) => Food.fromRelatedRecipe(product))
                .toList()
          : [],
      preparationTime: json['cooking_time'] is String
          ? int.parse(json['cooking_time'])
          : json['cooking_time'] ?? 0,
      video: parseVideoUrl(
        json['video'] ??
            json['video_url'] ??
            json['videoUrl'] ??
            json['video_link'] ??
            json['youtube_url'] ??
            json['youtube_link'] ??
            json['youtube'] ??
            json['link'],
      ),
      servings: json['serving'] is String
          ? int.parse(json['serving'])
          : json['serving'] ?? 0,
      stepsList: json['steps'] != null && json['steps'] is List
          ? {
              for (int i = 0; i < (json['steps'] as List).length; i++)
                i.toString(): json['steps'][i]['step'],
            }
          : null,
      ingredients: json['ingredients'] != null && json['ingredients'] is List
          ? {
              for (int i = 0; i < (json['ingredients'] as List).length; i++)
                i.toString():
                    json['ingredients'][i]['step'] ??
                    json['ingredients'][i]['ingredient'] ??
                    json['ingredients'][i].toString(),
            }
          : null,
      thumbnail: thumbnail,
      likes: json.containsKey('likes')
          ? List<Likes>.from(
              json['likes']?.map((dynamic like) => Likes.fromFood(like)) ?? [],
            )
          : [],
      comments: json['comments'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
      nextPage: json['next_page'] ?? 0,
      prevPage: json['prev_page'] ?? 0,
      page: json['page'],
    );
  }
  factory Food.fromRelatedRecipe(Map<String, dynamic> json) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }

    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    int meal = 0;

    if (json['meal_time']['breakfast'] == true) {
      meal = 1;
    } else if (json['meal_time']['lunch'] == true) {
      meal = 2;
    } else if (json['meal_time']['super'] == true) {
      meal = 3;
    } else {
      meal = 4;
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'],
      categoryId: json['category_id'] ?? 0,
      name: json['name'][Language.getLocaleCode()] ?? json['name']["en"],
      description:
          json['description'][Language.getLocaleCode()] ??
          json['description']['en'] ??
          '',
      mealTime: meal,
      thumbnail: thumbnail,
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

    if (json.containsKey('meal_time') &&
        json['meal_time']['breakfast'] == true) {
      meal = 1;
    } else if (json.containsKey('meal_time') &&
        json['meal_time']['lunch'] == true) {
      meal = 2;
    } else if (json.containsKey('meal_time') &&
        json['meal_time']['super'] == true) {
      meal = 3;
    } else {
      meal = 4;
    }
    return Food(
      id: json['id'],
      subcategoriesId: json['subcategories_id'] is String
          ? int.parse(json['subcategories_id'])
          : json['subcategories_id'],
      categoryId: json['category_id'] is String
          ? int.parse(json['category_id'])
          : json['category_id'],
      // name: json['name'],
      name: json['name'][Language.getLocaleCode()] ?? json['name']["en"],
      description:
          json['description'][Language.getLocaleCode()] ??
          json['description']['en'] ??
          '',
      // description: json['description'],
      mealTime: meal,
      preparationTime: json['cooking_time'] is String
          ? int.parse(json['cooking_time'])
          : json['cooking_time'],
      servings: json['serving'] is String
          ? int.parse(json['serving'])
          : json['serving'],
      thumbnail: thumbnail,
      video: parseVideoUrl(
        json['video'] ??
            json['video_url'] ??
            json['videoUrl'] ??
            json['video_link'] ??
            json['youtube_url'] ??
            json['youtube_link'] ??
            json['youtube'] ??
            json['link'],
      ),
      likes: List<Likes>.from(
        json['likes']?.map((dynamic like) => Likes.fromFood(like)) ?? [],
      ),
      comments: json['comments'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nextPage: json['next_page'] ?? 0,
      prevPage: json['prev_page'] ?? 0,
      page: json['page'],
    );
  }
  factory Food.fromMealJson(
    Map<String, dynamic> json,
    int type,
    bool fromNotif,
  ) {
    Logger().d(json['name'][Language.getLocaleCode()] ?? 'null');
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }

    String image = json['image'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    int meal = 0;
    if (type == 1) {
      meal = 1;
    } else if (type == 2) {
      meal = 2;
    } else if (type == 3) {
      meal = 3;
    } else {
      meal = 4;
    }

    return Food(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      subcategoriesId: json['subcategories_id'] is String
          ? int.parse(json['subcategories_id'])
          : json['subcategories_id'],
      categoryId: json['category_id'] is String
          ? int.parse(json['category_id'])
          : json['category_id'],
      name: json['name'][Language.getLocaleCode()] ?? 'null',
      description:
          json['description'][Language.getLocaleCode()] ??
          json['description']['am'],
      mealTime: meal,
      preparationTime: json['cooking_time'] is String
          ? int.parse(json['cooking_time'])
          : json['cooking_time'],
      servings: json['serving'] is String
          ? int.parse(json['serving'])
          : json['serving'],
      thumbnail: thumbnail,
      video: parseVideoUrl(
        json['video'] ??
            json['video_url'] ??
            json['videoUrl'] ??
            json['youtube_url'],
      ),
      likes: List<Likes>.from(
        json['likes']?.map((dynamic like) => Likes.fromFood(like)) ?? [],
      ),
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
    if (json['breakfast'] == true) {
      meal = 1;
    } else if (json['lunch'] == true) {
      meal = 2;
    } else if (json['super'] == true) {
      meal = 3;
    } else {
      meal = 4;
    }
    String description = '';
    // if (Language.getLocaleCode() == 'en') {
    //   Name = json['name_en'];
    //   description = json['description_en'];
    // } else if (Language.getLocaleCode() == 'am') {
    //   Name = json['name_am'];
    //   description = json['description_am'];
    // } else if (Language.getLocaleCode() == 'tr') {
    //   Name = json['name_tr'];
    //   description = json['description_tr'];
    // } else {
    //   Name = json['name_or'];
    //   description = json['description_or'];
    // }
    return Food(
      id: json['id'],
      subcategoriesId: json['sub_category_id'] is String
          ? int.parse(json['sub_category_id'])
          : json['sub_category_id'],
      categoryId: json['category_id'] is String
          ? int.parse(json['category_id'])
          : json['category_id'],
      name: json['name'],
      Name: json['description'],
      description: description,
      mealTime: meal,
      thumbnail: thumbnail,
      video: parseVideoUrl(
        json['video'] ??
            json['video_url'] ??
            json['videoUrl'] ??
            json['youtube_url'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subcategoriesId': subcategoriesId,
    'categoryId': categoryId,
    'name': jsonEncode(name),
    'Name': Name,
    'description': description,
    'mealTime': mealTime,
    // 'related_recipe': related_recipe?.map((recipe) => recipe.toJson()).toList(), // or jsonEncode(related_recipe)
    'stepsList': jsonEncode(stepsList),
    'ingredients': jsonEncode(ingredients),
    'servings': servings,
    'preparationTime': preparationTime,
    'posterImage': posterImage,
    'image': thumbnail,
    'video': video,
    // 'likes': likes?.map((like) => jsonEncode(likes)).toList(), // or jsonEncode(likes)
    'comments': jsonEncode(comments),
    // 'createdAt': createdAt,
    // 'updatedAt': updatedAt,
    'nextPage': nextPage,
    'prevPage': prevPage,
    'page': page,
    'isLiked': isLiked,
  };
  factory Food.fromSavedJson(Map<String, dynamic> json) {
    return Food(
      subcategoriesId: json['subcategoriesId'],
      id: json['id'],
      categoryId: json['categoryId'],
      name: jsonDecode(json['name']),
      description: json['description'],
      mealTime: json['mealTime'],
      thumbnail: json['image'],
      servings: json['servings'],
      stepsList: jsonDecode(json['stepsList']),
      ingredients: jsonDecode(json['ingredients']),
      preparationTime: json['preparationTime'],
      posterImage: json['posterImage'],
      video: parseVideoUrl(json['video']),
      comments: jsonDecode(json['comments']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
      page: json['page'],
      isLiked: json['isLiked'],
    );
  }

  static List<Food> savedRecipes = [];

  static void addRecipe(Food food) {
    savedRecipes.add(food);
    saveRecipesToSharedPrefs();
  }

  static List<Food> getSavedRecipes() {
    return savedRecipes;
  }

  static void deleteRecipe(Food food) {
    print("deleteRecipe");
    savedRecipes.remove(food);
    saveRecipesToSharedPrefs();
  }

  static void saveRecipesToSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = json.encode(
      Food.savedRecipes.map((food) => food.toJson()).toList(),
    );
    await sharedPreferences.setString('bookmarkRecipes', jsonString);
  }

  static bool isSameFood(Food food1, Food food2) {
    return food1.id == food2.id;
  }

  static Future<List<Food>> loadRecipesFromSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString('bookmarkRecipes') ?? '[]';
    final recipes = json.decode(jsonString) as List<dynamic>;
    return recipes.map((recipe) => Food.fromSavedJson(recipe)).toList();
  }
}

class Likes {
  int id;
  int user_id;
  int food_id;
  Likes({required this.id, required this.user_id, required this.food_id});
  factory Likes.fromFood(Map<String, dynamic> json) {
    return Likes(
      id: json['id'],
      user_id: json['user_id'] is String
          ? int.parse(json['user_id'])
          : json['user_id'],
      food_id: json['food_id'] is String
          ? int.parse(json['food_id'])
          : json['food_id'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': user_id,
    'food_id': food_id,
  };
}
