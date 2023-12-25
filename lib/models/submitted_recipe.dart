import '../utils/constants.dart';

class MySubmittedRecipe {
  int id;
  int userId;
  String title;
  String? video; // Optional field
  String image;
  String poster;
  String description;
  int serving;
  Map<String, String> ingredients;
  Map<String, String> steps;
  int cookingTime;
  DateTime createdAt;
  DateTime updatedAt;
  bool approved;


  MySubmittedRecipe({required this.id, required this.userId, required this.title, required this.video, required this.image,
    required this.poster, required this.description, required this.serving, required this.ingredients, required this.steps,
    required this.cookingTime, required this.createdAt, required this.updatedAt, required this.approved});

  factory MySubmittedRecipe.fromJson(Map<String, dynamic> json) {

    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    print(i);
    String thumbnail = Constants.ImageAPI + i;
    print(thumbnail);
    return MySubmittedRecipe(
        id : json['id'],
        userId : json['user_id'],
        title : json['title'],
        video : json['video'], // Handle null values gracefully
        image : thumbnail,
        poster : json['poster'],
        description : json['description'],
        serving : json['serving'],
        ingredients : json['ingredients'].cast<String, String>(),
        steps : json['steps'].cast<String, String>(),
        cookingTime : json['cooking_time'],
        createdAt : DateTime.parse(json['created_at']),
        updatedAt : DateTime.parse(json['updated_at']),
        approved : json['approved']
    );
  }
}
