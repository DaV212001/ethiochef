import 'dart:async';
import 'dart:convert';
import 'package:ethio_chef/models/user.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'food.dart';

class Comments {
  final int id;
  final int userId;
  final String comment;
  final int foodId;
  final User user;
  // final Food food;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comments({
    required this.id,
    required this.userId,
    required this.comment,
    required this.foodId,
    required this.user,
    // required this.food,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    // final foodJson = json['food'] as Map<String, dynamic>;

    return Comments(
      id: json['id'],
      userId: json['user_id'],
      comment: json['comment'],
      foodId: json['food_id'],
      user: User.fromJson(userJson),
      // food: Food.fromCommentJson(foodJson),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
