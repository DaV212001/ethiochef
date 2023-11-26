
import 'package:ethio_chef/constants/constants.dart';
import 'package:ethio_chef/models/language.dart';

class Category {
  final int id;
  final String name;
  final String description;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? nextPage;
  final int? prevPage;
  final int? page;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.createdAt,
    this.updatedAt,
    this.nextPage,
    this.prevPage,
    this.page,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // print("json $json");
    print(json['id']);
    print(json['name']);
    String image = Constants.url + json['image'];
    return Category(
        id: json['id'],
        name: json['name'][Language.getLocaleCode()] == ""?json['name']["en"]:json['name'][Language.getLocaleCode()]?? "no localisation",
        description: json['description'][Language.getLocaleCode()]?? "no localisation",
        image: image,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        nextPage: json['next_page'] ?? 0,
        prevPage: json['prev_page'] ?? 0,
        page: json['page']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'next_page': nextPage,
      'prev_page': prevPage,
      'page': page,
    };
  }

}

