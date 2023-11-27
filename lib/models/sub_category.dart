import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import 'language.dart';

class SubCategory {
  final int id;
  final int categoryId;
  final String name;
  final String thumbnail;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int nextPage;
  final int prevPage;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.nextPage,
    required this.prevPage,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['image'];
    String i = clearPath(image);
    print("============================== $i");
    print(json['id']);
    print(json['name']);
    String thumbnail = Constants.ImageAPI + i;
    print("============================== $thumbnail");

    return SubCategory(
        id: json['id'] ?? 0,
        categoryId: json['category_id'],
        name: json['name'][Language.getLocaleCode()] == ""?json['name']["en"]:json['name'][Language.getLocaleCode()]?? json['name']["en"],
        thumbnail: thumbnail,
        description: json['description'][Language.getLocaleCode()]?? json['name']["en"],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        nextPage: json['next_page'] ?? 0,
        prevPage: json['prev_page'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'image': thumbnail,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'next_page': nextPage,
      'prev_page': prevPage,
    };
  }

}