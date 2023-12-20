import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../models/comment.dart';
import 'authorization_service.dart';

class CommentService{
  Future<List<Comments>> fetchComments(int food_id) async {
    print("Food id = $food_id");

    final accessToken = await AuthService.getAuthorizationToken();
    print("access_token $accessToken");
    final response = await http.get(
        Uri.parse('${Constants.url}/user/food/comment/$food_id'),
      headers: {
        'Authorization': 'JWT $accessToken',
      },
    );
    print("response.statusCode = ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> commentsData = jsonData['data'];
      print("commentsData $commentsData");
      return commentsData.map((comment) => Comments.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to fetch comments');
    }
  }
  Future<bool> createComment(int food_id, String comment) async {
    print(food_id);
    print(comment);
    try{
      var requestBody = jsonEncode({
        "food_id": food_id,
        "comment": comment
      });
      print(requestBody);
      final accessToken = await AuthService.getAuthorizationToken();
      print("access_token $accessToken");
      var response = await http.post(
          Uri.parse('https://apiv2.ethiochef.com/user/food/comment/create'),
          headers: {
            'Authorization': 'JWT $accessToken',
            'Content-type': 'application/json'
          },
          body: requestBody
      );
      print("Response Body  == ${response.body} == Response Body");
      print("Response statusCode  == ${response.statusCode} == Response statusCode");
      if(response.statusCode == 200){
        return true;
      }
    }catch(e){
      print(e);
      return false;
    }
    return false;

  }

  Future<http.Response> updateComment(int comment_id, int food_id, String comment) async {
    var requestBody = jsonEncode({
      "food_id": food_id,
      "comment": comment
    });
    print(requestBody);
  final accessToken = await AuthService.getAuthorizationToken();
  print("access_token $accessToken");
  var response = await http.post(
      Uri.parse('${Constants.url}/user/food/comment/update/$comment_id'),
      headers: {
      'Authorization': 'JWT $accessToken',
        'Content-type': 'application/json'
      },
      body: jsonEncode({
        "food_id": food_id,
        "comment": comment
      })
  );
  return response;

  }
  Future<http.Response> deleteComment(int food_id) async {

  final accessToken = await AuthService.getAuthorizationToken();
  print("access_token $accessToken");

  var response = await http.delete(
        Uri.parse('${Constants.url}/user/food/comment/delete/$food_id'),
      headers: {
        'Authorization': 'JWT $accessToken'
      },
  );
    return response;
  }
}