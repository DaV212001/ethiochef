import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/comment.dart';

class CommentService{

  Future<List<Comments>> fetchComments(int foodId) async {
    final response = await http.get(Uri.parse('${Constants.url}/user/food/comment/$foodId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final commentsData = jsonData['data'] as List<dynamic>;
      return commentsData.map((comment) => Comments.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to fetch comments: ${response.statusCode}');
    }
  }

  Future<List<Comments>> fetchComments(int foodId) async {
    final response = await http.get(Uri.parse('${Constants.url}/user/food/comment/$foodId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final commentsData = jsonData['data'] as List<dynamic>;
      return commentsData.map((comment) => Comments.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to fetch comments: ${response.statusCode}');
    }
  }
}