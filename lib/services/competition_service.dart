import 'dart:convert';

import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';
class CompetitionService {
  Future<List<Competition>> fetchCompetitions(int pageKey) async {
    List<Competition>? competitionslist;
    try {
      var res = await http.get(
          Uri.parse("${Constants.url}/user/contest/competiton"));
      print("res.statusCode  == = == = = = == = = = ${res.statusCode}");
      print(res.body);
      var data = jsonDecode(res.body);
      if (data['message'] == 'All user video get successful') {
        var categoriesData = data['data'] as List;
        competitionslist = categoriesData.map((categoryData) =>
            Competition.fromJson(categoryData)).toList();
      } else {
        throw Exception('Unexpected message from API: ${data['message']}');
      }
    } catch (e) {
      throw Exception(e);
    }


    if (pageKey > competitionslist.length) {
      throw Exception();
    }

    await Future.delayed(Duration(seconds: 1));
    return competitionslist;
  }

  Future<http.Response> sendCompetitionVideo(String video_string) async {
    var access_token = await AuthService.getAuthorizationToken();
    var body = json.encode({"video": video_string});
    print("Body");
    print(body);
    final response = await http.post(
        Uri.parse("${Constants.url}/user/contest/upload"),
        headers: {
          'Authorization': 'JWT $access_token'
        },
        body: {"video": video_string});
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){

    }
    return response;
  }
  Future<http.Response>? likeCompetition(int id) async {
    var access_token = await AuthService.getAuthorizationToken();
    final response;
    try {
      response = await http.post(
        Uri.parse("${Constants.url}/user/contest/like"),
        headers: {
          'Authorization': 'JWT $access_token'
        },
        body: {
          "contest_id": id.toString()
        },
      );
      print("res.statusCode  == = == = = == = = = ${response.statusCode}");
      print("response.body  == = == = = == = = = ${response.body}");
      var message = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception('${response.statusCode.toString()}: ${message['message']}');
      }
    } catch (error) {
      rethrow;
    }
    return response;
  }

  Future<http.Response>? voteContestant(int contestant_id, int contest_id) async {
    print("voteContestant");
    var access_token = await AuthService.getAuthorizationToken();
    final response;
    try {
      response = await http.post(
        Uri.parse("${Constants.url}/user/contest/vote"),
        headers: {
          'Authorization': 'JWT $access_token'
        },
        body: {
          "contestant_id": contestant_id.toString(),
          "contest_id": contest_id.toString()
        },
      );
      print("res.statusCode  == = == = = == = = = ${response.statusCode}");
      print("res.body  == = == = = == = = = ${response.body}");
      var message = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception('${response.statusCode.toString()}: ${message['message']}');
      }
    } catch (error) {
      rethrow;
    }
    return response;
  }

///I don't think the current response from this API is correct so this is a template to be fixed
  Future<Competition> getCompetitionUsingId (int id) async {
    final response;
    try {
      response = await http.get(
        Uri.parse("${Constants.url}/user/contest/$id"),
      );
      print("res.statusCode  == = == = = == = = = ${response.statusCode}");
      var message = jsonDecode(response.body);
      if (response.statusCode != 200) {

        throw Exception('${response.statusCode.toString()}: ${message['message']}');
      }
      else {
        return Competition.fromJson(jsonDecode(response.body)['data']);
      }
    } catch (error) {
      rethrow;
    }
    }

    Future<List<Competition>?>? getCompetitionByUserId() async {
      List<Competition>? competitionslist;
      var access_token = await AuthService.getAuthorizationToken();
      UserService userserve = UserService();
      User user = await userserve.fetchLoggedInUser();
      try {
        final response = await http
            .get(
            Uri.parse(
                "${Constants.url}/user/contest/user/${user.id}"),
            headers: {
              'Authorization': 'JWT $access_token',
            });
        print(response.body);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          print("Competitions Retrieved ${jsonData['data']}");
          var competitionData = jsonData['data'] as List;
          competitionslist = competitionData.map((subscriptionPlansData) =>
              Competition.fromJson(subscriptionPlansData))
              .toList();
        }
        else {
          throw Exception(response.statusCode.toString());
        }
      } catch (error) {
        rethrow;
      }
      return competitionslist;
    }
}
